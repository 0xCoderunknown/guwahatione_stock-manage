import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../data/hive_setup.dart';
import 'color_picker_widget.dart';

class AddCompanyDialog extends StatefulWidget {
  const AddCompanyDialog({super.key});

  @override
  State<AddCompanyDialog> createState() => _AddCompanyDialogState();
}

class _AddCompanyDialogState extends State<AddCompanyDialog> {
  final TextEditingController _nameController = TextEditingController();
  int? _selectedColorValue; // null = Auto
  String? _errorMessage;

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
      (c) => c.name.trim().toLowerCase() == name.toLowerCase(),
    );

    if (isDuplicate) {
      setState(() {
        _errorMessage = 'A company with this name already exists';
      });
      return;
    }

    final newCompany = Company(
      id: const Uuid().v4(),
      name: name,
      colorValue: _selectedColorValue,
    );
    await box.put(newCompany.id, newCompany);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Company'),
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
              textCapitalization: TextCapitalization.sentences,
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

// Helper function to show the dialog
void showAddCompanyDialog(BuildContext context) {
  showDialog(context: context, builder: (context) => const AddCompanyDialog());
}
