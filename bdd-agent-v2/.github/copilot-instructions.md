# Copilot Instructions — TXC-Aware BDD Demo Workspace

This repository is a **demo-first Power Apps / Dataverse workspace** built around:

- **TXC / TALXIS tooling**
- **Reqnroll + Playwright** UI tests in `src/Tests.UI/`
- The live demo script in `.demo/STAGE-CHEAT-SHEET.md`

When working in this repo, treat **`.demo/STAGE-CHEAT-SHEET.md` as the ground truth for the demo narrative, priorities, and expected outcomes**.

## Primary Operating Order

1. **Follow the stage cheat sheet first** for what the demo must show.
2. **Use TXC guidance early** for workspace, testing, environment, and deployment questions.
3. **Use the repository files as the final source of truth** for implementation details, selectors, step patterns, and commands.

## TXC Awareness

This repo is TXC-oriented even though the workspace may not always look like a canonical `.cdsproj` Power Platform repo. Be TXC-aware in both planning and execution:

- Use TXC MCP guidance before inventing workflows.
- Prefer TXC for:
  - **BDD/test guidance** (`guide_testing` and related testing guidance)
  - **Workspace understanding** (`workspace_explain`, `workspace_project_explain`)
  - **Profile/config inspection** (`config_profile_list`, `config_profile_validate`, `config_setting_list`)
  - **Environment and solution operations** when the task involves deployed Dataverse state
- If a TXC workspace-guidance call times out on the first attempt, **retry once** before assuming it is broken.
- When TXC guidance is generic, verify against the repo structure and existing code before acting.

## Demo Goals From `.demo/STAGE-CHEAT-SHEET.md`

Optimize for the demo beats, especially the core retroactive testing flow:

1. **Beat 2 — Write Gherkin**
   - Create business-readable scenarios for:
     - navigating to Warehouse Items
     - verifying the grid
     - opening a record such as **Gadget B**
     - checking form fields / tabs / related data
     - creating transactions
     - validating the insufficient stock error
     - using the **Check Stock Levels** ribbon button

2. **Beat 3 — Set up the test project**
   - The expected scaffold pattern is `dotnet new pp-test-ui`
   - Feature files belong in `src/Tests.UI/Features/`

3. **Beat 4 — Discover bindings**
   - This is the key TXC moment
   - **Call TXC testing guidance first**
   - Map proposed Gherkin to the existing standardized bindings
   - The preferred outcome for standard MDA pages is:
     - **reuse existing bindings**
     - **generate zero custom code**

4. **Beat 5 — Custom steps**
   - Only add custom bindings for interactions that truly fall outside the frozen MDA vocabulary
   - The plugin error dialog is a valid example of a likely custom step

5. **Beat 6 / 9 / 10 — Run, report, heal**
   - Run the tests
   - Use screenshots, traces, and report output for diagnosis
   - When a test fails, determine whether the problem is:
     - app behavior
     - outdated expectation
     - selector / timing issue

6. **Beat 8 — Implement the transfer feature**
   - Decompose work in the order the cheat sheet expects:
     - schema/optionset
     - fields/lookups
     - plugin logic
     - form/app updates
     - deployment

## `src/Tests.UI/` Is the Test Project

The active UI automation project is `src/Tests.UI/`.

Important files and folders:

- `src/Tests.UI/Features/` — Gherkin scenarios
- `src/Tests.UI/Support/Bindings/` — **frozen standardized bindings**
- `src/Tests.UI/StepDefinitions/` — custom bindings for non-standard UI
- `src/Tests.UI/Support/ModelDrivenAppHelpers.cs` — Xrm bridge and MDA helpers
- `src/Tests.UI/reqnroll.json` — report formatter settings
- `src/Tests.UI/appsettings.json` — live test configuration

## Frozen Standard Bindings

`src/Tests.UI/Support/Bindings/` is the standardized binding layer for standard model-driven app UI.

### Rules

- **Never modify** files in `Support/Bindings/` unless the user explicitly asks to evolve the shared frozen vocabulary
- **Never add new project-specific steps** there
- **Always search these bindings first** before creating Gherkin or custom code

Representative existing step patterns already present in this repo include:

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

When writing or revising Gherkin, prefer these existing phrases over inventing new wording.

## Two-Tier Binding Architecture

### Tier 1 — Standard MDA Surfaces

Use the frozen bindings for pages that expose standard model-driven app structure.

Signals:

1. URL contains `pagetype=entityrecord` or `pagetype=entitylist`
2. DOM contains standard MDA markers such as:
   - `[data-field-name]`
   - `[row-index]` and `[col-id]`
   - `[data-id="CommandBar"]`

### Tier 2 — Non-Standard UI

Create custom bindings only when the page is not standard MDA, for example:

- `pagetype=genux`
- custom PCF controls
- canvas app embeds
- web resources
- dialogs or surfaces not covered by the frozen bindings

If the standard MDA markers are absent, treat it as Tier 2.

## Custom Binding Rules

When custom bindings are required:

- Create them in `src/Tests.UI/StepDefinitions/`
- Use file names in the form `{FeatureArea}CustomSteps.cs`
- Keep **one feature area per file**
- Use `GetByRole` as the primary strategy for ARIA-driven surfaces
- Reuse `ModelDrivenAppHelpers` for `window.Xrm` interactions

### Mandatory pre-flight before custom code

Before creating any new custom step:

1. **Consult TXC testing guidance** (`guide_testing`)
2. **Search `src/Tests.UI/Support/Bindings/`**
3. Only create custom code if neither TXC nor the frozen bindings already cover it

## Playwright and Test Execution

This repo uses Playwright exclusively. Do not introduce Selenium.

Preferred commands:

```bash
dotnet build src/Tests.UI/Tests.UI.csproj
dotnet test src/Tests.UI/Tests.UI.csproj
```

If Playwright browsers are not installed yet:

```bash
pwsh src/Tests.UI/bin/Debug/net8.0/playwright.ps1 install chromium
```

Artifacts are configured through `reqnroll.json` and `TestConfiguration`:

- HTML report: `TestResults/bdd-report.html`
- Cucumber messages: `TestResults/cucumber-messages.ndjson`
- failure screenshots when enabled
- Playwright traces when enabled

## TXC-Linked Test Configuration

`src/Tests.UI/Support/TestConfiguration.cs` supports these TXC-style environment variables:

- `TXC_ENVIRONMENT_URL`
- `TXC_APP_NAME`
- `TXC_HEADLESS`
- `TXC_SLOWMO`
- `TXC_TIMEOUT`
- `TXC_STORAGE_STATE_PATH`
- `TXC_SCREENSHOT_ON_FAILURE`
- `TXC_TRACING_ENABLED`
- `TXC_OUTPUT_PATH`

Prefer these names when discussing or automating configuration.

## How to Behave for Common Requests

### If asked to write Gherkin

- Use the cheat sheet beats and the warehouse demo behavior as the target behavior
- Keep the language business-readable
- Reuse existing frozen step vocabulary wherever possible
- If a scenario needs a custom binding, make that explicit

### If asked to discover available bindings

- Start with **TXC testing guidance**
- Then inspect `src/Tests.UI/Support/Bindings/`
- Report which scenarios are covered without custom code
- Only propose custom bindings for the uncovered remainder

### If asked to implement missing bindings

- Put custom code in `src/Tests.UI/StepDefinitions/`
- Do not duplicate existing frozen vocabulary
- Prefer stable selectors and ARIA roles over brittle CSS

### If asked to heal failing tests

- Reproduce the failure
- Inspect screenshots, traces, and page structure
- Decide whether the issue is:
  - wrong app behavior
  - stale Gherkin expectation
  - broken selector / timing
- Fix the correct layer instead of patching symptoms

## Demo-Specific Guardrails

- The **core demo promise** is: **pre-built bindings for standard MDA, AI-generated code only for the custom edge cases**
- For standard Warehouse app pages, the preferred answer is usually **mapping**, not code generation
- For the plugin validation dialog or other special UI, custom code is acceptable
- Preserve the cheat sheet's narrative:
  - Gherkin first
  - reuse existing bindings
  - only minimal custom code
  - deterministic Playwright execution
  - heal failures with evidence

## Repository Reality Check

- `.demo/*.ps1` scripts are strong evidence for intended scaffolding and demo flow
- `README.md`, `src/Tests.UI/README.md`, and existing feature/binding files are the source of truth for current implementation
- If TXC advice and repo files disagree, prefer:
  1. the actual repo code
  2. the stage cheat sheet's intended demo outcome
  3. TXC guidance as planning support
