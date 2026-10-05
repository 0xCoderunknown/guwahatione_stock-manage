import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// SCREEN IMPORTS
import 'add_product_screen.dart';
import 'company_list_screen.dart';
import 'move_stock_screen.dart';
import 'history_screen.dart';

// WIDGET IMPORTS
import '../widgets/add_company_dialog.dart'; // We just made this!

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
              onTap: () => showAddCompanyDialog(
                context,
              ), // Calling the external function
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
