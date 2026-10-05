import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/hive_setup.dart';
import 'color_picker_widget.dart';

class EditCompanyDialog extends StatefulWidget {
  final Company company;

  const EditCompanyDialog({super.key, required this.company});

  @override
  State<EditCompanyDialog> createState() => _EditCompanyDialogState();
}

class _EditCompanyDialogState extends State<EditCompanyDialog> {
  late final TextEditingController _nameController;
  int? _selectedColorValue;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.company.name);
    _selectedColorValue = widget.company.colorValue;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveCompany() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() {
        _errorMessage = 'Company name cannot be empty';
      });
      return;
    }

    final box = Hive.box<Company>('companies');
    final isDuplicate = box.values.any(
      (c) =>
          c.id != widget.company.id &&
          c.name.trim().toLowerCase() == name.toLowerCase(),
    );

    if (isDuplicate) {
      setState(() {
        _errorMessage = 'A company with this name already exists';
      });
      return;
    }

    widget.company.name = name;
    widget.company.colorValue = _selectedColorValue;
    await widget.company.save();

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Company'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Company Name',
                errorText: _errorMessage,
              ),
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              onChanged: (_) {
                if (_errorMessage != null) {
                  setState(() => _errorMessage = null);
                }
              },
            ),
            const SizedBox(height: 24),
            ColorPickerWidget(
              selectedColorValue: _selectedColorValue,
              onColorChanged: (val) =>
                  setState(() => _selectedColorValue = val),
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
          onPressed: _saveCompany,
          child: const Text('Save'),
        ),
      ],
    );
  }
}

void showEditCompanyDialog(BuildContext context, Company company) {
  showDialog(
    context: context,
    builder: (context) => EditCompanyDialog(company: company),
  );
}
