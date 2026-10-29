import 'package:flutter/material.dart';

import '../utils/stock_input_formatter.dart';

/// Interactive card handling direction toggle, quantity input, and transfer submission.
class StockTransferCard extends StatefulWidget {
  final void Function(int quantity, bool isMovingToShop) onTransfer;

  const StockTransferCard({super.key, required this.onTransfer});

  @override
  State<StockTransferCard> createState() => _StockTransferCardState();
}

class _StockTransferCardState extends State<StockTransferCard> {
  final TextEditingController _quantityController = TextEditingController();
  bool _isMovingToShop = false;

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final input = int.tryParse(_quantityController.text);
    if (input == null || input <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid positive quantity')),
      );
      return;
    }
    if (input > 99) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quantity cannot exceed 99')),
      );
      return;
    }

    widget.onTransfer(input, _isMovingToShop);
    _quantityController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: ChoiceChip(
                label: const Center(child: Text('Add to Home')),
                selected: !_isMovingToShop,
                onSelected: (selected) {
                  if (selected) setState(() => _isMovingToShop = false);
                },
                selectedColor: Colors.green.shade100,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ChoiceChip(
                label: const Center(child: Text('Move to Shop')),
                selected: _isMovingToShop,
                onSelected: (selected) {
                  if (selected) setState(() => _isMovingToShop = true);
                },
                selectedColor: Colors.red.shade100,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _quantityController,
          keyboardType: TextInputType.number,
          autofocus: true,
          inputFormatters: StockInputFormatter.formatters,
          decoration: InputDecoration(
            labelText: 'Quantity',
            border: const OutlineInputBorder(),
            prefixIcon: Icon(_isMovingToShop ? Icons.remove : Icons.add),
          ),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: _handleSubmit,
          style: FilledButton.styleFrom(
            backgroundColor: _isMovingToShop
                ? Colors.red.shade700
                : Colors.green.shade700,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: Text(
            _isMovingToShop ? 'Move to Shop' : 'Add to Home',
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
