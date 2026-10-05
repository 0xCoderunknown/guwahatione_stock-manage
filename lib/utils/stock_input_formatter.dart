import 'package:flutter/services.dart';

class StockInputFormatter {
  static List<TextInputFormatter> get formatters => [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(2), // Max 99
  ];
}
