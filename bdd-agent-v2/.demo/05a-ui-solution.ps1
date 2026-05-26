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

dotnet new pp-solution `
    --output "src/Solutions.UI" `
    --PublisherName $PublisherName `
    --PublisherPrefix $PublisherPrefix `
    --allow-scripts yes

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

dotnet new pp-entity `
    --output "src/Solutions.UI" `
    --Behavior "Existing" `
    --PublisherPrefix $PublisherPrefix `
    --LogicalName "warehouselocation" `
    --DisplayName "Warehouse Location" `
    --allow-scripts yes

Write-Host "  ✓ Entity ref: Warehouse Location" -ForegroundColor Green

dotnet new pp-entity `
    --output "src/Solutions.UI" `
    --Behavior "Existing" `
    --PublisherPrefix $PublisherPrefix `
    --LogicalName "warehouseitem" `
    --DisplayName "Warehouse Item" `
    --allow-scripts yes

Write-Host "  ✓ Entity ref: Warehouse Item" -ForegroundColor Green

dotnet new pp-entity `
    --output "src/Solutions.UI" `
    --Behavior "Existing" `
    --PublisherPrefix $PublisherPrefix `
    --LogicalName "warehousetransaction" `
    --DisplayName "Warehouse Transaction" `
    --allow-scripts yes

Write-Host "  ✓ Entity ref: Warehouse Transaction" -ForegroundColor Green

# ──────────────────────────────────────────────────────────────────────────────────────────
#                                  Model-Driven App
# ──────────────────────────────────────────────────────────────────────────────────────────

Write-Host "`n── Model-Driven App ──" -ForegroundColor Cyan

dotnet new pp-app-model `
    --output "src/Solutions.UI" `
    --PublisherPrefix $PublisherPrefix `
    --LogicalName "warehouseapp" `
    --allow-scripts yes

Write-Host "  ✓ App: warehouseapp" -ForegroundColor Green

# ──────────────────────────────────────────────────────────────────────────────────────────
#                                  App Components
# ──────────────────────────────────────────────────────────────────────────────────────────

Write-Host "`n── App Components ──" -ForegroundColor Cyan

dotnet new pp-app-model-component `
    --output "src/Solutions.UI" `
    --EntityLogicalName "${PublisherPrefix}_warehouselocation" `
    --AppName "${PublisherPrefix}_warehouseapp" `
    --allow-scripts yes

Write-Host "  ✓ App component: warehouselocation" -ForegroundColor Green

dotnet new pp-app-model-component `
    --output "src/Solutions.UI" `
    --EntityLogicalName "${PublisherPrefix}_warehouseitem" `
    --AppName "${PublisherPrefix}_warehouseapp" `
    --allow-scripts yes

Write-Host "  ✓ App component: warehouseitem" -ForegroundColor Green

dotnet new pp-app-model-component `
    --output "src/Solutions.UI" `
    --EntityLogicalName "${PublisherPrefix}_warehousetransaction" `
    --AppName "${PublisherPrefix}_warehouseapp" `
    --allow-scripts yes

Write-Host "  ✓ App component: warehousetransaction" -ForegroundColor Green
