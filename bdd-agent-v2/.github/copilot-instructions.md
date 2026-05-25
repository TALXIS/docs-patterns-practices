# Copilot Instructions — BDD Test Project for Power Apps Model-Driven Apps

This is a monorepo for a Power Apps model-driven app. The UI test project lives at `src/Tests.UI/` and uses **Reqnroll + Playwright** with a **two-tier architecture**: standardized bindings for well-known MDA surfaces, and custom bindings for non-standard UI.

## Two-Tier Testing Architecture

### Tier 1 — Standardized Bindings (`src/Tests.UI/Support/Bindings/`)

These bindings implement the **frozen Gherkin vocabulary** for standard model-driven app controls. They use well-known selectors (`[data-field-name]`, `[row-index]`, `[col-id]`, `[data-id="CommandBar"]`).

**Rules:**
- [BAD] **NEVER modify** these files — the step patterns are frozen
- [BAD] **NEVER add** new steps to these files
- [OK] Report issues if standard selectors break due to platform updates

### Tier 2 — Custom Bindings (`src/Tests.UI/StepDefinitions/`)

Custom bindings for UI that doesn't match standard MDA patterns:
- Generative pages (`pagetype=genux`) — ARIA-role-based grids without ag-Grid attributes
- Custom PCF controls
- Canvas app embeds
- Web resource pages

**Rules:**
- [OK] Create new files in `StepDefinitions/` for each feature area
- [OK] Name files `{FeatureArea}CustomSteps.cs`
- [OK] Use `GetByRole` as primary selector strategy for ARIA-only pages
- [BAD] Do not duplicate frozen vocabulary — check `src/Tests.UI/Support/Bindings/` first

### Boundary Detection

Determine which tier applies by checking the page:

1. **URL:** `pagetype=entityrecord` or `entitylist` → Tier 1. `pagetype=genux`, `custom`, `webresource` → Tier 2
2. **DOM markers:** `[data-field-name]`, `[row-index]`/`[col-id]`, `[data-id="CommandBar"]` present → Tier 1
3. **If markers absent** → Tier 2

## Agent Delegation

This project includes three specialized Copilot agents:

| Agent | When to use |
|-------|-------------|
| `@bdd-planner` | Explore the app, design Gherkin scenarios, classify pages as Tier 1/Tier 2 |
| `@bdd-binder` | Implement step definitions — both discovering selectors and writing C# bindings |
| `@bdd-healer` | Diagnose and fix failing tests — timing, selectors, or application state issues |

**Workflow:** Planner → Binder → (run tests) → Healer (if failures)

## Key Rules

1. **Never modify `src/Tests.UI/Support/Bindings/`** — these implement the frozen step vocabulary
2. **Custom steps go in `src/Tests.UI/StepDefinitions/`** — one file per feature area
3. **Check existing step patterns** in `Support/Bindings/` before adding new scenarios
4. **No Selenium** — this project uses Playwright exclusively
5. **Xrm bridge** — use `ModelDrivenAppHelpers` for `window.Xrm` interactions (attribute get/set, form readiness waits)
6. **Feature files** go in `src/Tests.UI/Features/`
