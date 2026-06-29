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
# Note: replace the login step value with your actual test user account
$testUser = if ($env:TXC_TEST_USER) { $env:TXC_TEST_USER } else { "your-user@yourtenant.onmicrosoft.com" }
$featureContent = @"
Feature: WarehouseItemNavigation

Scenario: User can open a warehouse item from the main view
    Given I am logged in as '$testUser'
    And I open the '${PublisherPrefix}_warehouseapp' app
    When I click on 'Warehouse Items' in the sitemap
    Then I should see the 'Active Warehouse Items' view
"@

Set-Content -Path "src/Tests.UI/Features/WarehouseItemNavigation.feature" -Value $featureContent -Encoding UTF8
Write-Host "  ✓ Feature scenario written" -ForegroundColor Green

# ──────────────────────────────────────────────────────────────────────────────────────────
#                              Configure appsettings.json
# ──────────────────────────────────────────────────────────────────────────────────────────
#
# All settings can be overridden via environment variables:
#   TXC_ENVIRONMENT_URL, TXC_APP_NAME, TXC_HEADLESS, TXC_SLOWMO,
#   TXC_TIMEOUT, TXC_STORAGE_STATE_PATH, TXC_SCREENSHOT_ON_FAILURE, TXC_TRACING_ENABLED
#
# To capture auth state for headless runs (Codespaces / CI):
#   playwright-cli open --browser=msedge --headed <env-url>    # local machine with display
#   playwright-cli state-save src/Tests.UI/auth-state.json
#   playwright-cli close
#
# NOTE: StorageStatePath must be an absolute path — relative paths resolve
#       from the test binary output directory (bin/Debug/<tfm>/) and are silently ignored.
#       Set TXC_STORAGE_STATE_PATH env var at test run time for a portable override.

$envUrl = if ($env:TXC_ENVIRONMENT_URL) { $env:TXC_ENVIRONMENT_URL } else { "https://yourenv.crm4.dynamics.com" }
# Resolve to absolute path cross-platform (works on Windows, Linux, macOS)
$authStatePath = [System.IO.Path]::GetFullPath("src/Tests.UI/auth-state.json").Replace('\', '/')

$appSettings = @"
{
  "TestSettings": {
    "EnvironmentUrl": "$envUrl",
    "AppName": "Warehouse Management",
    "Headless": true,
    "SlowMo": 0,
    "Timeout": 60000,
    "StorageStatePath": "$authStatePath",
    "ScreenshotOnFailure": true,
    "TracingEnabled": false,
    "OutputPath": "TestResults"
  }
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

# Detect actual output TFM from build output directory
$debugDir = "src/Tests.UI/bin/Debug"
$tfm = if (Test-Path $debugDir) {
    Get-ChildItem -Path $debugDir -Directory | Select-Object -First 1 -ExpandProperty Name
} else { "net8.0" }

Write-Host "  → Installing Playwright browsers (TFM: $tfm)..." -ForegroundColor White
$playwrightScript = "src/Tests.UI/bin/Debug/$tfm/playwright.ps1"
if (Test-Path $playwrightScript) {
    pwsh $playwrightScript install chromium
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✓ Playwright browsers installed" -ForegroundColor Green
    } else {
        Write-Host "  ⚠ Playwright install had issues (exit code: $LASTEXITCODE)" -ForegroundColor Yellow
    }
} else {
    Write-Host "  ⚠ playwright.ps1 not found at $playwrightScript — run dotnet build first" -ForegroundColor Yellow
}

