# Copilot Instructions — Power Apps BDD Testing Workspace

This is a Power Apps / Dataverse workspace with Reqnroll + Playwright UI tests. It uses TALXIS DevKit tooling for scaffolding and a two-tier binding architecture that separates standard model-driven app interactions from custom UI.

## Project Layout

- `src/Tests.UI/Features/` — Gherkin feature files
- `src/Tests.UI/Support/Bindings/` — standardized bindings for model-driven app UI (frozen, do not modify)
- `src/Tests.UI/StepDefinitions/` — custom bindings for non-standard UI
- `src/Tests.UI/Support/ModelDrivenAppHelpers.cs` — Xrm bridge and MDA helpers
- `src/Tests.UI/appsettings.json` — test configuration
- `src/Tests.UI/reqnroll.json` — report formatter settings

## Two-Tier Binding Architecture

### Tier 1 — Standard MDA Surfaces

Use the frozen bindings in `Support/Bindings/` for pages that expose standard model-driven app structure.

Signals that a page is standard MDA:

1. URL contains `pagetype=entityrecord` or `pagetype=entitylist`
2. DOM contains markers such as `[data-field-name]`, `[row-index]`, `[col-id]`, `[data-id="CommandBar"]`

### Tier 2 — Non-Standard UI

Create custom bindings only when the page does not use standard MDA controls:

- Custom pages (`pagetype=custom` or `pagetype=genux`)
- PCF controls with non-standard DOM
- Canvas app embeds, web resources, or custom dialogs

If standard MDA markers are absent, treat the surface as Tier 2.

## Frozen Standard Bindings

`Support/Bindings/` contains the shared, standardized step definitions for standard MDA interactions.

Rules:

- **Never modify** files in `Support/Bindings/` unless explicitly asked to evolve the shared vocabulary
- **Never add project-specific steps** there
- **Always search these bindings first** before writing Gherkin or custom code

Available step patterns include:

- `Given I am logged in as {string}`
- `Given I open the {string} app`
- `When I click on {string} in the sitemap`
- `When I navigate to {string} > {string}`
- `When I click {string} on the command bar`
- `When I save the record`
- `When I open the record at row {int}`
- `When I enter {string} into the {string} {word} attribute`
- `When I select {string} in the {string} optionset attribute`
- `When I search for {string} in the {string} lookup attribute`
- `Then the {string} attribute should contain {string}`
- `Then the grid should contain a record with {string} equal to {string}`

When writing Gherkin, prefer these existing phrases over inventing new wording.

## Custom Binding Rules

When a step is not covered by the frozen bindings:

- Create it in `src/Tests.UI/StepDefinitions/`
- Name the file `{FeatureArea}CustomSteps.cs`
- Keep one feature area per file
- Use `GetByRole` as the primary selector strategy for ARIA-driven surfaces
- Reuse `ModelDrivenAppHelpers` for `window.Xrm` interactions

Before creating any custom step:

1. Search `src/Tests.UI/Support/Bindings/` for an existing match
2. Only create custom code if the frozen bindings do not cover the interaction

## Writing Gherkin

- Keep scenarios business-readable — describe what, not how
- Reuse frozen step vocabulary wherever possible
- If a scenario needs a custom binding, note it explicitly
- One feature file per functional area

## Test Execution

This project uses Playwright. Do not introduce Selenium.

```bash
dotnet build src/Tests.UI/Tests.UI.csproj
dotnet test src/Tests.UI/Tests.UI.csproj
```

Install browsers if needed:

```bash
pwsh src/Tests.UI/bin/Debug/net8.0/playwright.ps1 install chromium
```

## Test Configuration

`TestConfiguration.cs` reads from `appsettings.json` and these environment variables:

- `TXC_ENVIRONMENT_URL` — Power Apps environment URL
- `TXC_APP_NAME` — model-driven app unique name
- `TXC_HEADLESS` — run headless (`true`/`false`)
- `TXC_SLOWMO` — slow motion delay in ms
- `TXC_TIMEOUT` — default timeout in ms
- `TXC_STORAGE_STATE_PATH` — path to saved auth state
- `TXC_SCREENSHOT_ON_FAILURE` — capture screenshot on failure
- `TXC_TRACING_ENABLED` — enable Playwright traces
- `TXC_OUTPUT_PATH` — output directory for artifacts

## Test Artifacts

- HTML report: `TestResults/bdd-report.html`
- Cucumber messages: `TestResults/cucumber-messages.ndjson`
- Failure screenshots (when enabled)
- Playwright traces (when enabled)

## Healing Failing Tests

When a test fails:

1. Reproduce the failure
2. Inspect screenshots, traces, and page structure
3. Determine the root cause:
   - App behavior changed
   - Gherkin expectation is stale
   - Selector or timing issue
4. Fix the correct layer — do not patch symptoms
