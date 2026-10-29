# Changelog

All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), adhering to [Semantic Versioning](https://semver.org/spec/v2.0.0.html). Dates strictly follow the Indian numerical date standard (`DD-MM-YYYY`).

---

## [0.1.1] — 29-10-2026 — AI Governance Constitution, Schema Contracts & Invariant Gate

### Added
- **AI Operating Constitution (`AGENTS.md`):** Configured with ClinicOS-grade operating constitution, Strict PM Interaction Protocol (Clarify & Plan First -> Respect Conventions -> Verification Gate), and explicit Codebase Red Lines.
- **Hive Storage Contracts (`docs/SCHEMA_AND_MODELS.md`):** Single source of truth documenting Hive box schemas (`companies`, `products`, `history`), typeIds, and field indices.
- **Master Roadmap Backlog (`docs/MASTER_BACKLOG.md`):** Dedicated unbuilt product roadmap documenting CSV export/import, low-stock status badges, barcode lookup, and explicit Anti-Goals.
- **Automated Invariant Gate (`tool/verify_invariants.dart`):** Single command verifying repository formatting, <400 line limits, 100% offline pledge (no network SDKs or release internet permissions), `flutter analyze` (0 warnings), and test suite pass rate.
- **Test Suite Expansion (9 → 14 Tests):**
  - Added `test/stock_logic_test.dart` verifying non-negative stock clamping, target thresholds (1–99), health status ratios, and history deltas.
  - Added `test/dashboard_screen_test.dart` widget test verifying all 5 grid navigation cards and appbar rendering.

---

## [0.1.0] — 05-10-2026 — Initial Release

### Added
- Multi-company / supplier inventory tracking.
- Product catalog management with custom target capacity thresholds (1–99).
- Visual stock status indicators (Low, Moderate, Healthy).
- Quick stock movement between Home storage and Shop shelves with 1-tap Undo.
- Search and filtering across products.
- History transaction log tracking additions, transfers, and reversals (up to 100 entries).
- Full offline-first local persistence powered by Hive key-value storage.
- Custom company badge color picker and automatic avatar palette generation.
- FOSS community standards: Code of Conduct, Security policy, issue/PR templates, CI/CD automated workflow.

### Security & Privacy
- Zero internet permissions in production Android builds (`uses-permission INTERNET` restricted to debug mode only).
- Zero remote telemetry, analytics, or trackers.
