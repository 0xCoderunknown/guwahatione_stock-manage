import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../widgets/edit_product_dialog.dart';
import '../data/hive_setup.dart';
import 'move_stock_screen.dart';

class ProductListScreen extends StatefulWidget {
  final String companyId;
  final String companyName;

  const ProductListScreen({
    super.key,
    required this.companyId,
    required this.companyName,
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  bool _filterNeedsRestockOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.companyName)),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Product>('products').listenable(),
        builder: (context, Box<Product> box, _) {
          final allCompanyProducts = box.values
              .where((p) => p.companyId == widget.companyId)
              .toList();

          var products = allCompanyProducts;
          if (_filterNeedsRestockOnly) {
            products = products
                .where(
                  (p) => p.targetStock > 0 && p.stock <= (p.targetStock * 0.2),
                )
                .toList();
          }

          products.sort((a, b) {
            final double stockA = a.targetStock <= 0
                ? 0.0
                : a.stock / a.targetStock;
            final double stockB = b.targetStock <= 0
                ? 0.0
                : b.stock / b.targetStock;
            return stockA.compareTo(stockB);
          });

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                    FilterChip(
                      label: Text('All (${allCompanyProducts.length})'),
                      selected: !_filterNeedsRestockOnly,
                      onSelected: (val) {
                        if (!_filterNeedsRestockOnly) return;
                        setState(() => _filterNeedsRestockOnly = false);
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: Text(
                        '⚠️ Needs Restock (${allCompanyProducts.where((p) => p.targetStock > 0 && p.stock <= (p.targetStock * 0.2)).length})',
                      ),
                      selected: _filterNeedsRestockOnly,
                      selectedColor: Colors.amber.shade100,
                      onSelected: (val) {
                        setState(() => _filterNeedsRestockOnly = val);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: products.isEmpty
                    ? Center(
                        child: Text(
                          _filterNeedsRestockOnly
                              ? 'No products currently need restocking.'
                              : 'No products for this company yet.',
                        ),
                      )
                    : ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          final double fillRate = product.targetStock <= 0
                              ? 0.0
                              : (product.stock / product.targetStock).clamp(
                                  0.0,
                                  1.0,
                                );
                          final bool needsRestock =
                              product.targetStock > 0 &&
                              product.stock <= (product.targetStock * 0.2);

                          Color statusColor;
                          if (fillRate < 0.25) {
                            statusColor = Colors.red;
                          } else if (fillRate < 0.5) {
                            statusColor = Colors.orange;
                          } else {
                            statusColor = Colors.green;
                          }

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MoveStockScreen(
                                      initialProductId: product.id,
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
                                            Navigator.pop(context);
                                            showEditProductDialog(
                                              context,
                                              product,
                                            );
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
                                            Navigator.pop(context);
                                            _showDeleteConfirmDialog(
                                              context,
                                              product,
                                            );
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  product.name,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              if (needsRestock) ...[
                                                const SizedBox(width: 8),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: 2,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.red.shade50,
                                                    border: Border.all(
                                                      color:
                                                          Colors.red.shade200,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          4,
                                                        ),
                                                  ),
                                                  child: const Text(
                                                    '⚠️ Restock',
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ],
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
                      ),
              ),
            ],
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
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Deleted $name')));
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
