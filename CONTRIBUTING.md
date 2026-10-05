# Contributing to StockHome

Thank you for your interest in contributing to StockHome! We welcome contributions, bug reports, and feature suggestions from everyone.

---

## Code of Conduct

This project and everyone participating in it is governed by the [StockHome Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior following the guidelines in the Code of Conduct.

---

## How to Contribute

### 1. Reporting Bugs
- Search existing issues to ensure the bug hasn't already been reported.
- Open an issue describing:
  - What happened
  - Steps to reproduce
  - Expected vs. actual behavior
  - Device/OS and Flutter version (`flutter doctor -v`)

### 2. Suggesting Features
- Open an issue detailing the use case, why this feature would be valuable, and any design or UX ideas.

### 3. Submitting Pull Requests
1. **Fork** the repository and create your branch from `main`:
   ```bash
   git checkout -b feature/your-feature-name
   # or
   git checkout -b fix/issue-description
   ```
2. **Install dependencies**:
   ```bash
   flutter pub get
   ```
3. **Verify code health**:
   Make sure code passes analyzer checks and tests:
   ```bash
   flutter analyze
   flutter test
   ```
4. **Commit your changes**:
   Write clear, concise commit messages following conventional commits (e.g. `feat: add export to CSV`, `fix: prevent duplicate company names`).
5. **Open a Pull Request**:
   - Provide a clear summary of your changes.
   - Link any related issues (e.g., `Closes #12`).

---

## Code Style & Guidelines

- **Linting:** Follow the lint rules defined in `analysis_options.yaml`.
- **State Management:** Riverpod (`flutter_riverpod`) is used for global state.
- **Local Persistence:** Hive (`hive_flutter`) is used for offline-first storage.
- **Null Safety:** All code must adhere to Dart null-safety standards.
