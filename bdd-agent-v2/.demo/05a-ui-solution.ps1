#
# ╔════════════════════════════════════════════════════════════════════════════════════════╗
# ║           05a: UI Solution — Project, Entity Refs, App, App Components                 ║
# ╚════════════════════════════════════════════════════════════════════════════════════════╝
#
# Creates Solutions.UI with existing entity references, a model-driven app,
# and entity app components.
# Expects: $PublisherName, $PublisherPrefix from parent scope.
#
# ──────────────────────────────────────────────────────────────────────────────────────────
#                                    Solutions.UI
# ──────────────────────────────────────────────────────────────────────────────────────────

Write-Host "`n── Solutions.UI ──" -ForegroundColor Cyan

txc workspace component create pp-solution `
    --output "src/Solutions.UI" `
    --param "PublisherName=$PublisherName" `
    --param "PublisherPrefix=$PublisherPrefix"

Write-Host "  ✓ Solutions.UI" -ForegroundColor Green

# Add Solutions.UI to the Package Deployer project as a .NET ProjectReference
cd src/Packages.Main
dotnet add "./Packages.Main.csproj" reference "../Solutions.UI/Solutions.UI.csproj"
cd ../..

Write-Host "  ✓ ProjectReference: UI → Packages.Main" -ForegroundColor Green

# ──────────────────────────────────────────────────────────────────────────────────────────
#                              Existing Entity References
# ──────────────────────────────────────────────────────────────────────────────────────────

Write-Host "`n── Entity References (UI) ──" -ForegroundColor Cyan

txc workspace component create pp-entity `
    --output "src/Solutions.UI" `
    --param "Behavior=Existing" `
    --param "PublisherPrefix=$PublisherPrefix" `
    --param "LogicalName=warehouselocation" `
    --param "DisplayName=Warehouse Location"

Write-Host "  ✓ Entity ref: Warehouse Location" -ForegroundColor Green

txc workspace component create pp-entity `
    --output "src/Solutions.UI" `
    --param "Behavior=Existing" `
    --param "PublisherPrefix=$PublisherPrefix" `
    --param "LogicalName=warehouseitem" `
    --param "DisplayName=Warehouse Item"

Write-Host "  ✓ Entity ref: Warehouse Item" -ForegroundColor Green

txc workspace component create pp-entity `
    --output "src/Solutions.UI" `
    --param "Behavior=Existing" `
    --param "PublisherPrefix=$PublisherPrefix" `
    --param "LogicalName=warehousetransaction" `
    --param "DisplayName=Warehouse Transaction"

Write-Host "  ✓ Entity ref: Warehouse Transaction" -ForegroundColor Green

# ──────────────────────────────────────────────────────────────────────────────────────────
#                                  Model-Driven App
# ──────────────────────────────────────────────────────────────────────────────────────────

Write-Host "`n── Model-Driven App ──" -ForegroundColor Cyan

txc workspace component create pp-app-model `
    --output "src/Solutions.UI" `
    --param "PublisherPrefix=$PublisherPrefix" `
    --param "LogicalName=warehouseapp"

Write-Host "  ✓ App: warehouseapp" -ForegroundColor Green

# ──────────────────────────────────────────────────────────────────────────────────────────
#                                  App Components
# ──────────────────────────────────────────────────────────────────────────────────────────

Write-Host "`n── App Components ──" -ForegroundColor Cyan

txc workspace component create pp-app-model-component `
    --output "src/Solutions.UI" `
    --param "EntityLogicalName=${PublisherPrefix}_warehouselocation" `
    --param "AppName=${PublisherPrefix}_warehouseapp"

Write-Host "  ✓ App component: warehouselocation" -ForegroundColor Green

txc workspace component create pp-app-model-component `
    --output "src/Solutions.UI" `
    --param "EntityLogicalName=${PublisherPrefix}_warehouseitem" `
    --param "AppName=${PublisherPrefix}_warehouseapp"

Write-Host "  ✓ App component: warehouseitem" -ForegroundColor Green

txc workspace component create pp-app-model-component `
    --output "src/Solutions.UI" `
    --param "EntityLogicalName=${PublisherPrefix}_warehousetransaction" `
    --param "AppName=${PublisherPrefix}_warehouseapp"

Write-Host "  ✓ App component: warehousetransaction" -ForegroundColor Green
