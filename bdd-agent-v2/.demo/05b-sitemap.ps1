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

txc workspace component create pp-sitemap-area `
    --output "src/Solutions.UI" `
    --param "AreaTitle=Warehouse" `
    --param "AppName=${PublisherPrefix}_warehouseapp"

Write-Host "  ✓ Sitemap area: Warehouse" -ForegroundColor Green

txc workspace component create pp-sitemap-group `
    --output "src/Solutions.UI" `
    --param "GroupTitle=Management" `
    --param "GroupDisplayName=Management" `
    --param "AreaTitle=Warehouse" `
    --param "AppName=${PublisherPrefix}_warehouseapp"

Write-Host "  ✓ Sitemap group: Management" -ForegroundColor Green

txc workspace component create pp-sitemap-subarea `
    --output "src/Solutions.UI" `
    --param "Title=Warehouse Locations" `
    --param "EntityLogicalName=${PublisherPrefix}_warehouselocation" `
    --param "GroupTitle=Management" `
    --param "AreaTitle=Warehouse" `
    --param "AppName=${PublisherPrefix}_warehouseapp"

Write-Host "  ✓ Sitemap subarea: Warehouse Locations" -ForegroundColor Green

txc workspace component create pp-sitemap-subarea `
    --output "src/Solutions.UI" `
    --param "Title=Warehouse Items" `
    --param "EntityLogicalName=${PublisherPrefix}_warehouseitem" `
    --param "GroupTitle=Management" `
    --param "AreaTitle=Warehouse" `
    --param "AppName=${PublisherPrefix}_warehouseapp"

Write-Host "  ✓ Sitemap subarea: Warehouse Items" -ForegroundColor Green

txc workspace component create pp-sitemap-subarea `
    --output "src/Solutions.UI" `
    --param "Title=Warehouse Transactions" `
    --param "EntityLogicalName=${PublisherPrefix}_warehousetransaction" `
    --param "GroupTitle=Management" `
    --param "AreaTitle=Warehouse" `
    --param "AppName=${PublisherPrefix}_warehouseapp"

Write-Host "  ✓ Sitemap subarea: Warehouse Transactions" -ForegroundColor Green
