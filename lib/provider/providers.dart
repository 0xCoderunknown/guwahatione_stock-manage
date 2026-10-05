import 'package:flutter_riverpod/flutter_riverpod.dart';

// Stores the ID of the last selected company in AddProductDialog
final lastSelectedCompanyProvider = StateProvider<String?>((ref) => null);
