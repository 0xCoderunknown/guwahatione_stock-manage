import 'package:flutter_test/flutter_test.dart';
import 'package:stock_manage/utils/stock_input_formatter.dart';

void main() {
  group('StockInputFormatter Tests', () {
    test('formatters list has digit filter and length limit', () {
      final formatters = StockInputFormatter.formatters;
      expect(formatters.length, 2);
    });

    test('accepts valid 2-digit numbers', () {
      final formatters = StockInputFormatter.formatters;

      final oldValue = const TextEditingValue(text: '');
      final newValue = const TextEditingValue(text: '42');

      TextEditingValue current = newValue;
      for (final formatter in formatters) {
        current = formatter.formatEditUpdate(oldValue, current);
      }

      expect(current.text, '42');
    });

    test('strips non-digits and enforces max 2 digits', () {
      final formatters = StockInputFormatter.formatters;

      final oldValue = const TextEditingValue(text: '');
      final newValue = const TextEditingValue(text: '999abc');

      TextEditingValue current = newValue;
      for (final formatter in formatters) {
        current = formatter.formatEditUpdate(oldValue, current);
      }

      // Should filter out 'abc' and truncate to 2 digits ('99')
      expect(current.text, '99');
    });
  });
}
