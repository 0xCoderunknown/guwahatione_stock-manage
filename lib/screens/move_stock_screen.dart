import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/hive_setup.dart';
import '../utils/stock_input_formatter.dart';

class MoveStockScreen extends StatefulWidget {
  // OPTIONAL: If provided, the screen starts with this product selected
  final String? initialProductId;

  const MoveStockScreen({super.key, this.initialProductId});

  @override
  State<MoveStockScreen> createState() => _MoveStockScreenState();
}

class _MoveStockScreenState extends State<MoveStockScreen> {
  String? _selectedProductId;
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _searchController =
      TextEditingController(); // NEW: Search
  bool _isMovingToShop = false;
  String _searchQuery = ''; // NEW: Search Query state

  @override
  void initState() {
    super.initState();
    _selectedProductId = widget.initialProductId;

    // NEW: Listen to search changes
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _updateStock(Product product) async {
    final input = int.tryParse(_quantityController.text);
    if (input == null || input <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid positive quantity')),
      );
      return;
    }

    // VALIDATION: 1-99
    if (input > 99) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quantity cannot exceed 99')),
      );
      return;
    }

    // Capture values at the time of operation to avoid state race conditions on Undo
    final bool wasMovingToShop = _isMovingToShop;
    final int quantityMoved = input;

    int newStock = product.stock;
    String actionMessage = '';

    if (wasMovingToShop) {
      if (quantityMoved > product.stock) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cannot move more than you have!'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      newStock = product.stock - quantityMoved;
      actionMessage = 'Moved $quantityMoved to Shop';
    } else {
      newStock = product.stock + quantityMoved;
      actionMessage = 'Added $quantityMoved to Home';
    }

    final box = Hive.box<Product>('products');
    final freshProduct = box.get(product.id);
    if (freshProduct == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product no longer exists')),
        );
      }
      return;
    }

    freshProduct.stock = newStock;
    await freshProduct.save();

    // --- LOG HISTORY ---
    final historyBox = Hive.box<HistoryItem>('history');
    final historyItem = HistoryItem(
      productName: freshProduct.name,
      date: DateTime.now(),
      actionType: wasMovingToShop ? 'Moved to Shop' : 'Added to Home',
      quantityChange: wasMovingToShop ? -quantityMoved : quantityMoved,
    );
    await historyBox.add(historyItem);

    // Retention Policy: Max 100 items
    if (historyBox.length > 100) {
      await historyBox.deleteAt(0);
    }
    // -------------------

    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Clear previous
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          content: Text('$actionMessage (Stock: $newStock)'),
          action: SnackBarAction(
            label: 'UNDO',
            textColor: Colors.yellow,
            onPressed: () async {
              final currentProduct = box.get(product.id);
              if (currentProduct == null) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cannot undo: Product was deleted')),
                  );
                }
                return;
              }

              // Apply Reversal
              currentProduct.stock = wasMovingToShop
                  ? currentProduct.stock + quantityMoved
                  : currentProduct.stock - quantityMoved;
              await currentProduct.save();

              // Log Undo in history
              final undoHistoryItem = HistoryItem(
                productName: product.name,
                date: DateTime.now(),
                actionType:
                    'Undo: ${wasMovingToShop ? "Moved to Shop" : "Added to Home"}',
                quantityChange:
                    wasMovingToShop ? quantityMoved : -quantityMoved,
              );
              await historyBox.add(undoHistoryItem);
              if (historyBox.length > 100) {
                await historyBox.deleteAt(0);
              }

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Undo successful')),
                );
              }
            },
          ),
        ),
      );

      if (widget.initialProductId != null) {
        Navigator.pop(context);
      } else {
        _quantityController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Move Stock'), centerTitle: true),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Product>('products').listenable(),
        builder: (context, Box<Product> box, _) {
          final allProducts = box.values.toList();

          if (allProducts.isEmpty) {
            return const Center(child: Text('No products.'));
          }

          // Handle deletion case
          if (_selectedProductId != null &&
              !box.containsKey(_selectedProductId)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _selectedProductId = null;
                });
              }
            });
          }

          // FILTER LOGIC
          List<Product> filteredProducts = allProducts;
          if (_searchQuery.isNotEmpty) {
            filteredProducts = allProducts
                .where((p) => p.name.toLowerCase().contains(_searchQuery))
                .toList();
          }

          final selectedProduct =
              (_selectedProductId != null &&
                  box.containsKey(_selectedProductId))
              ? box.get(_selectedProductId)
              : null;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 0. Search Bar
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search Product',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // 1. Dropdown
                DropdownButtonFormField<String>(
                  key: ValueKey(_selectedProductId),
                  initialValue:
                      (filteredProducts.any((p) => p.id == _selectedProductId))
                      ? _selectedProductId
                      : null,
                  decoration: const InputDecoration(
                    labelText: 'Select Product',
                    border: OutlineInputBorder(),
                  ),
                  items: filteredProducts.map((product) {
                    return DropdownMenuItem(
                      value: product.id,
                      child: Text(product.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedProductId = value;
                    });
                  },
                ),

                const SizedBox(height: 24),

                if (selectedProduct != null) ...[
                  // 2. Stock Display
                  Builder(
                    builder: (context) {
                      final target = selectedProduct.targetStock;
                      final double fillRate = target <= 0
                          ? 0.0
                          : (selectedProduct.stock / target).clamp(0.0, 1.0);
                      final bool isLowStock =
                          target > 0 && selectedProduct.stock < (target / 4);

                      return Center(
                        child: Column(
                          children: [
                            const Text(
                              'Current Stock',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              '${selectedProduct.stock} / ${selectedProduct.targetStock}',
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 8,
                              ),
                              child: LinearProgressIndicator(
                                value: fillRate,
                                color: isLowStock ? Colors.red : Colors.green,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // 3. Action Toggle
                  Row(
                    children: [
                      Expanded(
                        child: ChoiceChip(
                          label: const Center(child: Text('Add to Home')),
                          selected: !_isMovingToShop,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _isMovingToShop = false);
                            }
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
                            if (selected) {
                              setState(() => _isMovingToShop = true);
                            }
                          },
                          selectedColor: Colors.red.shade100,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // 4. Quantity Input
                  TextField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    inputFormatters: StockInputFormatter.formatters,
                    decoration: InputDecoration(
                      labelText: 'Quantity',
                      border: const OutlineInputBorder(),
                      prefixIcon: Icon(
                        _isMovingToShop ? Icons.remove : Icons.add,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 5. Submit Button
                  FilledButton(
                    onPressed: () => _updateStock(selectedProduct),
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
              ],
            ),
          );
        },
      ),
    );
  }
}
