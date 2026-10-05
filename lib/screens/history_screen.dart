import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../data/hive_setup.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM, hh:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History Log'), centerTitle: true),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<HistoryItem>('history').listenable(),
        builder: (context, Box<HistoryItem> box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No history yet.', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          // Sort by date descending (Newest first)
          final historyItems = box.values.toList()
            ..sort((a, b) => b.date.compareTo(a.date));

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: historyItems.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = historyItems[index];
              final isPositive = item.quantityChange > 0;
              final color = isPositive ? Colors.green : Colors.red;
              final prefix = isPositive ? '+' : '';

              return ListTile(
                leading: CircleAvatar(
                  // FIX: Use .withValues(alpha: ...) instead of .withOpacity(...)
                  backgroundColor: color.withValues(alpha: 0.1),
                  child: Icon(
                    isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                    color: color,
                    size: 20,
                  ),
                ),
                title: Text(
                  '${_formatDate(item.date)} • ${item.productName}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(item.actionType),
                trailing: Text(
                  '$prefix${item.quantityChange}',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
