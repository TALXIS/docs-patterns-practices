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

txc workspace component create pp-solution `
    --output "src/Solutions.DataModel" `
    --param "PublisherName=$PublisherName" `
    --param "PublisherPrefix=$PublisherPrefix"

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
txc workspace component create pp-entity `
    --output "src/Solutions.DataModel" `
    --param "EntityType=Standard" `
    --param "Behavior=New" `
    --param "PublisherPrefix=$PublisherPrefix" `
    --param "LogicalName=warehouselocation" `
    --param "LogicalNamePlural=warehouselocations" `
    --param "DisplayName=Warehouse Location" `
    --param "DisplayNamePlural=Warehouse Locations"

Write-Host "  ✓ Entity: Warehouse Location" -ForegroundColor Green

# Warehouse Item
txc workspace component create pp-entity `
    --output "src/Solutions.DataModel" `
    --param "EntityType=Standard" `
    --param "Behavior=New" `
    --param "PublisherPrefix=$PublisherPrefix" `
    --param "LogicalName=warehouseitem" `
    --param "LogicalNamePlural=warehouseitems" `
    --param "DisplayName=Warehouse Item" `
    --param "DisplayNamePlural=Warehouse Items"

Write-Host "  ✓ Entity: Warehouse Item" -ForegroundColor Green

# Warehouse Transaction
txc workspace component create pp-entity `
    --output "src/Solutions.DataModel" `
    --param "EntityType=Standard" `
    --param "Behavior=New" `
    --param "PublisherPrefix=$PublisherPrefix" `
    --param "LogicalName=warehousetransaction" `
    --param "LogicalNamePlural=warehousetransactions" `
    --param "DisplayName=Warehouse Transaction" `
    --param "DisplayNamePlural=Warehouse Transactions"

Write-Host "  ✓ Entity: Warehouse Transaction" -ForegroundColor Green
