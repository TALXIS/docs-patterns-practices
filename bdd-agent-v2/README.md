# BDD Agent v2 — AI-Assisted Testing for Power Apps

This is a monorepo for testing a Power Apps model-driven app using AI agents, Reqnroll, and Playwright.

## Getting Started

### 1. Scaffold the demo project

```powershell
.demo/scaffold-demo-repo.ps1
```

This populates the repository with a sample Power Apps project and a UI test project.

### 2. Configure your environment

Update `src/Tests.UI/appsettings.json` with your Power Apps environment URL and app name.

### 3. Use the agents

Open this folder in VS Code or Copilot CLI, then talk to the agents:

- **@bdd-planner** — "Explore the app and write test scenarios"
- **@bdd-binder** — "Implement the missing step definitions"
- **@bdd-healer** — "Fix the failing test"

## Prerequisites

- .NET 8 SDK
- TALXIS DevKit Templates (`dotnet new install TALXIS.DevKit.Templates`)
- Playwright browsers (`pwsh bin/Debug/net8.0/playwright.ps1 install chromium`)
