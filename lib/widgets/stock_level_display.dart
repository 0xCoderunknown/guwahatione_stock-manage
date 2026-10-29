import 'package:flutter/material.dart';

import '../data/hive_setup.dart';

/// Reusable visual gauge displaying a product's current stock vs target capacity.
class StockLevelDisplay extends StatelessWidget {
  final Product product;

  const StockLevelDisplay({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final target = product.targetStock;
    final double fillRate = target <= 0
        ? 0.0
        : (product.stock / target).clamp(0.0, 1.0);
    final bool isLowStock = target > 0 && product.stock <= (target * 0.25);

    return Center(
      child: Column(
        children: [
          const Text('Current Stock', style: TextStyle(color: Colors.grey)),
          Text(
            '${product.stock} / ${product.targetStock}',
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
            child: LinearProgressIndicator(
              value: fillRate,
              color: isLowStock ? Colors.red : Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
