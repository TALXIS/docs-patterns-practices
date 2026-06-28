#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Deploys all warehouse management solutions to a Dataverse environment.
    Uses txc env sln import — no pac solution import required.
    Solutions are built (Debug = unmanaged) and imported in dependency order.

.EXAMPLE
    ./deploy-to-environment.ps1 -ProfileName "dm26-demo-v2"
    ./deploy-to-environment.ps1 -ProfileName "dm26-demo-v2" -SkipBuild
#>

param(
    [Parameter(Mandatory)]
    [string]$ProfileName,
    [string]$ProjectRoot = (Resolve-Path "$PSScriptRoot/..").Path,
    [switch]$SkipBuild
)

$ErrorActionPreference = "Stop"

#
# ╔════════════════════════════════════════════════════════════════════════════════════════╗
# ║                    Deploy Solutions (Unmanaged)                                       ║
# ╚════════════════════════════════════════════════════════════════════════════════════════╝
#

# ── Select txc profile ────────────────────────────────────────────────────────────────────

Write-Host "`n── Selecting txc profile: $ProfileName ──" -ForegroundColor Cyan
& txc config profile select $ProfileName
if ($LASTEXITCODE -ne 0) { throw "Failed to select txc profile '$ProfileName'" }
Write-Host "  ✓ Profile selected" -ForegroundColor Green

# ── Build (Debug = unmanaged) ─────────────────────────────────────────────────────────────

if (-not $SkipBuild) {
    Write-Host "`n── Building solutions (Debug = unmanaged) ──" -ForegroundColor Cyan

    Push-Location $ProjectRoot
    try {
        $solutions = @(
            "src/Solutions.DataModel/Solutions.DataModel.csproj",
            "src/Solutions.Security/Solutions.Security.csproj",
            "src/Solutions.Logic/Solutions.Logic.csproj",
            "src/Solutions.UI/Solutions.UI.csproj"
        )        foreach ($sln in $solutions) {
            Write-Host "  Building $sln..." -ForegroundColor Gray
            & dotnet build $sln --verbosity quiet
            if ($LASTEXITCODE -ne 0) { throw "Build failed: $sln" }
        }
        Write-Host "  ✓ All solutions built" -ForegroundColor Green
    } finally {
        Pop-Location
    }
}

# ── Import solutions in dependency order ──────────────────────────────────────────────────

Write-Host "`n── Importing solutions (unmanaged) via txc env sln import ──" -ForegroundColor Cyan

$solutions = [ordered]@{
    "DataModel" = "$ProjectRoot/src/Solutions.DataModel"
    "Security"  = "$ProjectRoot/src/Solutions.Security"
    "Logic"     = "$ProjectRoot/src/Solutions.Logic"
    "UI"        = "$ProjectRoot/src/Solutions.UI"
}

foreach ($name in $solutions.Keys) {
    $path = $solutions[$name]
    if (-not (Test-Path $path)) {
        throw "Solution directory not found: $path"
    }

    Write-Host "  Importing $name..." -ForegroundColor Gray
    if ($name -eq "Logic") {
        # Activate plugins and workflows (equivalent to pac --activate-plugins)
        & txc env sln import $path --publish-workflows --wait
    } else {
        & txc env sln import $path --wait
    }
    if ($LASTEXITCODE -ne 0) { throw "Import failed: $name" }
    Write-Host "  ✓ $name imported" -ForegroundColor Green
}

# ── Verify all unmanaged ──────────────────────────────────────────────────────────────────

Write-Host "`n── Verifying solutions ──" -ForegroundColor Cyan
& txc env sln list
if ($LASTEXITCODE -ne 0) {
    Write-Host "  ⚠ Could not retrieve solution list" -ForegroundColor Yellow
} else {
    Write-Host "  ✓ Solution list retrieved above" -ForegroundColor Green
}

# ── Done ──────────────────────────────────────────────────────────────────────────────────

Write-Host "`n╔════════════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  ✓ All 4 solutions deployed as UNMANAGED (profile: $ProfileName)" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════════════════════════════════════╝`n" -ForegroundColor Green
