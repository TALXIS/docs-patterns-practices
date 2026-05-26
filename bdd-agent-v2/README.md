# BDD Agent v2 — AI-Assisted Testing for Power Apps

Demo monorepo for the DynamicsMinds 2026 session on AI-assisted BDD testing of Power Apps model-driven apps. Contains a sample Warehouse Management app with three Copilot agents that plan, implement, and heal Reqnroll + Playwright UI tests.

## Quick Start

### 1. Scaffold the repository

Run the scaffold script to populate the monorepo from TALXIS DevKit templates:

```powershell
.demo/scaffold-demo-repo.ps1
```

### 2. Deploy the app

Create an environment and deploy the solution:

```powershell
.demo/create-environment.ps1
.demo/deploy-to-environment.ps1
```

### 3. Configure tests

Set your environment URL and app ID in `src/Tests.UI/appsettings.json` or via environment variables (`TEST_APP_URL`, `TEST_APP_ID`).

### 4. Talk to the agents

Open this folder in GitHub Copilot CLI or VS Code, then use the agents:

| Agent | Purpose |
|---|---|
| `@bdd-planner` | Explore the app via browser, write Gherkin scenarios |
| `@bdd-binder` | Implement step definitions using Playwright selectors |
| `@bdd-healer` | Diagnose and fix failing tests |

## Repository Structure

```
.demo/                    Scaffold and deployment scripts
.github/agents/           Copilot agent definitions (planner, binder, healer)
.github/copilot-instructions.md  Project-level Copilot instructions
.github/skills/           playwright-cli skill for browser automation
.playwright/              Browser session config
src/
  GenPages.Dashboard/     Custom dashboard page (GenUX)
  Packages.Main/          Package deployer with sample data
  Plugins.Warehouse/      Server-side plugins
  Scripts.UI/             Form JavaScript libraries
  Solutions.DataModel/    Dataverse entity definitions
  Solutions.Logic/        SDK message processing steps
  Solutions.Security/     Security roles
  Solutions.UI/           Sitemap, forms, views, ribbons
  Tests.UI/               Reqnroll + Playwright test project
```

## Prerequisites

- .NET 8 SDK
- PowerShell 7+
- TALXIS DevKit Templates (`dotnet new install TALXIS.DevKit.Templates`)
- Power Platform CLI (`pac`)
- Playwright browsers (`pwsh bin/Debug/net8.0/playwright.ps1 install chromium`)
