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

dotnet new pp-entity-view `
    --output "src/Solutions.UI" `
    --EntitySchemaName "${PublisherPrefix}_warehouselocation" `
    --DisplayName "Active Warehouse Locations" `
    --PublisherPrefix $PublisherPrefix `
    --allow-scripts yes

Add-ViewColumns `
    -EntityLogicalName "${PublisherPrefix}_warehouselocation" `
    -PrimaryIdName "${PublisherPrefix}_warehouselocationid" `
    -Columns @("${PublisherPrefix}_address", "${PublisherPrefix}_capacity", "${PublisherPrefix}_isactive")

Write-Host "  ✓ View: Active Warehouse Locations (with columns)" -ForegroundColor Green

dotnet new pp-entity-view `
    --output "src/Solutions.UI" `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --DisplayName "Active Warehouse Items" `
    --PublisherPrefix $PublisherPrefix `
    --allow-scripts yes

Add-ViewColumns `
    -EntityLogicalName "${PublisherPrefix}_warehouseitem" `
    -PrimaryIdName "${PublisherPrefix}_warehouseitemid" `
    -Columns @("${PublisherPrefix}_sku", "${PublisherPrefix}_category", "${PublisherPrefix}_availablequantity", "${PublisherPrefix}_unitprice", "${PublisherPrefix}_locationid")

Write-Host "  ✓ View: Active Warehouse Items (with columns)" -ForegroundColor Green

dotnet new pp-entity-view `
    --output "src/Solutions.UI" `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --DisplayName "Active Warehouse Transactions" `
    --PublisherPrefix $PublisherPrefix `
    --allow-scripts yes

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
dotnet new pp-form-subgrid `
    --output "src/Solutions.UI" `
    --SubgridLabel "Warehouse Items" `
    --FormType "main" `
    --FormId $warehouselocationFormGuid `
    --TargetEntityLogicalName "${PublisherPrefix}_warehouseitem" `
    --EntityLogicalName "${PublisherPrefix}_warehouselocation" `
    --allow-scripts yes

Write-Host "  ✓ Subgrid: warehouselocation → Warehouse Items" -ForegroundColor Green

# Warehouse Item form: subgrid showing related Warehouse Transactions
dotnet new pp-form-subgrid `
    --output "src/Solutions.UI" `
    --SubgridLabel "Warehouse Transactions" `
    --FormType "main" `
    --FormId $warehouseitemFormGuid `
    --TargetEntityLogicalName "${PublisherPrefix}_warehousetransaction" `
    --EntityLogicalName "${PublisherPrefix}_warehouseitem" `
    --allow-scripts yes

Write-Host "  ✓ Subgrid: warehouseitem → Warehouse Transactions" -ForegroundColor Green
