# StockHome 📦

[![Flutter CI](https://github.com/0xCoderunknown/guwahatione_stock-manage/actions/workflows/ci.yml/badge.svg)](https://github.com/0xCoderunknown/guwahatione_stock-manage/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](CODE_OF_CONDUCT.md)
[![Privacy First](https://img.shields.io/badge/Privacy-100%25%20Offline-success.svg)](#-privacy--security)
[![Flutter Version](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)

A lightweight, offline-first, privacy-focused Flutter application designed for local businesses, shopkeepers, and independent sellers to seamlessly track inventory transfers between home backroom storage and retail shop shelves.

---

## ✨ Features

- 🏢 **Company & Brand Grouping**: Organize products by company or supplier, with custom color-coding presets and avatar badges.
- 🎯 **Target Capacity & Thresholds**: Set target stock levels (1–99) per product. Visual status bars dynamically indicate stock health:
  - 🟢 **Healthy** (> 50% capacity)
  - 🟠 **Moderate** (25% – 50% capacity)
  - 🔴 **Low Stock Alert** (< 25% capacity)
- 🔄 **Quick Stock Movement**:
  - **Add to Home**: Record newly arrived incoming inventory.
  - **Move to Shop**: Transfer stock to your physical shelf or display.
  - **Instant Search**: Rapidly find items across large catalogs.
- ↩️ **Instant 1-Tap Undo**: Made a mistake during a quick stock count? Tap "UNDO" on the prompt to safely roll back the transaction and history log without stale overwrites.
- 📜 **Audit History Log**: Full chronological history of inventory transactions with date timestamps, item details, and delta indicators (+ / -).
- 💾 **Offline-First & Fast**: Built on top of **Hive** local key-value storage. Zero internet required, zero load latency.

---

## 🔒 Privacy & Security

StockHome is built from the ground up to respect user privacy:
- **No Internet Required:** The production application has **zero** internet permissions in Android.
- **Zero Telemetry:** No analytics, trackers, crash collectors, or third-party SDKs.
- **Local Storage:** All company data, product lists, and transaction logs reside strictly on the user's local device.
- Review our [Security Policy](SECURITY.md) for vulnerability reporting guidelines.

---

## 📱 Tech Stack & Architecture

- **Framework:** [Flutter](https://flutter.dev) (Material 3)
- **Application ID:** `com.coderunknown.stockhome`
- **State Management:** [Riverpod](https://riverpod.dev) (`flutter_riverpod`)
- **Local Persistence:** [Hive Flutter](https://pub.dev/packages/hive_flutter) (TypeAdapters for `Company`, `Product`, and `HistoryItem`)
- **Formatting & Utilities:** `intl`, `uuid`
- **Testing:** Unit and persistence tests (`flutter test`)
- **CI/CD:** Automated GitHub Actions workflows for continuous analysis/testing and automated APK release tagging.

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`^3.13.4` or higher)
- Android Studio / VS Code with Flutter extension
- Android device or emulator (Android SDK 21+)

### Installation & Run

1. **Clone the repository**:
   ```bash
   git clone https://github.com/0xCoderunknown/guwahatione_stock-manage.git
   cd guwahatione_stock-manage
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Verify code analysis and test suite**:
   ```bash
   flutter analyze
   flutter test
   ```

4. **Launch the application**:
   ```bash
   flutter run
   ```

5. **Build release APK**:
   ```bash
   flutter build apk --release
   ```

---

## 📂 Project Structure

```text
lib/
├── data/
│   └── hive_setup.dart            # Hive models (Company, Product, HistoryItem) & TypeAdapters
├── provider/
│   └── providers.dart             # Riverpod state providers
├── screens/
│   ├── dashboard_screen.dart      # Main grid navigation dashboard
│   ├── company_list_screen.dart   # Companies listing & management
│   ├── product_list_screen.dart   # Stock level overview with progress indicators
│   ├── add_product_screen.dart    # Dialog to create new products
│   ├── move_stock_screen.dart     # Quick stock transfer & undo
│   └── history_screen.dart        # Chronological transaction audit trail
├── utils/
│   └── stock_input_formatter.dart # Input constraints (digits only, max 99)
└── widgets/
    ├── add_company_dialog.dart    # Dialog with duplicate check & color picker
    ├── edit_company_dialog.dart   # Dialog to edit company details & color
    ├── color_picker_widget.dart   # Palette selection component
    └── edit_product_dialog.dart   # Product threshold & name editor
test/
├── hive_adapter_test.dart         # Hive persistence & serialization roundtrip tests
├── model_test.dart                # Unit tests for domain models
└── stock_input_formatter_test.dart # Unit tests for input constraints
```

---

## 🤝 Contributing

Contributions are warmly welcomed! Please read our [CONTRIBUTING.md](CONTRIBUTING.md) guide and adhere to the [Code of Conduct](CODE_OF_CONDUCT.md) before submitting pull requests or reporting bugs.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'feat: add AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License & Changelog

- Distributed under the **MIT License**. See [LICENSE](LICENSE) for more information.
- See [CHANGELOG.md](CHANGELOG.md) for version release notes.
