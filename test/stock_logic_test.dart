import 'package:flutter_test/flutter_test.dart';
import 'package:stock_manage/data/hive_setup.dart';

void main() {
  group('Stock Logic & Invariant Unit Tests', () {
    test('Product stock clamped to minimum 0 on transfer', () {
      final product = Product(
        companyId: 'comp-1',
        name: 'Whole Milk 1L',
        stock: 5,
        targetStock: 20,
      );

      // Simulating move 3 units out
      int moveOut = 3;
      int newStock = (product.stock - moveOut).clamp(0, 999999);
      expect(newStock, 2);

      // Simulating moving more than available
      int excessiveMove = 10;
      int clampedStock = (product.stock - excessiveMove).clamp(0, 999999);
      expect(clampedStock, 0); // Must never be negative
    });

    test('Target stock threshold remains within 1 to 99 bounds', () {
      int sanitizeTarget(int input) => input.clamp(1, 99);

      expect(sanitizeTarget(0), 1);
      expect(sanitizeTarget(-5), 1);
      expect(sanitizeTarget(50), 50);
      expect(sanitizeTarget(100), 99);
      expect(sanitizeTarget(999), 99);
    });

    test('Stock health status calculation', () {
      String getStockStatus(int current, int target) {
        if (target <= 0) return 'Healthy';
        final ratio = current / target;
        if (ratio <= 0.20) return 'Low';
        if (ratio <= 0.50) return 'Moderate';
        return 'Healthy';
      }

      expect(getStockStatus(2, 20), 'Low'); // 10%
      expect(getStockStatus(4, 20), 'Low'); // 20%
      expect(getStockStatus(7, 20), 'Moderate'); // 35%
      expect(getStockStatus(10, 20), 'Moderate'); // 50%
      expect(getStockStatus(15, 20), 'Healthy'); // 75%
      expect(getStockStatus(25, 20), 'Healthy'); // 125%
    });

    test('HistoryItem records positive and negative deltas accurately', () {
      final addHistory = HistoryItem(
        productName: 'Biscuits',
        date: DateTime.now(),
        actionType: 'Added Stock',
        quantityChange: 12,
      );
      expect(addHistory.quantityChange, 12);
      expect(addHistory.actionType, 'Added Stock');

      final moveHistory = HistoryItem(
        productName: 'Biscuits',
        date: DateTime.now(),
        actionType: 'Moved to Shop',
        quantityChange: -6,
      );
      expect(moveHistory.quantityChange, -6);
      expect(moveHistory.actionType, 'Moved to Shop');
    });
  });
}
