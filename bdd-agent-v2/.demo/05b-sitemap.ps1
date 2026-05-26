#
# ╔════════════════════════════════════════════════════════════════════════════════════════╗
# ║                    05b: Sitemap Navigation (Area, Group, Subareas)                     ║
# ╚════════════════════════════════════════════════════════════════════════════════════════╝
#
# Adds sitemap navigation structure to the model-driven app.
# Expects: $PublisherPrefix from parent scope.
#
# ──────────────────────────────────────────────────────────────────────────────────────────

Write-Host "`n── Sitemap Navigation ──" -ForegroundColor Cyan

dotnet new pp-sitemap-area `
    --output "src/Solutions.UI" `
    --AreaTitle "Warehouse" `
    --AppName "${PublisherPrefix}_warehouseapp" `
    --allow-scripts yes

Write-Host "  ✓ Sitemap area: Warehouse" -ForegroundColor Green

dotnet new pp-sitemap-group `
    --output "src/Solutions.UI" `
    --GroupTitle "Management" `
    --GroupDisplayName "Management" `
    --AreaTitle "Warehouse" `
    --AppName "${PublisherPrefix}_warehouseapp" `
    --allow-scripts yes

Write-Host "  ✓ Sitemap group: Management" -ForegroundColor Green

dotnet new pp-sitemap-subarea `
    --output "src/Solutions.UI" `
    --Title "Warehouse Locations" `
    --EntityLogicalName "${PublisherPrefix}_warehouselocation" `
    --GroupTitle "Management" `
    --AreaTitle "Warehouse" `
    --AppName "${PublisherPrefix}_warehouseapp" `
    --allow-scripts yes

Write-Host "  ✓ Sitemap subarea: Warehouse Locations" -ForegroundColor Green

dotnet new pp-sitemap-subarea `
    --output "src/Solutions.UI" `
    --Title "Warehouse Items" `
    --EntityLogicalName "${PublisherPrefix}_warehouseitem" `
    --GroupTitle "Management" `
    --AreaTitle "Warehouse" `
    --AppName "${PublisherPrefix}_warehouseapp" `
    --allow-scripts yes

Write-Host "  ✓ Sitemap subarea: Warehouse Items" -ForegroundColor Green

dotnet new pp-sitemap-subarea `
    --output "src/Solutions.UI" `
    --Title "Warehouse Transactions" `
    --EntityLogicalName "${PublisherPrefix}_warehousetransaction" `
    --GroupTitle "Management" `
    --AreaTitle "Warehouse" `
    --AppName "${PublisherPrefix}_warehouseapp" `
    --allow-scripts yes

Write-Host "  ✓ Sitemap subarea: Warehouse Transactions" -ForegroundColor Green
