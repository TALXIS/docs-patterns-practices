#
# ╔════════════════════════════════════════════════════════════════════════════════════════╗
# ║                     13: Sample Data — CMT Data Package Import                          ║
# ╚════════════════════════════════════════════════════════════════════════════════════════╝
#
# Imports sample warehouse data (3 locations, 5 items, 4 transactions) into the
# Dataverse environment using a pre-built CMT data package.
#
# The data package lives in src/Packages.Main/Data/ and contains:
#   - data_schema.xml  — entity/field definitions + plugin-disable flags
#   - data.xml         — record payloads with stable GUIDs
#   - [Content_Types].xml — OPC content types
#
# Plugins are disabled during import (disableplugins="true" in schema) so the
# SubtractQuantityPlugin won't fire and mangle the intended quantities.
#
# Expects: working directory = $OutputPath (set by scaffold-demo-repo.ps1)
#          txc CLI authenticated with a profile targeting the demo environment
#
# ──────────────────────────────────────────────────────────────────────────────────────────

Write-Host "`n── Sample Data ──" -ForegroundColor Cyan

$DataDir = Join-Path $PWD "src/Packages.Main/Data"

if (-not (Test-Path (Join-Path $DataDir "data_schema.xml"))) {
    Write-Host "  ⚠ No CMT data package found at $DataDir — skipping sample data import" -ForegroundColor Yellow
    return
}

Write-Host "  → Importing CMT data package from $DataDir ..." -ForegroundColor White
txc data pkg import $DataDir --allow-production
if ($LASTEXITCODE -eq 0) {
    Write-Host "  ✓ Sample data imported successfully" -ForegroundColor Green
} else {
    Write-Host "  ⚠ Sample data import had issues (exit code: $LASTEXITCODE)" -ForegroundColor Yellow
}
