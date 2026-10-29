# 🎯 Stock Manage — Master Roadmap & Product Backlog

> **Single Source of Truth** for unbuilt inventory systems, QOL enhancements, pending workflows, and non-negotiable architectural boundaries.  
> Shipped releases and version history are recorded chronologically in [`CHANGELOG.md`](../CHANGELOG.md).  
> Canonical storage schemas and model contracts are defined in [`docs/SCHEMA_AND_MODELS.md`](SCHEMA_AND_MODELS.md).  
> AI maintainer guidelines and invariants are defined in [`AGENTS.md`](../AGENTS.md).  
> **Date Standard:** All human-facing dates strictly follow Indian numerical formatting (`DD-MM-YYYY`).

---

## ⚡ Tier 1: Immediate Sprint Priorities (High-ROI Stock Enhancements)

Targeted, self-contained enhancements that eliminate shopkeeper friction without architectural overhead.

---

### FEAT-01: CSV Product Catalog Export & Import
- **Domain:** Data Portability / Backup
- **Status:** Planned
- **Specification:**
  1. Add an "Export Inventory to CSV" button in settings/overflow menu.
  2. Generates standard CSV with headers: `Company,Product,Stock,TargetStock`.
  3. Support 1-tap restore/import from CSV to bulk-populate companies and items on a new device.

---

### FEAT-02: Low Stock Warning Badges & Filter Chip
- **Domain:** Dashboard & Stock Status
- **Status:** Completed in v0.1.2
- **Specification:**
  1. Add a quick-filter chip on `ProductListScreen`: `[⚠️ Needs Restock]` that filters products where `stock <= (targetStock * 0.2)`.
  2. Display prominent low-stock count chip on `DashboardScreen`.

---

### FEAT-03: Quick Camera Barcode / QR Lookup
- **Domain:** Scanners & Speed
- **Status:** Planned
- **Specification:**
  1. Add optional barcode scanning button on `MoveStockScreen` to auto-select SKU by barcode without typing.
  2. Must use offline on-device scanning (Google ML Kit / pure offline scanner), never remote API lookups.

---

## 📦 Tier 2: Storage & Warehouse Enhancements

Substantive multi-step modules expanding shelf and item attributes.

---

### FEAT-04: Shelf / Location Bin Tagging
- **Domain:** Warehouse & Shelf Positioning
- **Status:** Planned
- **Specification:**
  1. Expand `Product` model with optional `shelfLocation` (e.g. `"Aisle 2, Bin C"`).
  2. Display location chip in `ProductListScreen` and `MoveStockScreen` for rapid retrieval.

---

### FEAT-05: Batch & Expiry Date Tracker
- **Domain:** Perishable Inventory
- **Status:** Planned
- **Specification:**
  1. Optional `expiryDate` on products with visual color-coded warnings (Yellow: expiring in 30 days, Red: expired).
  2. Format display strictly as `DD-MM-YYYY`.

---

## 🚫 Product Anti-Goals (What Stock Manage Is NOT)

1. **NOT a Cloud-Mandated SaaS / Web App:** Stock Manage is 100% offline-first local inventory management using Hive. No mandatory email login, Firebase auth wall, or external server dependencies.
2. **NOT a Retail POS / Tax Invoicing Software:** Will **not** build GST invoice printing, customer billing ledgers, or payment gateway integrations.
3. **ZERO Ad Networks or Telemetry:** No Google AdMob, Facebook SDK, Firebase Analytics, or tracking SDKs.
