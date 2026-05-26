#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Scaffolds a warehouse management Dataverse demo repository for DynamicsMinds conference.

.DESCRIPTION
    Creates a complete Dataverse project using TALXIS.DevKit.Templates.Dataverse dotnet new templates.
    Produces: DataModel solution (3 tables), Security solution (2 roles), UI solution (model-driven app),
    Logic solution (2 plugins), Script Library (TypeScript web resources), ribbon buttons,
    a generative page dashboard (React 17 + Fluent UI V9),
    and a Package Deployer package that deploys them all.

    Uses plain sequential dotnet new commands — same style as the dev-loops VS Code snippets.

.EXAMPLE
    ./scaffold-demo-repo.ps1
    ./scaffold-demo-repo.ps1 -OutputPath "./MyDemo" -SkipBuild
    ./scaffold-demo-repo.ps1 -PublisherPrefix "contoso" -PublisherName "Contoso"
#>

param(
    [string]$OutputPath = "$(Get-Location)/WarehouseDemo",
    [string]$PublisherName = "DMPP",
    [string]$PublisherPrefix = "dmpp",
    [string]$SolutionName = "WarehouseManagement",
    [switch]$SkipGitInit,
    [switch]$SkipBuild
)

$ErrorActionPreference = "Stop"
$ScriptDir = $PSScriptRoot

# Step 1: Prerequisites check
. "$ScriptDir/01-prerequisites.ps1"

# Step 2: Create output dir, git init, .gitignore, .sln, src/, NuGet.config
. "$ScriptDir/02-init-repo.ps1"

# Steps 3-10 run inside the output directory
Push-Location $OutputPath
try {
    # Step 3a: Package Deployer (Packages.Main)
    . "$ScriptDir/03a-package-deployer.ps1"

    # Step 3b: Solutions.DataModel + entities
    . "$ScriptDir/03b-data-model.ps1"

    # Step 3c: All entity columns
    . "$ScriptDir/03c-columns.ps1"

    # Step 4: Solutions.Security, security roles, privileges
    . "$ScriptDir/04-security.ps1"

    # Step 5a: Solutions.UI + entity refs + app + app components
    . "$ScriptDir/05a-ui-solution.ps1"

    # Step 5b: Sitemap navigation
    . "$ScriptDir/05b-sitemap.ps1"

    # Step 5c: Forms + tabs + columns + sections + rows + cells + controls
    . "$ScriptDir/05c-forms.ps1"

    # Step 5d: Views + subgrids
    . "$ScriptDir/05d-views-subgrids.ps1"

    # Step 7: Plugin project + plugin classes
    . "$ScriptDir/07-plugins.ps1"

    # Step 8: Logic solution + plugin assembly + SDK steps
    . "$ScriptDir/08-logic-solution.ps1"

    # Step 9: Script library + form event handlers
    . "$ScriptDir/09-form-scripts.ps1"

    # Step 10: Ribbon buttons
    . "$ScriptDir/10-ribbon.ps1"

    # Step 11: Tests.UI project (Playwright / Reqnroll BDD test project)
    . "$ScriptDir/11-tests-ui.ps1"

    # Step 12: Generative page — Warehouse Dashboard (React 17 + Fluent UI V9)
    . "$ScriptDir/12-genpage-dashboard.ps1"

    # Step 6: Final commit, optional build, deployment instructions (always last)
    . "$ScriptDir/06-finalize.ps1"
}
finally {
    Pop-Location
}
