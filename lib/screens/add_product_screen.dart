import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/hive_setup.dart';
import '../provider/providers.dart';
import '../utils/stock_input_formatter.dart';

class AddProductDialog extends ConsumerStatefulWidget {
  const AddProductDialog({super.key});

  @override
  ConsumerState<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends ConsumerState<AddProductDialog> {
  final _nameController = TextEditingController();
  final _targetStockController = TextEditingController(text: '10');
  String? _selectedCompanyId;
  List<Company> _companies = [];

  @override
  void initState() {
    super.initState();
    _loadCompanies();
  }

  void _loadCompanies() {
    final companyBox = Hive.box<Company>('companies');
    setState(() {
      _companies = companyBox.values.toList();
      // STICKY SELECTION: Try to load from provider first
      final lastId = ref.read(lastSelectedCompanyProvider);
      if (lastId != null && _companies.any((c) => c.id == lastId)) {
        _selectedCompanyId = lastId;
      } else if (_companies.isNotEmpty) {
        _selectedCompanyId = _companies.first.id;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_companies.isEmpty) {
      return AlertDialog(
        title: const Text('No Companies'),
        content: const Text('Please add a company first.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      );
    }

    return AlertDialog(
      title: const Text('Add Product'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InputDecorator(
              decoration: const InputDecoration(labelText: 'Select Company'),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCompanyId,
                  isDense: true,
                  items: _companies
                      .map(
                        (c) =>
                            DropdownMenuItem(value: c.id, child: Text(c.name)),
                      )
                      .toList(),
                  onChanged: (val) => setState(() => _selectedCompanyId = val),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Product Name'),
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _targetStockController,
              decoration: const InputDecoration(
                labelText: 'Target Stock / Max',
                helperText: 'Max 99',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: StockInputFormatter.formatters,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _saveProduct, child: const Text('Save')),
      ],
    );
  }

  Future<void> _saveProduct() async {
    if (_nameController.text.isEmpty || _selectedCompanyId == null) return;

    // VALIDATION: 1-99
    final targetStock = int.tryParse(_targetStockController.text) ?? 10;
    if (targetStock < 1 || targetStock > 99) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Target stock must be between 1 and 99')),
      );
      return;
    }

    // DUPLICATE CHECK
    final box = Hive.box<Product>('products');
    final newName = _nameController.text.trim();

    final isDuplicate = box.values.any(
      (p) =>
          p.companyId == _selectedCompanyId &&
          p.name.trim().toLowerCase() == newName.toLowerCase(),
    );

    if (isDuplicate) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Duplicate Product'),
          content: Text(
            'A product named "$newName" already exists in this company.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final newProduct = Product(
      id: const Uuid().v4(),
      companyId: _selectedCompanyId!,
      name: newName,
      // Use trimmed name
      stock: 0,
      targetStock: targetStock,
    );

    await box.put(newProduct.id, newProduct);

    // SAVE STICKY SELECTION
    ref.read(lastSelectedCompanyProvider.notifier).state = _selectedCompanyId;

    if (mounted) Navigator.pop(context);
  }
}
