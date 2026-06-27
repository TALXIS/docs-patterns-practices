#
# ╔════════════════════════════════════════════════════════════════════════════════════════╗
# ║                       05d: Views and Subgrids                                          ║
# ╚════════════════════════════════════════════════════════════════════════════════════════╝
#
# Creates views for all entities and subgrids on parent forms.
# Expects: $PublisherPrefix, $warehouselocationFormGuid, $warehouseitemFormGuid,
#          $warehousetransactionFormGuid from parent scope (set in 05c-forms.ps1).
#
# ──────────────────────────────────────────────────────────────────────────────────────────
#                                  Views
# ──────────────────────────────────────────────────────────────────────────────────────────

Write-Host "`n── Views ──" -ForegroundColor Cyan

# Helper: pp-entity-view generates a minimal lookup view (querytype=64) with only
# the primary name column. After scaffolding, we patch the XML to add
# entity-specific columns to both layoutxml and fetchxml.
function Add-ViewColumns {
    param(
        [string]$EntityDir,
        [string]$EntityLogicalName,
        [string]$PrimaryIdName,
        [string[]]$Columns  # logical names of columns to add
    )

    $prefix = $PublisherPrefix
    $viewDir = "src/Solutions.UI/Entities/${EntityLogicalName}/SavedQueries"
    if (-not (Test-Path $viewDir)) { return }

    # Find the most recently created XML (the one just scaffolded)
    $viewFile = Get-ChildItem "$viewDir/*.xml" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if (-not $viewFile) { return }

    $xml = [xml](Get-Content $viewFile.FullName -Raw)
    $row = $xml.SelectSingleNode("//row")
    $fetchEntity = $xml.SelectSingleNode("//entity")

    foreach ($col in $Columns) {
        # Add cell to layoutxml
        $cell = $xml.CreateElement("cell")
        $cell.SetAttribute("name", $col)
        $cell.SetAttribute("width", "125")
        $row.AppendChild($cell) | Out-Null

        # Add attribute to fetchxml
        $attr = $xml.CreateElement("attribute")
        $attr.SetAttribute("name", $col)
        $fetchEntity.AppendChild($attr) | Out-Null
    }

    $xml.Save($viewFile.FullName)
}

txc workspace component create pp-entity-view `
    --output "src/Solutions.UI" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouselocation" `
    --param "DisplayName=Active Warehouse Locations" `
    --param "PublisherPrefix=$PublisherPrefix"

Add-ViewColumns `
    -EntityLogicalName "${PublisherPrefix}_warehouselocation" `
    -PrimaryIdName "${PublisherPrefix}_warehouselocationid" `
    -Columns @("${PublisherPrefix}_address", "${PublisherPrefix}_capacity", "${PublisherPrefix}_isactive")

Write-Host "  ✓ View: Active Warehouse Locations (with columns)" -ForegroundColor Green

txc workspace component create pp-entity-view `
    --output "src/Solutions.UI" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem" `
    --param "DisplayName=Active Warehouse Items" `
    --param "PublisherPrefix=$PublisherPrefix"

Add-ViewColumns `
    -EntityLogicalName "${PublisherPrefix}_warehouseitem" `
    -PrimaryIdName "${PublisherPrefix}_warehouseitemid" `
    -Columns @("${PublisherPrefix}_sku", "${PublisherPrefix}_category", "${PublisherPrefix}_availablequantity", "${PublisherPrefix}_unitprice", "${PublisherPrefix}_locationid")

Write-Host "  ✓ View: Active Warehouse Items (with columns)" -ForegroundColor Green

txc workspace component create pp-entity-view `
    --output "src/Solutions.UI" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction" `
    --param "DisplayName=Active Warehouse Transactions" `
    --param "PublisherPrefix=$PublisherPrefix"

Add-ViewColumns `
    -EntityLogicalName "${PublisherPrefix}_warehousetransaction" `
    -PrimaryIdName "${PublisherPrefix}_warehousetransactionid" `
    -Columns @("${PublisherPrefix}_transactiontype", "${PublisherPrefix}_itemid", "${PublisherPrefix}_quantity", "${PublisherPrefix}_transactiondate", "${PublisherPrefix}_totalvalue")

Write-Host "  ✓ View: Active Warehouse Transactions (with columns)" -ForegroundColor Green

# ──────────────────────────────────────────────────────────────────────────────────────────
#                                  Subgrids
# ──────────────────────────────────────────────────────────────────────────────────────────

Write-Host "`n── Subgrids ──" -ForegroundColor Cyan

# Warehouse Location form: subgrid showing related Warehouse Items
txc workspace component create pp-form-subgrid `
    --output "src/Solutions.UI" `
    --param "SubgridLabel=Warehouse Items" `
    --param "FormType=main" `
    --param "FormId=$warehouselocationFormGuid" `
    --param "TargetEntityLogicalName=${PublisherPrefix}_warehouseitem" `
    --param "EntityLogicalName=${PublisherPrefix}_warehouselocation"

Write-Host "  ✓ Subgrid: warehouselocation → Warehouse Items" -ForegroundColor Green

# Warehouse Item form: subgrid showing related Warehouse Transactions
txc workspace component create pp-form-subgrid `
    --output "src/Solutions.UI" `
    --param "SubgridLabel=Warehouse Transactions" `
    --param "FormType=main" `
    --param "FormId=$warehouseitemFormGuid" `
    --param "TargetEntityLogicalName=${PublisherPrefix}_warehousetransaction" `
    --param "EntityLogicalName=${PublisherPrefix}_warehouseitem"

Write-Host "  ✓ Subgrid: warehouseitem → Warehouse Transactions" -ForegroundColor Green
