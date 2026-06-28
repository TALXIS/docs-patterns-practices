#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Creates a new Dataverse sandbox environment and deploys all warehouse management solutions.
    Uses txc CLI exclusively — no pac auth switching required.

.EXAMPLE
    ./create-environment.ps1
    ./create-environment.ps1 -EnvName "My Demo" -Domain "mydemo"
    ./create-environment.ps1 -EnvName "My Demo" -Domain "mydemo" -Pin
#>

param(
    [string]$EnvName   = "DM26 Demo v2",
    [string]$Domain    = "dm26demov2",
    [string]$Region    = "europe",
    [string]$Currency  = "EUR",
    [int]$Language      = 1033,
    [switch]$SkipBuild,
    [switch]$Pin        # Pin the txc profile to the current workspace directory
)

$ErrorActionPreference = "Stop"
$ScriptDir = $PSScriptRoot

#
# ╔════════════════════════════════════════════════════════════════════════════════════════╗
# ║                    Create Environment + Deploy                                        ║
# ╚════════════════════════════════════════════════════════════════════════════════════════╝
#

# ── Step 1: Create environment (txc v1.18.0+) ────────────────────────────────────────────

Write-Host "`n── Creating Dataverse environment ──" -ForegroundColor Cyan
Write-Host "  Name:     $EnvName" -ForegroundColor Gray
Write-Host "  Domain:   $Domain" -ForegroundColor Gray
Write-Host "  Region:   $Region" -ForegroundColor Gray

$createResult = & txc env create `
    --type Sandbox `
    --name $EnvName `
    --domain $Domain `
    --region $Region `
    --currency $Currency `
    --language $Language `
    --wait `
    --format json | ConvertFrom-Json

if ($LASTEXITCODE -ne 0) { throw "Environment creation failed" }

$envUrl = "https://$Domain.crm4.dynamics.com"
$envId  = $createResult.environmentId
Write-Host "  ✓ Environment created: $envUrl" -ForegroundColor Green
Write-Host "  ✓ Environment ID:      $envId" -ForegroundColor Gray

# ── Step 2: Create txc profile ───────────────────────────────────────────────────────────

$profileName = ($Domain -replace '[^a-z0-9]', '-').ToLower()
Write-Host "`n── Creating txc profile: $profileName ──" -ForegroundColor Cyan
& txc config profile create --url $envUrl --name $profileName
if ($LASTEXITCODE -ne 0) { throw "txc profile creation failed" }
Write-Host "  ✓ txc profile created: $profileName" -ForegroundColor Green

# Optionally pin the profile to the current workspace directory
if ($Pin) {
    & txc config profile pin $profileName
    Write-Host "  ✓ txc profile pinned to workspace (all txc env commands target $Domain)" -ForegroundColor Green
}

# ── Step 3: Deploy solutions ─────────────────────────────────────────────────────────────

Write-Host "`n── Deploying solutions ──" -ForegroundColor Cyan

$deployArgs = @{ ProfileName = $profileName }
if ($SkipBuild) { $deployArgs["SkipBuild"] = $true }

& "$ScriptDir/deploy-to-environment.ps1" @deployArgs

# ── Done ──────────────────────────────────────────────────────────────────────────────────

Write-Host "`n╔════════════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  ✓ Environment ready:  $envUrl" -ForegroundColor Green
Write-Host "║  ✓ Environment ID:     $envId" -ForegroundColor Green
Write-Host "║  ✓ txc profile:        $profileName" -ForegroundColor Green
Write-Host "║" -ForegroundColor Green
Write-Host "║  To clean up later:" -ForegroundColor Green
Write-Host "║    .demo/cleanup-environment.ps1 -ProfileName $profileName" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════════════════════════════════════╝`n" -ForegroundColor Green

