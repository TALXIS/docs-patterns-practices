#
# ╔════════════════════════════════════════════════════════════════════════════════════════╗
# ║          05c: Forms — Main Forms, Tabs, Columns, Sections, Rows, Cells, Controls      ║
# ╚════════════════════════════════════════════════════════════════════════════════════════╝
#
# Creates main forms with full structure for all 3 entities.
# Exports $warehouselocationFormGuid, $warehouseitemFormGuid, $warehousetransactionFormGuid
# for use in subsequent scripts (views/subgrids, event handlers).
# Expects: $PublisherPrefix from parent scope.
#
# ──────────────────────────────────────────────────────────────────────────────────────────
#                                  Main Forms
# ──────────────────────────────────────────────────────────────────────────────────────────

Write-Host "`n── Main Forms ──" -ForegroundColor Cyan

# Generate GUIDs for forms (reused in tabs, cells, controls, subgrids, event handlers)
$warehouselocationFormGuid = [guid]::NewGuid()
$warehouseitemFormGuid = [guid]::NewGuid()
$warehousetransactionFormGuid = [guid]::NewGuid()

# Warehouse Location — main form
dotnet new pp-entity-form `
    --output "src/Solutions.UI" `
    --FormType "main" `
    --EntitySchemaName "${PublisherPrefix}_warehouselocation" `
    --FormId $warehouselocationFormGuid `
    --allow-scripts yes

Write-Host "  ✓ Form: warehouselocation (main)" -ForegroundColor Green

# Warehouse Item — main form
dotnet new pp-entity-form `
    --output "src/Solutions.UI" `
    --FormType "main" `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --FormId $warehouseitemFormGuid `
    --allow-scripts yes

Write-Host "  ✓ Form: warehouseitem (main)" -ForegroundColor Green

# Warehouse Transaction — main form
dotnet new pp-entity-form `
    --output "src/Solutions.UI" `
    --FormType "main" `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --FormId $warehousetransactionFormGuid `
    --allow-scripts yes

Write-Host "  ✓ Form: warehousetransaction (main)" -ForegroundColor Green

# Register forms as app components
dotnet new pp-app-model-component `
    --output "src/Solutions.UI" `
    --EntityType "Form" `
    --ComponentId "$warehouselocationFormGuid" `
    --AppName "${PublisherPrefix}_warehouseapp" `
    --allow-scripts yes

Write-Host "  ✓ App component: warehouselocation form" -ForegroundColor Green

dotnet new pp-app-model-component `
    --output "src/Solutions.UI" `
    --EntityType "Form" `
    --ComponentId "$warehouseitemFormGuid" `
    --AppName "${PublisherPrefix}_warehouseapp" `
    --allow-scripts yes

Write-Host "  ✓ App component: warehouseitem form" -ForegroundColor Green

dotnet new pp-app-model-component `
    --output "src/Solutions.UI" `
    --EntityType "Form" `
    --ComponentId "$warehousetransactionFormGuid" `
    --AppName "${PublisherPrefix}_warehouseapp" `
    --allow-scripts yes

Write-Host "  ✓ App component: warehousetransaction form" -ForegroundColor Green

# ──────────────────────────────────────────────────────────────────────────────────────────
#                              Form Tabs (replace default)
# ──────────────────────────────────────────────────────────────────────────────────────────

Write-Host "`n── Form Tabs ──" -ForegroundColor Cyan

dotnet new pp-form-tab `
    --output "src/Solutions.UI" `
    --FormType "main" `
    --FormId $warehouselocationFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouselocation" `
    --DisplayName "General" `
    --RemoveDefaultTab "True" `
    --allow-scripts yes

Write-Host "  ✓ Tab: warehouselocation → General" -ForegroundColor Green

dotnet new pp-form-tab `
    --output "src/Solutions.UI" `
    --FormType "main" `
    --FormId $warehouseitemFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --DisplayName "General" `
    --RemoveDefaultTab "True" `
    --allow-scripts yes

Write-Host "  ✓ Tab: warehouseitem → General" -ForegroundColor Green

dotnet new pp-form-tab `
    --output "src/Solutions.UI" `
    --FormType "main" `
    --FormId $warehousetransactionFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --DisplayName "General" `
    --RemoveDefaultTab "True" `
    --allow-scripts yes

Write-Host "  ✓ Tab: warehousetransaction → General" -ForegroundColor Green

# ──────────────────────────────────────────────────────────────────────────────────────────
#                          Form Columns, Sections, and Rows
# ──────────────────────────────────────────────────────────────────────────────────────────

Write-Host "`n── Form Columns, Sections, Rows ──" -ForegroundColor Cyan

# --- Warehouse Location: 1 column, 1 section, 5 rows (name, capacity, address, isactive, notes) ---

dotnet new pp-form-column `
    --output "src/Solutions.UI" `
    --FormType "main" `
    --FormId $warehouselocationFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouselocation" `
    --allow-scripts yes

dotnet new pp-form-section `
    --output "src/Solutions.UI" `
    --FormType "main" `
    --FormId $warehouselocationFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouselocation" `
    --allow-scripts yes

dotnet new pp-form-row `
    --output "src/Solutions.UI" `
    --FormType "main" `
    --FormId $warehouselocationFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouselocation" `
    --allow-scripts yes

dotnet new pp-form-row `
    --output "src/Solutions.UI" `
    --FormType "main" `
    --FormId $warehouselocationFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouselocation" `
    --allow-scripts yes

dotnet new pp-form-row `
    --output "src/Solutions.UI" `
    --FormType "main" `
    --FormId $warehouselocationFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouselocation" `
    --allow-scripts yes

dotnet new pp-form-row `
    --output "src/Solutions.UI" `
    --FormType "main" `
    --FormId $warehouselocationFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouselocation" `
    --allow-scripts yes

dotnet new pp-form-row `
    --output "src/Solutions.UI" `
    --FormType "main" `
    --FormId $warehouselocationFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouselocation" `
    --allow-scripts yes

Write-Host "  ✓ warehouselocation: column, section, 5 rows" -ForegroundColor Green

# --- Warehouse Item: 1 column, 1 section, 12 rows ---

dotnet new pp-form-column `
    --output "src/Solutions.UI" `
    --FormType "main" `
    --FormId $warehouseitemFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --allow-scripts yes

dotnet new pp-form-section `
    --output "src/Solutions.UI" `
    --FormType "main" `
    --FormId $warehouseitemFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --allow-scripts yes

dotnet new pp-form-row `
    --output "src/Solutions.UI" `
    --FormType "main" `
    --FormId $warehouseitemFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --allow-scripts yes

dotnet new pp-form-row `
    --output "src/Solutions.UI" `
    --FormType "main" `
    --FormId $warehouseitemFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --allow-scripts yes

dotnet new pp-form-row `
    --output "src/Solutions.UI" `
    --FormType "main" `
    --FormId $warehouseitemFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --allow-scripts yes

dotnet new pp-form-row `
    --output "src/Solutions.UI" `
    --FormType "main" `
    --FormId $warehouseitemFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --allow-scripts yes

dotnet new pp-form-row `
    --output "src/Solutions.UI" `
    --FormType "main" `
    --FormId $warehouseitemFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --allow-scripts yes

dotnet new pp-form-row `
    --output "src/Solutions.UI" `
    --FormType "main" `
    --FormId $warehouseitemFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --allow-scripts yes

dotnet new pp-form-row `
    --output "src/Solutions.UI" `
    --FormType "main" `
    --FormId $warehouseitemFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --allow-scripts yes

dotnet new pp-form-row `
    --output "src/Solutions.UI" `
    --FormType "main" `
    --FormId $warehouseitemFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --allow-scripts yes

dotnet new pp-form-row `
    --output "src/Solutions.UI" `
    --FormType "main" `
    --FormId $warehouseitemFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --allow-scripts yes

dotnet new pp-form-row `
    --output "src/Solutions.UI" `
    --FormType "main" `
    --FormId $warehouseitemFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --allow-scripts yes

dotnet new pp-form-row `
    --output "src/Solutions.UI" `
    --FormType "main" `
    --FormId $warehouseitemFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --allow-scripts yes

dotnet new pp-form-row `
    --output "src/Solutions.UI" `
    --FormType "main" `
    --FormId $warehouseitemFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --allow-scripts yes

Write-Host "  ✓ warehouseitem: column, section, 12 rows" -ForegroundColor Green

# --- Warehouse Transaction: 1 column, 1 section, 10 rows ---

dotnet new pp-form-column `
    --output "src/Solutions.UI" `
    --FormType "main" `
    --FormId $warehousetransactionFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --allow-scripts yes

dotnet new pp-form-section `
    --output "src/Solutions.UI" `
    --FormType "main" `
    --FormId $warehousetransactionFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --allow-scripts yes

dotnet new pp-form-row `
    --output "src/Solutions.UI" `
    --FormType "main" `
    --FormId $warehousetransactionFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --allow-scripts yes

dotnet new pp-form-row `
    --output "src/Solutions.UI" `
    --FormType "main" `
    --FormId $warehousetransactionFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --allow-scripts yes

dotnet new pp-form-row `
    --output "src/Solutions.UI" `
    --FormType "main" `
    --FormId $warehousetransactionFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --allow-scripts yes

dotnet new pp-form-row `
    --output "src/Solutions.UI" `
    --FormType "main" `
    --FormId $warehousetransactionFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --allow-scripts yes

dotnet new pp-form-row `
    --output "src/Solutions.UI" `
    --FormType "main" `
    --FormId $warehousetransactionFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --allow-scripts yes

dotnet new pp-form-row `
    --output "src/Solutions.UI" `
    --FormType "main" `
    --FormId $warehousetransactionFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --allow-scripts yes

dotnet new pp-form-row `
    --output "src/Solutions.UI" `
    --FormType "main" `
    --FormId $warehousetransactionFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --allow-scripts yes

dotnet new pp-form-row `
    --output "src/Solutions.UI" `
    --FormType "main" `
    --FormId $warehousetransactionFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --allow-scripts yes

dotnet new pp-form-row `
    --output "src/Solutions.UI" `
    --FormType "main" `
    --FormId $warehousetransactionFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --allow-scripts yes

dotnet new pp-form-row `
    --output "src/Solutions.UI" `
    --FormType "main" `
    --FormId $warehousetransactionFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --allow-scripts yes

Write-Host "  ✓ warehousetransaction: column, section, 10 rows" -ForegroundColor Green

# ──────────────────────────────────────────────────────────────────────────────────────────
#                                  Form Cells
# ──────────────────────────────────────────────────────────────────────────────────────────

Write-Host "`n── Form Cells ──" -ForegroundColor Cyan

# --- Warehouse Location cells ---

dotnet new pp-form-cell `
    --output "src/Solutions.UI" `
    --RowIndex "1" `
    --FormType "main" `
    --DisplayName "Name" `
    --FormId $warehouselocationFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouselocation" `
    --allow-scripts yes

dotnet new pp-form-cell `
    --output "src/Solutions.UI" `
    --RowIndex "2" `
    --FormType "main" `
    --DisplayName "Capacity" `
    --FormId $warehouselocationFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouselocation" `
    --allow-scripts yes

dotnet new pp-form-cell `
    --output "src/Solutions.UI" `
    --RowIndex "3" `
    --FormType "main" `
    --DisplayName "Address" `
    --FormId $warehouselocationFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouselocation" `
    --allow-scripts yes

dotnet new pp-form-cell `
    --output "src/Solutions.UI" `
    --RowIndex "4" `
    --FormType "main" `
    --DisplayName "Is Active" `
    --FormId $warehouselocationFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouselocation" `
    --allow-scripts yes

dotnet new pp-form-cell `
    --output "src/Solutions.UI" `
    --RowIndex "5" `
    --FormType "main" `
    --DisplayName "Notes" `
    --FormId $warehouselocationFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouselocation" `
    --allow-scripts yes

Write-Host "  ✓ warehouselocation cells: Name, Capacity, Address, Is Active, Notes" -ForegroundColor Green

# --- Warehouse Item cells ---

dotnet new pp-form-cell `
    --output "src/Solutions.UI" `
    --RowIndex "1" `
    --FormType "main" `
    --DisplayName "Name" `
    --FormId $warehouseitemFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --allow-scripts yes

dotnet new pp-form-cell `
    --output "src/Solutions.UI" `
    --RowIndex "2" `
    --FormType "main" `
    --DisplayName "SKU" `
    --FormId $warehouseitemFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --allow-scripts yes

dotnet new pp-form-cell `
    --output "src/Solutions.UI" `
    --RowIndex "3" `
    --FormType "main" `
    --DisplayName "Available Quantity" `
    --FormId $warehouseitemFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --allow-scripts yes

dotnet new pp-form-cell `
    --output "src/Solutions.UI" `
    --RowIndex "4" `
    --FormType "main" `
    --DisplayName "Location" `
    --FormId $warehouseitemFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --allow-scripts yes

dotnet new pp-form-cell `
    --output "src/Solutions.UI" `
    --RowIndex "5" `
    --FormType "main" `
    --DisplayName "Description" `
    --FormId $warehouseitemFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --allow-scripts yes

dotnet new pp-form-cell `
    --output "src/Solutions.UI" `
    --RowIndex "6" `
    --FormType "main" `
    --DisplayName "Unit Price" `
    --FormId $warehouseitemFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --allow-scripts yes

dotnet new pp-form-cell `
    --output "src/Solutions.UI" `
    --RowIndex "7" `
    --FormType "main" `
    --DisplayName "Weight (kg)" `
    --FormId $warehouseitemFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --allow-scripts yes

dotnet new pp-form-cell `
    --output "src/Solutions.UI" `
    --RowIndex "8" `
    --FormType "main" `
    --DisplayName "Category" `
    --FormId $warehouseitemFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --allow-scripts yes

dotnet new pp-form-cell `
    --output "src/Solutions.UI" `
    --RowIndex "9" `
    --FormType "main" `
    --DisplayName "Is Perishable" `
    --FormId $warehouseitemFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --allow-scripts yes

dotnet new pp-form-cell `
    --output "src/Solutions.UI" `
    --RowIndex "10" `
    --FormType "main" `
    --DisplayName "Expiration Date" `
    --FormId $warehouseitemFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --allow-scripts yes

dotnet new pp-form-cell `
    --output "src/Solutions.UI" `
    --RowIndex "11" `
    --FormType "main" `
    --DisplayName "Barcode" `
    --FormId $warehouseitemFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --allow-scripts yes

dotnet new pp-form-cell `
    --output "src/Solutions.UI" `
    --RowIndex "12" `
    --FormType "main" `
    --DisplayName "Reorder Point" `
    --FormId $warehouseitemFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --allow-scripts yes

Write-Host "  ✓ warehouseitem cells: Name, SKU, Available Quantity, Location, Description, Unit Price, Weight, Category, Is Perishable, Expiration Date, Barcode, Reorder Point" -ForegroundColor Green

# --- Warehouse Transaction cells ---

dotnet new pp-form-cell `
    --output "src/Solutions.UI" `
    --RowIndex "1" `
    --FormType "main" `
    --DisplayName "Name" `
    --FormId $warehousetransactionFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --allow-scripts yes

dotnet new pp-form-cell `
    --output "src/Solutions.UI" `
    --RowIndex "2" `
    --FormType "main" `
    --DisplayName "Item" `
    --FormId $warehousetransactionFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --allow-scripts yes

dotnet new pp-form-cell `
    --output "src/Solutions.UI" `
    --RowIndex "3" `
    --FormType "main" `
    --DisplayName "Quantity" `
    --FormId $warehousetransactionFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --allow-scripts yes

dotnet new pp-form-cell `
    --output "src/Solutions.UI" `
    --RowIndex "4" `
    --FormType "main" `
    --DisplayName "Transaction Type" `
    --FormId $warehousetransactionFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --allow-scripts yes

dotnet new pp-form-cell `
    --output "src/Solutions.UI" `
    --RowIndex "5" `
    --FormType "main" `
    --DisplayName "Transaction Date" `
    --FormId $warehousetransactionFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --allow-scripts yes

dotnet new pp-form-cell `
    --output "src/Solutions.UI" `
    --RowIndex "6" `
    --FormType "main" `
    --DisplayName "Notes" `
    --FormId $warehousetransactionFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --allow-scripts yes

dotnet new pp-form-cell `
    --output "src/Solutions.UI" `
    --RowIndex "7" `
    --FormType "main" `
    --DisplayName "Total Value" `
    --FormId $warehousetransactionFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --allow-scripts yes

dotnet new pp-form-cell `
    --output "src/Solutions.UI" `
    --RowIndex "8" `
    --FormType "main" `
    --DisplayName "Is Processed" `
    --FormId $warehousetransactionFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --allow-scripts yes

dotnet new pp-form-cell `
    --output "src/Solutions.UI" `
    --RowIndex "9" `
    --FormType "main" `
    --DisplayName "Processed By" `
    --FormId $warehousetransactionFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --allow-scripts yes

dotnet new pp-form-cell `
    --output "src/Solutions.UI" `
    --RowIndex "10" `
    --FormType "main" `
    --DisplayName "Reference Number" `
    --FormId $warehousetransactionFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --allow-scripts yes

Write-Host "  ✓ warehousetransaction cells: Name, Item, Quantity, Transaction Type, Transaction Date, Notes, Total Value, Is Processed, Processed By, Reference Number" -ForegroundColor Green

# ──────────────────────────────────────────────────────────────────────────────────────────
#                                  Form Controls
# ──────────────────────────────────────────────────────────────────────────────────────────

Write-Host "`n── Form Controls ──" -ForegroundColor Cyan

# --- Warehouse Location controls ---

dotnet new pp-form-control `
    --output "src/Solutions.UI" `
    --ControlType "Text" `
    --RowIndex "1" `
    --AttributeLogicalName "${PublisherPrefix}_name" `
    --FormType "main" `
    --FormId $warehouselocationFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouselocation" `
    --allow-scripts yes

dotnet new pp-form-control `
    --output "src/Solutions.UI" `
    --ControlType "WholeNumber" `
    --RowIndex "2" `
    --AttributeLogicalName "${PublisherPrefix}_capacity" `
    --FormType "main" `
    --FormId $warehouselocationFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouselocation" `
    --allow-scripts yes

dotnet new pp-form-control `
    --output "src/Solutions.UI" `
    --ControlType "Text" `
    --RowIndex "3" `
    --AttributeLogicalName "${PublisherPrefix}_address" `
    --FormType "main" `
    --FormId $warehouselocationFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouselocation" `
    --allow-scripts yes

dotnet new pp-form-control `
    --output "src/Solutions.UI" `
    --ControlType "OptionSet" `
    --RowIndex "4" `
    --AttributeLogicalName "${PublisherPrefix}_isactive" `
    --FormType "main" `
    --FormId $warehouselocationFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouselocation" `
    --allow-scripts yes

dotnet new pp-form-control `
    --output "src/Solutions.UI" `
    --ControlType "MultilineText" `
    --RowIndex "5" `
    --AttributeLogicalName "${PublisherPrefix}_notes" `
    --FormType "main" `
    --FormId $warehouselocationFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouselocation" `
    --allow-scripts yes

Write-Host "  ✓ warehouselocation controls: name, capacity, address, isactive, notes" -ForegroundColor Green

# --- Warehouse Item controls ---

dotnet new pp-form-control `
    --output "src/Solutions.UI" `
    --ControlType "Text" `
    --RowIndex "1" `
    --AttributeLogicalName "${PublisherPrefix}_name" `
    --FormType "main" `
    --FormId $warehouseitemFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --allow-scripts yes

dotnet new pp-form-control `
    --output "src/Solutions.UI" `
    --ControlType "Text" `
    --RowIndex "2" `
    --AttributeLogicalName "${PublisherPrefix}_sku" `
    --FormType "main" `
    --FormId $warehouseitemFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --allow-scripts yes

dotnet new pp-form-control `
    --output "src/Solutions.UI" `
    --ControlType "WholeNumber" `
    --RowIndex "3" `
    --AttributeLogicalName "${PublisherPrefix}_availablequantity" `
    --FormType "main" `
    --FormId $warehouseitemFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --allow-scripts yes

dotnet new pp-form-control `
    --output "src/Solutions.UI" `
    --ControlType "Lookup" `
    --RowIndex "4" `
    --AttributeLogicalName "${PublisherPrefix}_locationid" `
    --FormType "main" `
    --FormId $warehouseitemFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --allow-scripts yes

dotnet new pp-form-control `
    --output "src/Solutions.UI" `
    --ControlType "MultilineText" `
    --RowIndex "5" `
    --AttributeLogicalName "${PublisherPrefix}_description" `
    --FormType "main" `
    --FormId $warehouseitemFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --allow-scripts yes

dotnet new pp-form-control `
    --output "src/Solutions.UI" `
    --ControlType "Currency" `
    --RowIndex "6" `
    --AttributeLogicalName "${PublisherPrefix}_unitprice" `
    --FormType "main" `
    --FormId $warehouseitemFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --allow-scripts yes

dotnet new pp-form-control `
    --output "src/Solutions.UI" `
    --ControlType "Decimal" `
    --RowIndex "7" `
    --AttributeLogicalName "${PublisherPrefix}_weight" `
    --FormType "main" `
    --FormId $warehouseitemFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --allow-scripts yes

dotnet new pp-form-control `
    --output "src/Solutions.UI" `
    --ControlType "OptionSet" `
    --RowIndex "8" `
    --AttributeLogicalName "${PublisherPrefix}_category" `
    --FormType "main" `
    --FormId $warehouseitemFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --allow-scripts yes

dotnet new pp-form-control `
    --output "src/Solutions.UI" `
    --ControlType "OptionSet" `
    --RowIndex "9" `
    --AttributeLogicalName "${PublisherPrefix}_isperishable" `
    --FormType "main" `
    --FormId $warehouseitemFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --allow-scripts yes

dotnet new pp-form-control `
    --output "src/Solutions.UI" `
    --ControlType "DateTime" `
    --RowIndex "10" `
    --AttributeLogicalName "${PublisherPrefix}_expirationdate" `
    --FormType "main" `
    --FormId $warehouseitemFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --allow-scripts yes

dotnet new pp-form-control `
    --output "src/Solutions.UI" `
    --ControlType "Text" `
    --RowIndex "11" `
    --AttributeLogicalName "${PublisherPrefix}_barcode" `
    --FormType "main" `
    --FormId $warehouseitemFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --allow-scripts yes

dotnet new pp-form-control `
    --output "src/Solutions.UI" `
    --ControlType "WholeNumber" `
    --RowIndex "12" `
    --AttributeLogicalName "${PublisherPrefix}_reorderpoint" `
    --FormType "main" `
    --FormId $warehouseitemFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --allow-scripts yes

Write-Host "  ✓ warehouseitem controls: name, sku, availablequantity, locationid, description, unitprice, weight, category, isperishable, expirationdate, barcode, reorderpoint" -ForegroundColor Green

# --- Warehouse Transaction controls ---

dotnet new pp-form-control `
    --output "src/Solutions.UI" `
    --ControlType "Text" `
    --RowIndex "1" `
    --AttributeLogicalName "${PublisherPrefix}_name" `
    --FormType "main" `
    --FormId $warehousetransactionFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --allow-scripts yes

dotnet new pp-form-control `
    --output "src/Solutions.UI" `
    --ControlType "Lookup" `
    --RowIndex "2" `
    --AttributeLogicalName "${PublisherPrefix}_itemid" `
    --FormType "main" `
    --FormId $warehousetransactionFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --allow-scripts yes

dotnet new pp-form-control `
    --output "src/Solutions.UI" `
    --ControlType "WholeNumber" `
    --RowIndex "3" `
    --AttributeLogicalName "${PublisherPrefix}_quantity" `
    --FormType "main" `
    --FormId $warehousetransactionFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --allow-scripts yes

dotnet new pp-form-control `
    --output "src/Solutions.UI" `
    --ControlType "OptionSet" `
    --RowIndex "4" `
    --AttributeLogicalName "${PublisherPrefix}_transactiontype" `
    --FormType "main" `
    --FormId $warehousetransactionFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --allow-scripts yes

dotnet new pp-form-control `
    --output "src/Solutions.UI" `
    --ControlType "DateTime" `
    --RowIndex "5" `
    --AttributeLogicalName "${PublisherPrefix}_transactiondate" `
    --FormType "main" `
    --FormId $warehousetransactionFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --allow-scripts yes

dotnet new pp-form-control `
    --output "src/Solutions.UI" `
    --ControlType "MultilineText" `
    --RowIndex "6" `
    --AttributeLogicalName "${PublisherPrefix}_notes" `
    --FormType "main" `
    --FormId $warehousetransactionFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --allow-scripts yes

dotnet new pp-form-control `
    --output "src/Solutions.UI" `
    --ControlType "Currency" `
    --RowIndex "7" `
    --AttributeLogicalName "${PublisherPrefix}_totalvalue" `
    --FormType "main" `
    --FormId $warehousetransactionFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --allow-scripts yes

dotnet new pp-form-control `
    --output "src/Solutions.UI" `
    --ControlType "OptionSet" `
    --RowIndex "8" `
    --AttributeLogicalName "${PublisherPrefix}_isprocessed" `
    --FormType "main" `
    --FormId $warehousetransactionFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --allow-scripts yes

dotnet new pp-form-control `
    --output "src/Solutions.UI" `
    --ControlType "Text" `
    --RowIndex "9" `
    --AttributeLogicalName "${PublisherPrefix}_processedby" `
    --FormType "main" `
    --FormId $warehousetransactionFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --allow-scripts yes

dotnet new pp-form-control `
    --output "src/Solutions.UI" `
    --ControlType "Text" `
    --RowIndex "10" `
    --AttributeLogicalName "${PublisherPrefix}_referencenumber" `
    --FormType "main" `
    --FormId $warehousetransactionFormGuid `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --allow-scripts yes

Write-Host "  ✓ warehousetransaction controls: name, itemid, quantity, transactiontype, transactiondate, notes, totalvalue, isprocessed, processedby, referencenumber" -ForegroundColor Green
