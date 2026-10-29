import 'package:flutter_riverpod/flutter_riverpod.dart';

// Stores the ID of the last selected company in AddProductDialog
class LastSelectedCompanyNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void setCompanyId(String? companyId) {
    state = companyId;
  }
}

final lastSelectedCompanyProvider =
    NotifierProvider<LastSelectedCompanyNotifier, String?>(
      LastSelectedCompanyNotifier.new,
    );
