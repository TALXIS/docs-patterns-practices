#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Demonstrates scaffolding environment variables in the DataModel solution.
    New in tools-devkit-templates v1.23.0: pp-environment-variable and pp-environment-variable-value.

.DESCRIPTION
    Environment variables in Dataverse store deployment-specific configuration (API keys,
    feature flags, capacity limits). They are declared in the DataModel solution and
    referenced by Power Automate flows, web resources, and plugins.

.EXAMPLE
    ./03d-env-vars.ps1
    ./03d-env-vars.ps1 -ProjectRoot "/path/to/your/project"
#>

param(
    [string]$ProjectRoot    = (Resolve-Path "$PSScriptRoot/..").Path,
    [string]$Publisher      = "dmpp",
    [string]$SolutionFolder = "src/Solutions.DataModel"
)

$ErrorActionPreference = "Stop"
$DataModelPath = Join-Path $ProjectRoot $SolutionFolder

Write-Host "`n── Scaffolding environment variables ──" -ForegroundColor Cyan
Write-Host "  Solution: $DataModelPath" -ForegroundColor Gray

# ── 1. MaxWarehouseCapacity — integer env var ─────────────────────────────────────────────

Write-Host "`n  [1/3] Scaffolding MaxWarehouseCapacity (integer)..." -ForegroundColor Gray
Push-Location $DataModelPath
try {
    & dotnet new pp-environment-variable `
        --publisher $Publisher `
        --name "MaxWarehouseCapacity" `
        --display-name "Max Warehouse Capacity" `
        --description "Maximum total item count allowed in a warehouse location" `
        --type Integer
    if ($LASTEXITCODE -ne 0) { throw "Failed to scaffold MaxWarehouseCapacity" }
} finally { Pop-Location }
Write-Host "  ✓ MaxWarehouseCapacity scaffolded" -ForegroundColor Green

# ── 2. Default value for MaxWarehouseCapacity ─────────────────────────────────────────────

Write-Host "`n  [2/3] Scaffolding default value (1000)..." -ForegroundColor Gray
Push-Location $DataModelPath
try {
    & dotnet new pp-environment-variable-value `
        --publisher $Publisher `
        --variable-name "MaxWarehouseCapacity" `
        --value "1000"
    if ($LASTEXITCODE -ne 0) { throw "Failed to scaffold env var value" }
} finally { Pop-Location }
Write-Host "  ✓ Default value (1000) scaffolded" -ForegroundColor Green

# ── 3. WarehouseManagerEmail — string env var ─────────────────────────────────────────────

Write-Host "`n  [3/3] Scaffolding WarehouseManagerEmail (string)..." -ForegroundColor Gray
Push-Location $DataModelPath
try {
    & dotnet new pp-environment-variable `
        --publisher $Publisher `
        --name "WarehouseManagerEmail" `
        --display-name "Warehouse Manager Email" `
        --description "Email address for warehouse manager notifications" `
        --type String
    if ($LASTEXITCODE -ne 0) { throw "Failed to scaffold WarehouseManagerEmail" }
} finally { Pop-Location }
Write-Host "  ✓ WarehouseManagerEmail scaffolded" -ForegroundColor Green

# ── Verify ────────────────────────────────────────────────────────────────────────────────

Write-Host "`n── Verifying generated files ──" -ForegroundColor Cyan
$envVarPath = Join-Path $DataModelPath "EnvironmentVariableDefinitions"
if (Test-Path $envVarPath) {
    Get-ChildItem $envVarPath -Recurse | ForEach-Object {
        Write-Host "  $($_.FullName.Replace($ProjectRoot, ''))" -ForegroundColor Gray
    }
    Write-Host "  ✓ Environment variable files present" -ForegroundColor Green
} else {
    Write-Host "  ⚠ EnvironmentVariableDefinitions folder not found — check template output structure" -ForegroundColor Yellow
}

# ── Done ──────────────────────────────────────────────────────────────────────────────────

Write-Host "`n╔════════════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  ✓ Environment variables scaffolded in $SolutionFolder" -ForegroundColor Green
Write-Host "║" -ForegroundColor Green
Write-Host "║  Next: rebuild and re-import Solutions.DataModel to deploy changes" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════════════════════════════════════╝`n" -ForegroundColor Green
