import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/hive_setup.dart';
import '../utils/stock_input_formatter.dart';

class EditProductDialog extends StatefulWidget {
  final Product product;

  const EditProductDialog({super.key, required this.product});

  @override
  State<EditProductDialog> createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  late TextEditingController _nameController;
  late TextEditingController _thresholdController;
  String? _nameError;
  String? _thresholdError;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _thresholdController = TextEditingController(
      text: widget.product.targetStock.toString(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _thresholdController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    final trimmedName = _nameController.text.trim();
    if (trimmedName.isEmpty) {
      setState(() => _nameError = 'Product name cannot be empty');
      return;
    }

    final newThreshold = int.tryParse(_thresholdController.text);
    if (newThreshold == null || newThreshold < 1 || newThreshold > 99) {
      setState(() => _thresholdError = 'Must be between 1 and 99');
      return;
    }

    // Check for duplicate name in same company (excluding self)
    final box = Hive.box<Product>('products');
    final isDuplicate = box.values.any(
      (p) =>
          p.id != widget.product.id &&
          p.companyId == widget.product.companyId &&
          p.name.trim().toLowerCase() == trimmedName.toLowerCase(),
    );

    if (isDuplicate) {
      setState(() => _nameError = 'Product name already exists in this company');
      return;
    }

    // Update fields
    widget.product.name = trimmedName;
    widget.product.targetStock = newThreshold;

    await widget.product.save();

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Product'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Product Name',
                errorText: _nameError,
              ),
              textCapitalization: TextCapitalization.sentences,
              onChanged: (_) {
                if (_nameError != null) setState(() => _nameError = null);
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _thresholdController,
              decoration: InputDecoration(
                labelText: 'Target Threshold',
                helperText: 'Max stock for this shelf (1 - 99)',
                errorText: _thresholdError,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: StockInputFormatter.formatters,
              onChanged: (_) {
                if (_thresholdError != null) {
                  setState(() => _thresholdError = null);
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _saveProduct,
          child: const Text('Save'),
        ),
      ],
    );
  }
}

// Helper function
void showEditProductDialog(BuildContext context, Product product) {
  showDialog(
    context: context,
    builder: (context) => EditProductDialog(product: product),
  );
}
