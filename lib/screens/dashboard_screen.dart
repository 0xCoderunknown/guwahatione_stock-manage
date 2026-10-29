import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

// SCREEN IMPORTS
import 'add_product_screen.dart';
import 'company_list_screen.dart';
import 'move_stock_screen.dart';
import 'history_screen.dart';

// WIDGET & DATA IMPORTS
import '../data/hive_setup.dart';
import '../widgets/add_company_dialog.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StockHome'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSummaryBanner(context),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildGridCard(
                    context,
                    icon: Icons.business,
                    label: 'Add Company',
                    color: Colors.blue.shade100,
                    onTap: () => showAddCompanyDialog(context),
                  ),
                  _buildGridCard(
                    context,
                    icon: Icons.inventory_2,
                    label: 'Add Product',
                    color: Colors.green.shade100,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const AddProductDialog(),
                      );
                    },
                  ),
                  _buildGridCard(
                    context,
                    icon: Icons.swap_horiz,
                    label: 'Move Stock',
                    color: Colors.orange.shade100,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MoveStockScreen(),
                        ),
                      );
                    },
                  ),
                  _buildGridCard(
                    context,
                    icon: Icons.inventory,
                    label: 'View Stock',
                    color: Colors.purple.shade100,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CompanyListScreen(),
                        ),
                      );
                    },
                  ),
                  _buildGridCard(
                    context,
                    icon: Icons.history,
                    label: 'History',
                    color: Colors.blueGrey.shade100,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HistoryScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryBanner(BuildContext context) {
    if (!Hive.isBoxOpen('products')) return const SizedBox.shrink();

    return ValueListenableBuilder(
      valueListenable: Hive.box<Product>('products').listenable(),
      builder: (context, Box<Product> box, _) {
        final products = box.values.toList();
        final totalProducts = products.length;
        final restockCount = products
            .where((p) => p.targetStock > 0 && p.stock <= (p.targetStock * 0.2))
            .length;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: restockCount > 0
                ? Colors.amber.shade50
                : Colors.green.shade50,
            border: Border.all(
              color: restockCount > 0
                  ? Colors.amber.shade300
                  : Colors.green.shade200,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                restockCount > 0
                    ? Icons.warning_amber_rounded
                    : Icons.check_circle_outline,
                color: restockCount > 0
                    ? Colors.amber.shade800
                    : Colors.green.shade700,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  restockCount > 0
                      ? '$restockCount item${restockCount == 1 ? "" : "s"} need restock (Total: $totalProducts)'
                      : 'All $totalProducts product${totalProducts == 1 ? "" : "s"} healthy',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: restockCount > 0
                        ? Colors.amber.shade900
                        : Colors.green.shade900,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGridCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      color: color,
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.black87),
            const SizedBox(height: 16),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
