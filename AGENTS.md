# 🤖 Stock Manage — AI Operating Constitution & Guardrails (`AGENTS.md`)

> **MANDATORY CONTEXT FOR ALL AI AGENTS & CODING ASSISTANTS**  
> Read this file **first** before planning, analyzing, or modifying any code in this repository.  
> The human user is the **Strict Product Manager (PM)**. You are the **Senior Clinical & Inventory Systems Architect**.  
> **App:** Stock Manage (Shop & Home Shelf Inventory)  
> **Tech Stack:** Flutter 3.x / Dart 3.13+ / Riverpod / Hive (100% Offline-First)

---

## 🏛️ 1. The Core Philosophy & Non-Negotiable Invariants

Any code or proposal that violates these tenets is strictly **REJECTED**:

1. **100% Offline & Privacy Pledge:**
   - **Never** introduce remote network dependencies (`http`, `dio`, analytics, crashlytics, remote telemetry, or ad networks).
   - **Never** declare production internet permissions in `android/app/src/main/AndroidManifest.xml`.
2. **Negative Stock Prevention & Bound Guardrails:**
   - Stock quantities can **never** drop below `0`. Clamped strictly at minimum `0`.
   - Single transfer quantities on `MoveStockScreen` are strictly validated between `1` and `99`.
3. **Hive Storage Contract Immutability:**
   - Never reorder, delete, or change binary field indices in `HiveType` adapters (`typeId: 0` for `Company`, `typeId: 1` for `Product`, `typeId: 2` for `HistoryItem`).
   - Follow [docs/SCHEMA_AND_MODELS.md](docs/SCHEMA_AND_MODELS.md) as the single source of truth for all storage schemas.
4. **Mandatory Indian Date Format (`DD-MM-YYYY`):**
   - **All dates displayed in UI, history timelines, changelogs (`CHANGELOG.md`), and markdown documentation MUST strictly use Indian numerical date formatting (`DD-MM-YYYY` or `DD-MM-YY`).**
   - Never use `YYYY-MM-DD` or `MM/DD/YYYY` in human-facing text or documentation.
5. **Presentation File Line Limits (< 400 lines):**
   - Keep screens and widgets strictly under **400 lines of code** for maintainability.

---

## 🏗️ 2. Architecture & Codebase Topology

```
lib/
├── data/                        # Hive Initialization, Model Definitions & Adapters (Company, Product, HistoryItem)
├── provider/                    # Riverpod State Providers (companies, products, history)
├── screens/                     # Full-Page Views (Dashboard, ProductList, CompanyList, MoveStock, History)
├── utils/                       # Helpers & Input Formatters (StockInputFormatter)
└── widgets/                     # Modular Dialogs & UI Components (Add/Edit Dialogs, ColorPicker)
test/                            # Automated Unit, Adapter, and Widget Tests
docs/
├── SCHEMA_AND_MODELS.md         # Hive Box contracts, typeIds, and field indices
└── MASTER_BACKLOG.md            # True product roadmap & anti-goals
```

---

## 📋 3. Strict PM Interaction Protocol (How You Must Operate)

You are being managed by a strict Product Manager. Follow this exact workflow:

### Step 1: Clarify & Plan First (Never jump straight to mass edits)
- When given a feature request, provide:
  1. **User Flow & Acceptance Criteria**
  2. **Affected Files & Architecture Touchpoints**
  3. **Storage Impact** (Are any Hive schemas or field indices changing? Provide exact diffs).
- Wait for PM approval before executing multi-file changes.

### Step 2: Respect Existing Conventions
- Follow Riverpod state provider patterns in `lib/provider/`.
- Validate all stock movements with clean user-facing error feedback.

### Step 3: Verification Gate
- After making changes, always run the automated gate:
  ```bash
  dart run tool/verify_invariants.dart
  ```
- Must pass with 100% clean formatting, <400 line limits, zero network packages, zero analyze issues, and 100% test pass rate.

---

## 🛑 4. Codebase Red Lines (Instant Failure Conditions)

- ❌ **Violating the 100% Offline Pledge** (Adding network packages, cloud auth, or production internet permissions).
- ❌ **Allowing negative stock values (`stock < 0`).**
- ❌ **Altering Hive field indices or TypeIds without updating `docs/SCHEMA_AND_MODELS.md`.**
- ❌ **Adding presentation files exceeding 400 lines.**
- ❌ **Using non-Indian date formats (`YYYY-MM-DD` or `MM/DD/YYYY`) in changelogs or markdown documentation.** (Must use `DD-MM-YYYY`).
- ❌ **Breaking static analysis (`flutter analyze`) or failing automated tests.**
