# Power Platform Demo Repository

This repository contains examples, patterns, and demo scripts related to Power Platform development. It is intended to support conference sessions, workshops and training activities.

Each folder in this repository represents a separate topic or scenario that demonstrates a specific area of Power Platform development using a code-first approach.

## Getting started

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/TALXIS/docs-patterns-practices?quickstart=1)

Click the badge to open a pre-configured development environment with all Power Platform tools ready to go — no local installation needed.

> ⚠️ **If you plan to commit changes or run GitHub Actions pipelines** (required for most labs), you need your own fork. GitHub will create one automatically the first time you push — just follow the prompt in the Codespaces terminal. Alternatively, fork this repository before you start and open the Codespace from your fork.

## Demos

### [bdd-agent-v2](./bdd-agent-v2/README.md)
AI-assisted BDD testing of Power Apps model-driven apps using Copilot agents, Reqnroll, and Playwright. Full monorepo with a sample Warehouse Management app and three agents (planner, binder, healer) that write, implement, and fix UI tests. Presented at DynamicsMinds 2026.

### [bdd-agent](./bdd-agent/README.md)
First-generation BDD test automation template using Reqnroll, Playwright, and .NET. Contains agent definitions for VS Code that automate test planning, step binding, and test healing.

### [dev-loops](./dev-loops/README.md)
Scripted setup of a Power Platform project repository using Visual Studio Code and PowerShell, focusing on the inner and outer development loop.

### [sample-repo](./sample-repo/)
Sample Power Platform project repository (Inventory Management) scaffolded with TALXIS DevKit Templates. Reference structure for code-first Dataverse development.

## Related Projects

This repository leverages the following tools developed and maintained by the TALXIS team:

- [tools-devkit-build](https://github.com/TALXIS/tools-devkit-build)  
  Helps Power Platform developers customize the MSBuild process (`dotnet build`) for Dataverse solution components. It includes build tasks that automate steps.

- [tools-devkit-templates](https://github.com/TALXIS/tools-devkit-templates)  
  Supports scaffolding of Power Platform components using a code-first approach. This NuGet package enables consistent and structured project setup for developers.

- [tools-cli](https://github.com/TALXIS/tools-cli)  
  CLI tool for Power Platform developers. Provides commands for environment management, solution operations, and development workflow automation.

## Contribution

This repository is maintained by the TALXIS team. Contributions or suggestions are welcome through issues or pull requests.

---

Visit our [YouTube channel](https://www.youtube.com/playlist?list=PLFCzz03beGm5cthgn7LZh4bt-d9g1G6ip) for demo recordings.
