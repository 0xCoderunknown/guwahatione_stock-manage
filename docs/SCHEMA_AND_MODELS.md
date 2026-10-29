# 📊 Stock Manage — Hive Storage Schema & Model Contracts

> **Single Source of Truth for Hive TypeAdapters, Box Names, and Model Contracts.**  
> **RULE:** No AI agent may alter Hive field indices or typeIds without updating this document and getting PM approval.  
> **Date Standard:** All human-facing dates strictly follow Indian numerical formatting (`DD-MM-YYYY`).

---

## 🗄️ Hive Boxes Overview

| Box Name | TypeId | Model Class | Description |
|---|---|---|---|
| `companies` | `0` | `Company` | Master company/brand catalog with custom UI color badges. |
| `products` | `1` | `Product` | Tracked stock items, current home/shelf quantity, and target threshold. |
| `history` | `2` | `HistoryItem` | Append-only transaction ledger logging stock additions, transfers, and reversals (capped at 100 entries). |

---

## 🏢 1. `Company` Model (`typeId: 0`)

- **Hive Box:** `companies`
- **Key Pattern:** String UUID (`id`).

### Fields
| Index | Field | Type | Description |
|---|---|---|---|
| `0` | `id` | `String` | Primary identifier (UUID v4). |
| `1` | `name` | `String` | Company or brand name. |
| `2` | *(skipped)* | — | Legacy `visitDay` field permanently removed. Skipped in binary serializer to maintain backwards compatibility. |
| `3` | `colorValue` | `int?` | ARGB color integer for company avatar badges and filters. |

---

## 📦 2. `Product` Model (`typeId: 1`)

- **Hive Box:** `products`
- **Key Pattern:** String UUID (`id`).
- **Invariance:** `stock` must never drop below `0`. `targetStock` bounded between `1` and `99`.

### Fields
| Index | Field | Type | Description |
|---|---|---|---|
| `0` | `id` | `String` | Primary identifier (UUID v4). |
| `1` | `companyId` | `String` | Foreign key referencing parent `companies` box entry. |
| `2` | `name` | `String` | Product title / SKU name. |
| `3` | `stock` | `int` | Current active quantity on shelves (minimum `0`). |
| `4` | `targetStock` | `int` | Desired shelf threshold (default: `10`, range `1–99`). |

---

## 📜 3. `HistoryItem` Model (`typeId: 2`)

- **Hive Box:** `history`
- **Key Pattern:** String UUID (`id`).
- **Invariance:** **Append-only ledger.** Up to 100 entries kept in rotating FIFO queue.

### Fields
| Index | Field | Type | Description |
|---|---|---|---|
| `0` | `id` | `String` | Transaction identifier (UUID v4). |
| `1` | `productName` | `String` | Cached snapshot of product name at transaction time. |
| `2` | `date` | `DateTime` | Transaction timestamp. |
| `3` | `actionType` | `String` | `'Moved to Shop'`, `'Moved to Home'`, `'Added Stock'`, or `'Undone'`. |
| `4` | `quantityChange` | `int` | Signed quantity moved or modified. |
