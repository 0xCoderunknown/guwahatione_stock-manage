import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stock_manage/screens/dashboard_screen.dart';

void main() {
  Widget createTestWidget() {
    return const ProviderScope(child: MaterialApp(home: DashboardScreen()));
  }

  group('DashboardScreen Widget Tests', () {
    testWidgets('Renders StockHome app bar and all 5 dashboard grid tiles', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // App bar title
      expect(find.text('StockHome'), findsOneWidget);

      // Grid navigation tiles
      expect(find.text('Add Company'), findsOneWidget);
      expect(find.text('Add Product'), findsOneWidget);
      expect(find.text('Move Stock'), findsOneWidget);
      expect(find.text('View Stock'), findsOneWidget);
      expect(find.text('History'), findsOneWidget);

      // Corresponding action icons
      expect(find.byIcon(Icons.business), findsOneWidget);
      expect(find.byIcon(Icons.inventory_2), findsOneWidget);
      expect(find.byIcon(Icons.swap_horiz), findsOneWidget);
      expect(find.byIcon(Icons.inventory), findsOneWidget);
      expect(find.byIcon(Icons.history), findsOneWidget);
    });
  });
}
