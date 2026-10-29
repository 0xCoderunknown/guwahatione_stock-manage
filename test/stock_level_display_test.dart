import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stock_manage/data/hive_setup.dart';
import 'package:stock_manage/widgets/stock_level_display.dart';

void main() {
  group('StockLevelDisplay Widget Tests', () {
    testWidgets('Renders stock count, ratio, and indicator correctly', (
      tester,
    ) async {
      final product = Product(
        companyId: 'comp-1',
        name: 'Mustard Oil 1L',
        stock: 3,
        targetStock: 15,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: StockLevelDisplay(product: product)),
        ),
      );

      expect(find.text('Current Stock'), findsOneWidget);
      expect(find.text('3 / 15'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });
  });
}
