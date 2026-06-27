#
# ╔════════════════════════════════════════════════════════════════════════════════════════╗
# ║              11: Tests.UI — Playwright / Reqnroll UI Test Project                      ║
# ╚════════════════════════════════════════════════════════════════════════════════════════╝
#
# Creates a Playwright-based BDD test project using the pp-test-ui template.
# Includes frozen step bindings for model-driven app surfaces (forms, views,
# command bar, navigation) and a sample feature file.
#
# Expects: $PublisherPrefix from parent scope.
#
# ──────────────────────────────────────────────────────────────────────────────────────────

Write-Host "`n── Tests.UI ──" -ForegroundColor Cyan

# ──────────────────────────────────────────────────────────────────────────────────────────
#                              Scaffold Test Project
# ──────────────────────────────────────────────────────────────────────────────────────────

txc workspace component create pp-test-ui `
    --output "src/Tests.UI"

# Add to solution
cd "src/Tests.UI"
dotnet sln ../../ add Tests.UI.csproj
cd ../..

Write-Host "  ✓ Tests.UI project created" -ForegroundColor Green

# ──────────────────────────────────────────────────────────────────────────────────────────
#                              Sample Feature File
# ──────────────────────────────────────────────────────────────────────────────────────────

txc workspace component create pp-test-ui-feature `
    --param "name=WarehouseItemNavigation" `
    --output "src/Tests.UI"

# Remove Calculator sample that ships with both templates
Remove-Item "src/Tests.UI/Features/Calculator.feature" -ErrorAction SilentlyContinue
Remove-Item "src/Tests.UI/Features/Calculator.feature.cs" -ErrorAction SilentlyContinue

Write-Host "  ✓ Sample feature: WarehouseItemNavigation.feature" -ForegroundColor Green

# Write a meaningful scenario into the feature file
$featureContent = @"
Feature: WarehouseItemNavigation

Scenario: User can open a warehouse item from the main view
    Given I am logged in as 'admin@yourorg.onmicrosoft.com'
    And I have opened the 'Warehouse Management' app
    When I navigate to 'Warehouse Items' in the 'Warehouse' group
    Then I should see the 'Active Warehouse Items' view
"@

Set-Content -Path "src/Tests.UI/Features/WarehouseItemNavigation.feature" -Value $featureContent -Encoding UTF8
Write-Host "  ✓ Feature scenario written" -ForegroundColor Green

# ──────────────────────────────────────────────────────────────────────────────────────────
#                              Configure appsettings.json
# ──────────────────────────────────────────────────────────────────────────────────────────

$appSettings = @"
{
  "EnvironmentUrl": "https://yourorg.crm4.dynamics.com",
  "AppName": "Warehouse Management",
  "Headless": false,
  "SlowMo": 0,
  "Timeout": 30000,
  "StorageStatePath": "",
  "ScreenshotOnFailure": true,
  "TracingEnabled": false,
  "OutputPath": "TestResults"
}
"@

Set-Content -Path "src/Tests.UI/appsettings.json" -Value $appSettings -Encoding UTF8
Write-Host "  ✓ appsettings.json configured" -ForegroundColor Green

# ──────────────────────────────────────────────────────────────────────────────────────────
#                              Build + Install Playwright
# ──────────────────────────────────────────────────────────────────────────────────────────

Write-Host "  → Building Tests.UI..." -ForegroundColor White
dotnet build src/Tests.UI/Tests.UI.csproj --nologo --verbosity quiet
if ($LASTEXITCODE -eq 0) {
    Write-Host "  ✓ Build succeeded" -ForegroundColor Green
} else {
    Write-Host "  ⚠ Build had issues (exit code: $LASTEXITCODE)" -ForegroundColor Yellow
}

Write-Host "  → Installing Playwright browsers..." -ForegroundColor White
pwsh src/Tests.UI/bin/Debug/net8.0/playwright.ps1 install
if ($LASTEXITCODE -eq 0) {
    Write-Host "  ✓ Playwright browsers installed" -ForegroundColor Green
} else {
    Write-Host "  ⚠ Playwright install had issues (exit code: $LASTEXITCODE)" -ForegroundColor Yellow
}
