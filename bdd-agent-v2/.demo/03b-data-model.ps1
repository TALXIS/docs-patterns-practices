#
# ╔════════════════════════════════════════════════════════════════════════════════════════╗
# ║                      03b: Data Model — Solution and Entities                           ║
# ╚════════════════════════════════════════════════════════════════════════════════════════╝
#
# Creates Solutions.DataModel and 3 entities.
# Expects: $PublisherName, $PublisherPrefix from parent scope.
#
# ──────────────────────────────────────────────────────────────────────────────────────────
#                                  Solutions.DataModel
# ──────────────────────────────────────────────────────────────────────────────────────────

Write-Host "`n── Solutions.DataModel ──" -ForegroundColor Cyan

dotnet new pp-solution `
    --output "src/Solutions.DataModel" `
    --PublisherName $PublisherName `
    --PublisherPrefix $PublisherPrefix `
    --allow-scripts yes

Write-Host "  ✓ Solutions.DataModel" -ForegroundColor Green

# Add Solutions.DataModel to the Package Deployer project as a .NET ProjectReference
cd src/Packages.Main
dotnet add "./Packages.Main.csproj" reference "../Solutions.DataModel/Solutions.DataModel.csproj"
cd ../..

Write-Host "  ✓ ProjectReference: DataModel → Packages.Main" -ForegroundColor Green

# ──────────────────────────────────────────────────────────────────────────────────────────
#                                       Entities
# ──────────────────────────────────────────────────────────────────────────────────────────

Write-Host "`n── Entities (DataModel) ──" -ForegroundColor Cyan

# Warehouse Location
dotnet new pp-entity `
    --output "src/Solutions.DataModel" `
    --EntityType "Standard" `
    --Behavior "New" `
    --PublisherPrefix $PublisherPrefix `
    --LogicalName "warehouselocation" `
    --LogicalNamePlural "warehouselocations" `
    --DisplayName "Warehouse Location" `
    --DisplayNamePlural "Warehouse Locations" `
    --allow-scripts yes

Write-Host "  ✓ Entity: Warehouse Location" -ForegroundColor Green

# Warehouse Item
dotnet new pp-entity `
    --output "src/Solutions.DataModel" `
    --EntityType "Standard" `
    --Behavior "New" `
    --PublisherPrefix $PublisherPrefix `
    --LogicalName "warehouseitem" `
    --LogicalNamePlural "warehouseitems" `
    --DisplayName "Warehouse Item" `
    --DisplayNamePlural "Warehouse Items" `
    --allow-scripts yes

Write-Host "  ✓ Entity: Warehouse Item" -ForegroundColor Green

# Warehouse Transaction
dotnet new pp-entity `
    --output "src/Solutions.DataModel" `
    --EntityType "Standard" `
    --Behavior "New" `
    --PublisherPrefix $PublisherPrefix `
    --LogicalName "warehousetransaction" `
    --LogicalNamePlural "warehousetransactions" `
    --DisplayName "Warehouse Transaction" `
    --DisplayNamePlural "Warehouse Transactions" `
    --allow-scripts yes

Write-Host "  ✓ Entity: Warehouse Transaction" -ForegroundColor Green
