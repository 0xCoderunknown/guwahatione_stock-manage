import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../widgets/edit_product_dialog.dart';
import '../data/hive_setup.dart';
import 'move_stock_screen.dart';

class ProductListScreen extends StatelessWidget {
  final String companyId;
  final String companyName;

  const ProductListScreen({
    super.key,
    required this.companyId,
    required this.companyName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(companyName)),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Product>('products').listenable(),
        builder: (context, Box<Product> box, _) {
          // Filter and Sort Logic
          final products = box.values
              .where((p) => p.companyId == companyId)
              .toList();
          products.sort((a, b) {
            final double stockA =
                a.targetStock <= 0 ? 0.0 : a.stock / a.targetStock;
            final double stockB =
                b.targetStock <= 0 ? 0.0 : b.stock / b.targetStock;
            return stockA.compareTo(stockB);
          });

          if (products.isEmpty) {
            return const Center(
              child: Text("No products for this company yet."),
            );
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final double fillRate = product.targetStock <= 0
                  ? 0.0
                  : (product.stock / product.targetStock).clamp(0.0, 1.0);

              Color statusColor;
              if (fillRate < 0.25) {
                statusColor = Colors.red;
              } else if (fillRate < 0.5) {
                statusColor = Colors.orange;
              } else {
                statusColor = Colors.green;
              }

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                clipBehavior: Clip.antiAlias, // Needed for InkWell ripple
                child: InkWell(
                  // --- THE MAGIC LINK ---
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MoveStockScreen(
                          initialProductId: product.id, // Pass the ID!
                        ),
                      ),
                    );
                  },
                  onLongPress: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.edit),
                              title: const Text('Edit Details'),
                              onTap: () {
                                Navigator.pop(context); // Close sheet
                                showEditProductDialog(context, product);
                              },
                            ),
                            ListTile(
                              leading: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              title: const Text(
                                'Delete Product',
                                style: TextStyle(color: Colors.red),
                              ),
                              onTap: () {
                                Navigator.pop(context); // Close sheet
                                _showDeleteConfirmDialog(context, product);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "${product.stock} / ${product.targetStock}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: fillRate,
                          backgroundColor: Colors.grey[200],
                          color: statusColor,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Delete ${product.name}?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              final name = product.name;
              await product.delete();
              if (dialogContext.mounted) {
                Navigator.pop(dialogContext);
              }
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Deleted $name')),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
