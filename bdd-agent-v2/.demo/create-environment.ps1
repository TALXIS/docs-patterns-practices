#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Creates a new Dataverse sandbox environment and deploys all warehouse management solutions.

.EXAMPLE
    ./create-environment.ps1
    ./create-environment.ps1 -EnvName "DM26 Demo v3" -Domain "dm26demov3"
#>

param(
    [string]$EnvName   = "DM26 Demo v2",
    [string]$Domain    = "dm26demov2",
    [string]$Region    = "europe",
    [string]$Currency  = "EUR",
    [int]$Language      = 1033,
    [switch]$SkipBuild
)

$ErrorActionPreference = "Stop"
$ScriptDir = $PSScriptRoot

#
# ╔════════════════════════════════════════════════════════════════════════════════════════╗
# ║                    Create Environment + Deploy                                        ║
# ╚════════════════════════════════════════════════════════════════════════════════════════╝
#

# ── Step 1: Create environment ────────────────────────────────────────────────────────────

Write-Host "`n── Creating Dataverse environment ──" -ForegroundColor Cyan
Write-Host "  Name:     $EnvName" -ForegroundColor Gray
Write-Host "  Domain:   $Domain" -ForegroundColor Gray
Write-Host "  Region:   $Region" -ForegroundColor Gray

& pac admin create `
    --type Sandbox `
    --name $EnvName `
    --domain $Domain `
    --region $Region `
    --currency $Currency `
    --language $Language

if ($LASTEXITCODE -ne 0) { throw "Environment creation failed" }

$envUrl = "https://$Domain.crm4.dynamics.com"
Write-Host "  ✓ Environment created: $envUrl" -ForegroundColor Green

# ── Step 2: Create PAC auth ──────────────────────────────────────────────────────────────

Write-Host "`n── Setting up authentication ──" -ForegroundColor Cyan
& pac auth create --environment $envUrl
if ($LASTEXITCODE -ne 0) { throw "PAC auth creation failed" }
Write-Host "  ✓ PAC auth configured" -ForegroundColor Green

# ── Step 3: Create txc profile ───────────────────────────────────────────────────────────

$profileName = ($Domain -replace '[^a-z0-9]', '-').ToLower()
Write-Host "`n── Creating txc profile: $profileName ──" -ForegroundColor Cyan
& txc config profile create --url $envUrl --name $profileName
if ($LASTEXITCODE -ne 0) {
    Write-Host "  ⚠ txc profile creation failed (non-blocking)" -ForegroundColor Yellow
}
& txc config profile select $profileName 2>$null

# ── Step 4: Deploy solutions ─────────────────────────────────────────────────────────────

Write-Host "`n── Deploying solutions ──" -ForegroundColor Cyan

$deployArgs = @{
    EnvironmentUrl = $envUrl
}
if ($SkipBuild) { $deployArgs["SkipBuild"] = $true }

& "$ScriptDir/deploy-to-environment.ps1" @deployArgs

# ── Done ──────────────────────────────────────────────────────────────────────────────────

Write-Host "`n╔════════════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  ✓ Environment ready: $envUrl" -ForegroundColor Green
Write-Host "║  ✓ txc profile: $profileName" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════════════════════════════════════╝`n" -ForegroundColor Green
