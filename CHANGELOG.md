# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-10-05

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
