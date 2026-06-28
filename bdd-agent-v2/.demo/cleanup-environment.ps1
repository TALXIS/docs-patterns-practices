#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Deletes a Dataverse sandbox environment and removes the associated txc profile.
    Uses txc env delete — no pac admin commands required.

.EXAMPLE
    ./cleanup-environment.ps1 -ProfileName "dm26-demo-v2"
    ./cleanup-environment.ps1 -ProfileName "dm26-demo-v2" -Force
#>

param(
    [Parameter(Mandatory)]
    [string]$ProfileName,
    [switch]$Force   # Skip confirmation prompt
)

$ErrorActionPreference = "Stop"

#
# ╔════════════════════════════════════════════════════════════════════════════════════════╗
# ║                    Cleanup Environment                                                ║
# ╚════════════════════════════════════════════════════════════════════════════════════════╝
#

# ── Resolve environment ID from profile ──────────────────────────────────────────────────

Write-Host "`n── Looking up environment for profile: $ProfileName ──" -ForegroundColor Cyan

$profileInfo = & txc config profile list --format json 2>&1 | ConvertFrom-Json
$profile = $profileInfo | Where-Object { $_.name -eq $ProfileName }
if (-not $profile) {
    Write-Host "  ✗ Profile '$ProfileName' not found" -ForegroundColor Red
    Write-Host "  Available profiles:"
    & txc config profile list
    exit 1
}
$envUrl = $profile.url
Write-Host "  ✓ Profile found — URL: $envUrl" -ForegroundColor Green

# Find the environment ID from txc env list
$envList = & txc env list --format json 2>&1 | ConvertFrom-Json
$env = $envList | Where-Object { $_.url -like "*$($envUrl.TrimEnd('/').Split('//')[1])*" }
if (-not $env) {
    Write-Host "  ✗ Could not find environment matching URL: $envUrl" -ForegroundColor Red
    Write-Host "  Run 'txc env list' to see available environments" -ForegroundColor Yellow
    exit 1
}
$envId   = $env.id
$envName = $env.name
Write-Host "  ✓ Environment found: $envName ($envId)" -ForegroundColor Green

# ── Confirmation ──────────────────────────────────────────────────────────────────────────

if (-not $Force) {
    Write-Host "`n⚠  This will permanently delete:" -ForegroundColor Yellow
    Write-Host "   Environment: $envName" -ForegroundColor Yellow
    Write-Host "   URL:         $envUrl" -ForegroundColor Yellow
    Write-Host "   ID:          $envId" -ForegroundColor Yellow
    Write-Host "   txc profile: $ProfileName" -ForegroundColor Yellow
    $confirm = Read-Host "`n   Type 'yes' to confirm deletion"
    if ($confirm -ne 'yes') {
        Write-Host "`n  Aborted — nothing deleted." -ForegroundColor Cyan
        exit 0
    }
}

# ── Delete environment ────────────────────────────────────────────────────────────────────

Write-Host "`n── Deleting environment: $envName ──" -ForegroundColor Cyan
& txc env delete $envId --wait --yes
if ($LASTEXITCODE -ne 0) { throw "Environment deletion failed" }
Write-Host "  ✓ Environment deleted" -ForegroundColor Green

# ── Remove txc profile ────────────────────────────────────────────────────────────────────

Write-Host "`n── Removing txc profile: $ProfileName ──" -ForegroundColor Cyan
& txc config profile delete $ProfileName 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "  ✓ txc profile removed" -ForegroundColor Green
} else {
    Write-Host "  ⚠ Could not remove txc profile (may need manual cleanup: txc config profile delete $ProfileName)" -ForegroundColor Yellow
}

# ── Done ──────────────────────────────────────────────────────────────────────────────────

Write-Host "`n╔════════════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  ✓ Environment '$envName' deleted" -ForegroundColor Green
Write-Host "║  ✓ txc profile '$ProfileName' removed" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════════════════════════════════════╝`n" -ForegroundColor Green
