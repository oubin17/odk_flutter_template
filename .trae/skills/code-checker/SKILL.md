---
name: "code-checker"
description: "Checks Flutter/Dart code for lint errors and project convention violations. Invoke after writing or modifying code to ensure code quality."
---

# Code Checker

Automatically checks written Flutter/Dart code for issues.

## When to Invoke

**IMPORTANT: Invoke this skill AFTER completing any of these actions:**
- Writing new Dart/Flutter code
- Modifying existing code
- Generating code from templates
- Creating new files

## Checks to Perform

### 1. Run Flutter Analyze

```bash
flutter analyze
```

### 2. Run Code Generation (if needed)

```bash
flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs
```

### 3. Check Diagnostics

Use `GetDiagnostics` tool to check for errors in modified files.

### 4. Common Issues to Fix

| Issue | Solution |
|-------|----------|
| Undefined getter for L10nUtils | Run `flutter gen-l10n` |
| Missing model .g.dart files | Run `dart run build_runner build --delete-conflicting-outputs` |
| Import errors | Check import paths |
| Duplicate keys in .arb files | Check for existing keys before adding |

### 5. Project-Specific Checks

Per `AGENTS.md`:
- [ ] No raw Flutter widgets (Text, ElevatedButton, etc.) - use AppText, AppButton
- [ ] No hardcoded sizes - use .w, .h, .sp suffixes
- [ ] No hardcoded strings - use L10nUtils
- [ ] No context.watch() - use Selector or context.read()
- [ ] Files properly organized (Feature-First structure)

## Output Format

Report findings in this format:

```
## Code Check Results

### Errors Found
- [file:line] Error description

### Warnings Found
- [file:line] Warning description

### Fixed Issues
- [file:line] Fixed description
```

## Important Notes

- **ALWAYS check for duplicate keys** in .arb files before adding new i18n strings
- **ALWAYS run `flutter gen-l10n`** after modifying .arb files
- **ALWAYS check GetDiagnostics** for the specific files you modified
