import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stock_manage/data/hive_setup.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_test_');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(CompanyAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(ProductAdapter());
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(HistoryItemAdapter());
  });

  tearDown(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group('Hive Adapter Persistence Tests', () {
    test('Company roundtrip persistence in Hive box', () async {
      final box = await Hive.openBox<Company>('test_companies');
      final company = Company(id: 'c-1', name: 'Alpha Traders', colorValue: 0xFF4285F4);
      await box.put(company.id, company);

      final retrieved = box.get('c-1');
      expect(retrieved, isNotNull);
      expect(retrieved!.id, 'c-1');
      expect(retrieved.name, 'Alpha Traders');
      expect(retrieved.colorValue, 0xFF4285F4);

      // Mutate and save
      retrieved.name = 'Alpha Updated';
      await retrieved.save();

      final updated = box.get('c-1');
      expect(updated!.name, 'Alpha Updated');
    });

    test('Product roundtrip persistence in Hive box', () async {
      final box = await Hive.openBox<Product>('test_products');
      final product = Product(
        id: 'p-1',
        companyId: 'c-1',
        name: 'Organic Honey',
        stock: 12,
        targetStock: 30,
      );
      await box.put(product.id, product);

      final retrieved = box.get('p-1');
      expect(retrieved, isNotNull);
      expect(retrieved!.id, 'p-1');
      expect(retrieved.companyId, 'c-1');
      expect(retrieved.name, 'Organic Honey');
      expect(retrieved.stock, 12);
      expect(retrieved.targetStock, 30);
    });

    test('HistoryItem roundtrip persistence in Hive box', () async {
      final box = await Hive.openBox<HistoryItem>('test_history');
      final now = DateTime(2026, 10, 5, 12, 0, 0);
      final history = HistoryItem(
        id: 'h-1',
        productName: 'Organic Honey',
        date: now,
        actionType: 'Added to Home',
        quantityChange: 10,
      );
      await box.put(history.id, history);

      final retrieved = box.get('h-1');
      expect(retrieved, isNotNull);
      expect(retrieved!.id, 'h-1');
      expect(retrieved.productName, 'Organic Honey');
      expect(retrieved.date, now);
      expect(retrieved.actionType, 'Added to Home');
      expect(retrieved.quantityChange, 10);
    });
  });
}
