#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Deploys all warehouse management solutions to a Dataverse environment.
    Solutions are imported as UNMANAGED from Debug build output.

.EXAMPLE
    ./deploy-to-environment.ps1 -EnvironmentUrl "https://dm26demov2.crm4.dynamics.com"
    ./deploy-to-environment.ps1 -ProfileName "dm26-demo-v2"
#>

param(
    [string]$EnvironmentUrl,
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

# ── Resolve PAC auth ──────────────────────────────────────────────────────────────────────

if ($ProfileName) {
    Write-Host "`n── Selecting txc profile: $ProfileName ──" -ForegroundColor Cyan
    & txc config profile select $ProfileName
    if ($LASTEXITCODE -ne 0) { throw "Failed to select txc profile '$ProfileName'" }
} elseif ($EnvironmentUrl) {
    Write-Host "`n── Selecting PAC auth for: $EnvironmentUrl ──" -ForegroundColor Cyan
    $authList = & pac auth list 2>&1 | Out-String
    $existingAuth = $authList -match [regex]::Escape($EnvironmentUrl)
    if (-not $existingAuth) {
        Write-Host "  Creating PAC auth..." -ForegroundColor Yellow
        & pac auth create --environment $EnvironmentUrl
        if ($LASTEXITCODE -ne 0) { throw "Failed to create PAC auth for '$EnvironmentUrl'" }
    }
    & pac auth select --environment $EnvironmentUrl 2>$null
} else {
    throw "Provide either -EnvironmentUrl or -ProfileName"
}

# ── Build (Debug = unmanaged) ─────────────────────────────────────────────────────────────

if (-not $SkipBuild) {
    Write-Host "`n── Building solutions (Debug = unmanaged) ──" -ForegroundColor Cyan

    Push-Location $ProjectRoot
    try {
        # Build the 4 solution projects individually (avoids GenPages P12 build bug)
        $solutions = @(
            "src/Solutions.DataModel/Solutions.DataModel.csproj",
            "src/Solutions.Security/Solutions.Security.csproj",
            "src/Solutions.Logic/Solutions.Logic.csproj"
        )
        foreach ($sln in $solutions) {
            Write-Host "  Building $sln..." -ForegroundColor Gray
            & dotnet build $sln --verbosity quiet
            if ($LASTEXITCODE -ne 0) { throw "Build failed: $sln" }
        }

        # Solutions.UI depends on GenPages.Dashboard which has a build bug (P12).
        # Temporarily remove the GenPages reference, build, then restore.
        $uiCsproj = "src/Solutions.UI/Solutions.UI.csproj"
        $uiContent = Get-Content $uiCsproj -Raw
        $patchedContent = $uiContent -replace '<ProjectReference Include="\.\.\\GenPages\.Dashboard\\GenPages\.Dashboard\.csproj"\s*/>', ''
        Set-Content $uiCsproj -Value $patchedContent -NoNewline
        try {
            Write-Host "  Building $uiCsproj (without GenPages — P12 workaround)..." -ForegroundColor Gray
            & dotnet build $uiCsproj --verbosity quiet
            if ($LASTEXITCODE -ne 0) { throw "Build failed: $uiCsproj" }
        } finally {
            Set-Content $uiCsproj -Value $uiContent -NoNewline
        }

        Write-Host "  ✓ All solutions built" -ForegroundColor Green
    } finally {
        Pop-Location
    }
}

# ── Import solutions in dependency order ──────────────────────────────────────────────────

$solutionZips = [ordered]@{
    "DataModel" = "$ProjectRoot/src/Solutions.DataModel/bin/Debug/net462/Solutions.DataModel.zip"
    "Security"  = "$ProjectRoot/src/Solutions.Security/bin/Debug/net462/Solutions.Security.zip"
    "Logic"     = "$ProjectRoot/src/Solutions.Logic/bin/Debug/net462/Solutions.Logic.zip"
    "UI"        = "$ProjectRoot/src/Solutions.UI/bin/Debug/net462/Solutions.UI.zip"
}

Write-Host "`n── Importing solutions (unmanaged) ──" -ForegroundColor Cyan

foreach ($name in $solutionZips.Keys) {
    $zip = $solutionZips[$name]
    if (-not (Test-Path $zip)) {
        throw "Solution ZIP not found: $zip — run build first"
    }

    Write-Host "  Importing $name..." -ForegroundColor Gray
    $importArgs = @("solution", "import", "--path", $zip)
    if ($name -eq "Logic") {
        $importArgs += "--activate-plugins"
    }
    & pac @importArgs
    if ($LASTEXITCODE -ne 0) { throw "Import failed: $name" }
    Write-Host "  ✓ $name imported" -ForegroundColor Green
}

# ── Verify all unmanaged ──────────────────────────────────────────────────────────────────

Write-Host "`n── Verifying solutions ──" -ForegroundColor Cyan
$list = & pac solution list 2>&1 | Out-String
$managed = $list | Select-String "Solutions\.\w+.*True"
if ($managed) {
    Write-Host "  ✗ Some solutions are managed!" -ForegroundColor Red
    Write-Host $list
    exit 1
}
Write-Host "  ✓ All solutions imported as UNMANAGED" -ForegroundColor Green

# ── Done ──────────────────────────────────────────────────────────────────────────────────

$envDisplay = if ($EnvironmentUrl) { $EnvironmentUrl } elseif ($ProfileName) { $ProfileName } else { "current" }
Write-Host "`n╔════════════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  ✓ All 4 solutions deployed as UNMANAGED to $envDisplay" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════════════════════════════════════╝`n" -ForegroundColor Green
