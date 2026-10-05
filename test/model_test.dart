import 'package:flutter_test/flutter_test.dart';
import 'package:stock_manage/data/hive_setup.dart';

void main() {
  group('Model Tests', () {
    test('Product creation with defaults', () {
      final product = Product(
        companyId: 'company-123',
        name: 'Test Product',
      );

      expect(product.id, isNotEmpty);
      expect(product.companyId, 'company-123');
      expect(product.name, 'Test Product');
      expect(product.stock, 0);
      expect(product.targetStock, 10);
    });

    test('Company creation with default auto-generated id', () {
      final company = Company(
        name: 'Acme Corp',
        colorValue: 0xFF123456,
      );

      expect(company.id, isNotEmpty);
      expect(company.name, 'Acme Corp');
      expect(company.colorValue, 0xFF123456);
    });

    test('HistoryItem generates id and retains fields', () {
      final now = DateTime.now();
      final history = HistoryItem(
        productName: 'Shampoo',
        date: now,
        actionType: 'Moved to Shop',
        quantityChange: -5,
      );

      expect(history.id, isNotEmpty);
      expect(history.productName, 'Shampoo');
      expect(history.date, now);
      expect(history.actionType, 'Moved to Shop');
      expect(history.quantityChange, -5);
    });
  });
}
