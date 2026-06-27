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
txc workspace component create pp-entity-form `
    --output "src/Solutions.UI" `
    --param "FormType=main" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouselocation" `
    --param "FormId=$warehouselocationFormGuid"

Write-Host "  ✓ Form: warehouselocation (main)" -ForegroundColor Green

# Warehouse Item — main form
txc workspace component create pp-entity-form `
    --output "src/Solutions.UI" `
    --param "FormType=main" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem" `
    --param "FormId=$warehouseitemFormGuid"

Write-Host "  ✓ Form: warehouseitem (main)" -ForegroundColor Green

# Warehouse Transaction — main form
txc workspace component create pp-entity-form `
    --output "src/Solutions.UI" `
    --param "FormType=main" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction" `
    --param "FormId=$warehousetransactionFormGuid"

Write-Host "  ✓ Form: warehousetransaction (main)" -ForegroundColor Green

# Register forms as app components
txc workspace component create pp-app-model-component `
    --output "src/Solutions.UI" `
    --param "EntityType=Form" `
    --param "ComponentId=$warehouselocationFormGuid" `
    --param "AppName=${PublisherPrefix}_warehouseapp"

Write-Host "  ✓ App component: warehouselocation form" -ForegroundColor Green

txc workspace component create pp-app-model-component `
    --output "src/Solutions.UI" `
    --param "EntityType=Form" `
    --param "ComponentId=$warehouseitemFormGuid" `
    --param "AppName=${PublisherPrefix}_warehouseapp"

Write-Host "  ✓ App component: warehouseitem form" -ForegroundColor Green

txc workspace component create pp-app-model-component `
    --output "src/Solutions.UI" `
    --param "EntityType=Form" `
    --param "ComponentId=$warehousetransactionFormGuid" `
    --param "AppName=${PublisherPrefix}_warehouseapp"

Write-Host "  ✓ App component: warehousetransaction form" -ForegroundColor Green

# ──────────────────────────────────────────────────────────────────────────────────────────
#                              Form Tabs (replace default)
# ──────────────────────────────────────────────────────────────────────────────────────────

Write-Host "`n── Form Tabs ──" -ForegroundColor Cyan

txc workspace component create pp-form-tab `
    --output "src/Solutions.UI" `
    --param "FormType=main" `
    --param "FormId=$warehouselocationFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouselocation" `
    --param "DisplayName=General" `
    --param "RemoveDefaultTab=True"

Write-Host "  ✓ Tab: warehouselocation → General" -ForegroundColor Green

txc workspace component create pp-form-tab `
    --output "src/Solutions.UI" `
    --param "FormType=main" `
    --param "FormId=$warehouseitemFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem" `
    --param "DisplayName=General" `
    --param "RemoveDefaultTab=True"

Write-Host "  ✓ Tab: warehouseitem → General" -ForegroundColor Green

txc workspace component create pp-form-tab `
    --output "src/Solutions.UI" `
    --param "FormType=main" `
    --param "FormId=$warehousetransactionFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction" `
    --param "DisplayName=General" `
    --param "RemoveDefaultTab=True"

Write-Host "  ✓ Tab: warehousetransaction → General" -ForegroundColor Green

# ──────────────────────────────────────────────────────────────────────────────────────────
#                          Form Columns, Sections, and Rows
# ──────────────────────────────────────────────────────────────────────────────────────────

Write-Host "`n── Form Columns, Sections, Rows ──" -ForegroundColor Cyan

# --- Warehouse Location: 1 column, 1 section, 5 rows (name, capacity, address, isactive, notes) ---

txc workspace component create pp-form-column `
    --output "src/Solutions.UI" `
    --param "FormType=main" `
    --param "FormId=$warehouselocationFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouselocation"

txc workspace component create pp-form-section `
    --output "src/Solutions.UI" `
    --param "FormType=main" `
    --param "FormId=$warehouselocationFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouselocation"

txc workspace component create pp-form-row `
    --output "src/Solutions.UI" `
    --param "FormType=main" `
    --param "FormId=$warehouselocationFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouselocation"

txc workspace component create pp-form-row `
    --output "src/Solutions.UI" `
    --param "FormType=main" `
    --param "FormId=$warehouselocationFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouselocation"

txc workspace component create pp-form-row `
    --output "src/Solutions.UI" `
    --param "FormType=main" `
    --param "FormId=$warehouselocationFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouselocation"

txc workspace component create pp-form-row `
    --output "src/Solutions.UI" `
    --param "FormType=main" `
    --param "FormId=$warehouselocationFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouselocation"

txc workspace component create pp-form-row `
    --output "src/Solutions.UI" `
    --param "FormType=main" `
    --param "FormId=$warehouselocationFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouselocation"

Write-Host "  ✓ warehouselocation: column, section, 5 rows" -ForegroundColor Green

# --- Warehouse Item: 1 column, 1 section, 12 rows ---

txc workspace component create pp-form-column `
    --output "src/Solutions.UI" `
    --param "FormType=main" `
    --param "FormId=$warehouseitemFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem"

txc workspace component create pp-form-section `
    --output "src/Solutions.UI" `
    --param "FormType=main" `
    --param "FormId=$warehouseitemFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem"

txc workspace component create pp-form-row `
    --output "src/Solutions.UI" `
    --param "FormType=main" `
    --param "FormId=$warehouseitemFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem"

txc workspace component create pp-form-row `
    --output "src/Solutions.UI" `
    --param "FormType=main" `
    --param "FormId=$warehouseitemFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem"

txc workspace component create pp-form-row `
    --output "src/Solutions.UI" `
    --param "FormType=main" `
    --param "FormId=$warehouseitemFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem"

txc workspace component create pp-form-row `
    --output "src/Solutions.UI" `
    --param "FormType=main" `
    --param "FormId=$warehouseitemFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem"

txc workspace component create pp-form-row `
    --output "src/Solutions.UI" `
    --param "FormType=main" `
    --param "FormId=$warehouseitemFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem"

txc workspace component create pp-form-row `
    --output "src/Solutions.UI" `
    --param "FormType=main" `
    --param "FormId=$warehouseitemFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem"

txc workspace component create pp-form-row `
    --output "src/Solutions.UI" `
    --param "FormType=main" `
    --param "FormId=$warehouseitemFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem"

txc workspace component create pp-form-row `
    --output "src/Solutions.UI" `
    --param "FormType=main" `
    --param "FormId=$warehouseitemFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem"

txc workspace component create pp-form-row `
    --output "src/Solutions.UI" `
    --param "FormType=main" `
    --param "FormId=$warehouseitemFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem"

txc workspace component create pp-form-row `
    --output "src/Solutions.UI" `
    --param "FormType=main" `
    --param "FormId=$warehouseitemFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem"

txc workspace component create pp-form-row `
    --output "src/Solutions.UI" `
    --param "FormType=main" `
    --param "FormId=$warehouseitemFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem"

txc workspace component create pp-form-row `
    --output "src/Solutions.UI" `
    --param "FormType=main" `
    --param "FormId=$warehouseitemFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem"

Write-Host "  ✓ warehouseitem: column, section, 12 rows" -ForegroundColor Green

# --- Warehouse Transaction: 1 column, 1 section, 10 rows ---

txc workspace component create pp-form-column `
    --output "src/Solutions.UI" `
    --param "FormType=main" `
    --param "FormId=$warehousetransactionFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction"

txc workspace component create pp-form-section `
    --output "src/Solutions.UI" `
    --param "FormType=main" `
    --param "FormId=$warehousetransactionFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction"

txc workspace component create pp-form-row `
    --output "src/Solutions.UI" `
    --param "FormType=main" `
    --param "FormId=$warehousetransactionFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction"

txc workspace component create pp-form-row `
    --output "src/Solutions.UI" `
    --param "FormType=main" `
    --param "FormId=$warehousetransactionFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction"

txc workspace component create pp-form-row `
    --output "src/Solutions.UI" `
    --param "FormType=main" `
    --param "FormId=$warehousetransactionFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction"

txc workspace component create pp-form-row `
    --output "src/Solutions.UI" `
    --param "FormType=main" `
    --param "FormId=$warehousetransactionFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction"

txc workspace component create pp-form-row `
    --output "src/Solutions.UI" `
    --param "FormType=main" `
    --param "FormId=$warehousetransactionFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction"

txc workspace component create pp-form-row `
    --output "src/Solutions.UI" `
    --param "FormType=main" `
    --param "FormId=$warehousetransactionFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction"

txc workspace component create pp-form-row `
    --output "src/Solutions.UI" `
    --param "FormType=main" `
    --param "FormId=$warehousetransactionFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction"

txc workspace component create pp-form-row `
    --output "src/Solutions.UI" `
    --param "FormType=main" `
    --param "FormId=$warehousetransactionFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction"

txc workspace component create pp-form-row `
    --output "src/Solutions.UI" `
    --param "FormType=main" `
    --param "FormId=$warehousetransactionFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction"

txc workspace component create pp-form-row `
    --output "src/Solutions.UI" `
    --param "FormType=main" `
    --param "FormId=$warehousetransactionFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction"

Write-Host "  ✓ warehousetransaction: column, section, 10 rows" -ForegroundColor Green

# ──────────────────────────────────────────────────────────────────────────────────────────
#                                  Form Cells
# ──────────────────────────────────────────────────────────────────────────────────────────

Write-Host "`n── Form Cells ──" -ForegroundColor Cyan

# --- Warehouse Location cells ---

txc workspace component create pp-form-cell `
    --output "src/Solutions.UI" `
    --param "RowIndex=1" `
    --param "FormType=main" `
    --param "DisplayName=Name" `
    --param "FormId=$warehouselocationFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouselocation"

txc workspace component create pp-form-cell `
    --output "src/Solutions.UI" `
    --param "RowIndex=2" `
    --param "FormType=main" `
    --param "DisplayName=Capacity" `
    --param "FormId=$warehouselocationFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouselocation"

txc workspace component create pp-form-cell `
    --output "src/Solutions.UI" `
    --param "RowIndex=3" `
    --param "FormType=main" `
    --param "DisplayName=Address" `
    --param "FormId=$warehouselocationFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouselocation"

txc workspace component create pp-form-cell `
    --output "src/Solutions.UI" `
    --param "RowIndex=4" `
    --param "FormType=main" `
    --param "DisplayName=Is Active" `
    --param "FormId=$warehouselocationFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouselocation"

txc workspace component create pp-form-cell `
    --output "src/Solutions.UI" `
    --param "RowIndex=5" `
    --param "FormType=main" `
    --param "DisplayName=Notes" `
    --param "FormId=$warehouselocationFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouselocation"

Write-Host "  ✓ warehouselocation cells: Name, Capacity, Address, Is Active, Notes" -ForegroundColor Green

# --- Warehouse Item cells ---

txc workspace component create pp-form-cell `
    --output "src/Solutions.UI" `
    --param "RowIndex=1" `
    --param "FormType=main" `
    --param "DisplayName=Name" `
    --param "FormId=$warehouseitemFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem"

txc workspace component create pp-form-cell `
    --output "src/Solutions.UI" `
    --param "RowIndex=2" `
    --param "FormType=main" `
    --param "DisplayName=SKU" `
    --param "FormId=$warehouseitemFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem"

txc workspace component create pp-form-cell `
    --output "src/Solutions.UI" `
    --param "RowIndex=3" `
    --param "FormType=main" `
    --param "DisplayName=Available Quantity" `
    --param "FormId=$warehouseitemFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem"

txc workspace component create pp-form-cell `
    --output "src/Solutions.UI" `
    --param "RowIndex=4" `
    --param "FormType=main" `
    --param "DisplayName=Location" `
    --param "FormId=$warehouseitemFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem"

txc workspace component create pp-form-cell `
    --output "src/Solutions.UI" `
    --param "RowIndex=5" `
    --param "FormType=main" `
    --param "DisplayName=Description" `
    --param "FormId=$warehouseitemFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem"

txc workspace component create pp-form-cell `
    --output "src/Solutions.UI" `
    --param "RowIndex=6" `
    --param "FormType=main" `
    --param "DisplayName=Unit Price" `
    --param "FormId=$warehouseitemFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem"

txc workspace component create pp-form-cell `
    --output "src/Solutions.UI" `
    --param "RowIndex=7" `
    --param "FormType=main" `
    --param "DisplayName=Weight (kg)" `
    --param "FormId=$warehouseitemFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem"

txc workspace component create pp-form-cell `
    --output "src/Solutions.UI" `
    --param "RowIndex=8" `
    --param "FormType=main" `
    --param "DisplayName=Category" `
    --param "FormId=$warehouseitemFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem"

txc workspace component create pp-form-cell `
    --output "src/Solutions.UI" `
    --param "RowIndex=9" `
    --param "FormType=main" `
    --param "DisplayName=Is Perishable" `
    --param "FormId=$warehouseitemFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem"

txc workspace component create pp-form-cell `
    --output "src/Solutions.UI" `
    --param "RowIndex=10" `
    --param "FormType=main" `
    --param "DisplayName=Expiration Date" `
    --param "FormId=$warehouseitemFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem"

txc workspace component create pp-form-cell `
    --output "src/Solutions.UI" `
    --param "RowIndex=11" `
    --param "FormType=main" `
    --param "DisplayName=Barcode" `
    --param "FormId=$warehouseitemFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem"

txc workspace component create pp-form-cell `
    --output "src/Solutions.UI" `
    --param "RowIndex=12" `
    --param "FormType=main" `
    --param "DisplayName=Reorder Point" `
    --param "FormId=$warehouseitemFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem"

Write-Host "  ✓ warehouseitem cells: Name, SKU, Available Quantity, Location, Description, Unit Price, Weight, Category, Is Perishable, Expiration Date, Barcode, Reorder Point" -ForegroundColor Green

# --- Warehouse Transaction cells ---

txc workspace component create pp-form-cell `
    --output "src/Solutions.UI" `
    --param "RowIndex=1" `
    --param "FormType=main" `
    --param "DisplayName=Name" `
    --param "FormId=$warehousetransactionFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction"

txc workspace component create pp-form-cell `
    --output "src/Solutions.UI" `
    --param "RowIndex=2" `
    --param "FormType=main" `
    --param "DisplayName=Item" `
    --param "FormId=$warehousetransactionFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction"

txc workspace component create pp-form-cell `
    --output "src/Solutions.UI" `
    --param "RowIndex=3" `
    --param "FormType=main" `
    --param "DisplayName=Quantity" `
    --param "FormId=$warehousetransactionFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction"

txc workspace component create pp-form-cell `
    --output "src/Solutions.UI" `
    --param "RowIndex=4" `
    --param "FormType=main" `
    --param "DisplayName=Transaction Type" `
    --param "FormId=$warehousetransactionFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction"

txc workspace component create pp-form-cell `
    --output "src/Solutions.UI" `
    --param "RowIndex=5" `
    --param "FormType=main" `
    --param "DisplayName=Transaction Date" `
    --param "FormId=$warehousetransactionFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction"

txc workspace component create pp-form-cell `
    --output "src/Solutions.UI" `
    --param "RowIndex=6" `
    --param "FormType=main" `
    --param "DisplayName=Notes" `
    --param "FormId=$warehousetransactionFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction"

txc workspace component create pp-form-cell `
    --output "src/Solutions.UI" `
    --param "RowIndex=7" `
    --param "FormType=main" `
    --param "DisplayName=Total Value" `
    --param "FormId=$warehousetransactionFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction"

txc workspace component create pp-form-cell `
    --output "src/Solutions.UI" `
    --param "RowIndex=8" `
    --param "FormType=main" `
    --param "DisplayName=Is Processed" `
    --param "FormId=$warehousetransactionFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction"

txc workspace component create pp-form-cell `
    --output "src/Solutions.UI" `
    --param "RowIndex=9" `
    --param "FormType=main" `
    --param "DisplayName=Processed By" `
    --param "FormId=$warehousetransactionFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction"

txc workspace component create pp-form-cell `
    --output "src/Solutions.UI" `
    --param "RowIndex=10" `
    --param "FormType=main" `
    --param "DisplayName=Reference Number" `
    --param "FormId=$warehousetransactionFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction"

Write-Host "  ✓ warehousetransaction cells: Name, Item, Quantity, Transaction Type, Transaction Date, Notes, Total Value, Is Processed, Processed By, Reference Number" -ForegroundColor Green

# ──────────────────────────────────────────────────────────────────────────────────────────
#                                  Form Controls
# ──────────────────────────────────────────────────────────────────────────────────────────

Write-Host "`n── Form Controls ──" -ForegroundColor Cyan

# --- Warehouse Location controls ---

txc workspace component create pp-form-control `
    --output "src/Solutions.UI" `
    --param "ControlType=Text" `
    --param "RowIndex=1" `
    --param "AttributeLogicalName=${PublisherPrefix}_name" `
    --param "FormType=main" `
    --param "FormId=$warehouselocationFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouselocation"

txc workspace component create pp-form-control `
    --output "src/Solutions.UI" `
    --param "ControlType=WholeNumber" `
    --param "RowIndex=2" `
    --param "AttributeLogicalName=${PublisherPrefix}_capacity" `
    --param "FormType=main" `
    --param "FormId=$warehouselocationFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouselocation"

txc workspace component create pp-form-control `
    --output "src/Solutions.UI" `
    --param "ControlType=Text" `
    --param "RowIndex=3" `
    --param "AttributeLogicalName=${PublisherPrefix}_address" `
    --param "FormType=main" `
    --param "FormId=$warehouselocationFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouselocation"

txc workspace component create pp-form-control `
    --output "src/Solutions.UI" `
    --param "ControlType=OptionSet" `
    --param "RowIndex=4" `
    --param "AttributeLogicalName=${PublisherPrefix}_isactive" `
    --param "FormType=main" `
    --param "FormId=$warehouselocationFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouselocation"

txc workspace component create pp-form-control `
    --output "src/Solutions.UI" `
    --param "ControlType=MultilineText" `
    --param "RowIndex=5" `
    --param "AttributeLogicalName=${PublisherPrefix}_notes" `
    --param "FormType=main" `
    --param "FormId=$warehouselocationFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouselocation"

Write-Host "  ✓ warehouselocation controls: name, capacity, address, isactive, notes" -ForegroundColor Green

# --- Warehouse Item controls ---

txc workspace component create pp-form-control `
    --output "src/Solutions.UI" `
    --param "ControlType=Text" `
    --param "RowIndex=1" `
    --param "AttributeLogicalName=${PublisherPrefix}_name" `
    --param "FormType=main" `
    --param "FormId=$warehouseitemFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem"

txc workspace component create pp-form-control `
    --output "src/Solutions.UI" `
    --param "ControlType=Text" `
    --param "RowIndex=2" `
    --param "AttributeLogicalName=${PublisherPrefix}_sku" `
    --param "FormType=main" `
    --param "FormId=$warehouseitemFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem"

txc workspace component create pp-form-control `
    --output "src/Solutions.UI" `
    --param "ControlType=WholeNumber" `
    --param "RowIndex=3" `
    --param "AttributeLogicalName=${PublisherPrefix}_availablequantity" `
    --param "FormType=main" `
    --param "FormId=$warehouseitemFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem"

txc workspace component create pp-form-control `
    --output "src/Solutions.UI" `
    --param "ControlType=Lookup" `
    --param "RowIndex=4" `
    --param "AttributeLogicalName=${PublisherPrefix}_locationid" `
    --param "FormType=main" `
    --param "FormId=$warehouseitemFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem"

txc workspace component create pp-form-control `
    --output "src/Solutions.UI" `
    --param "ControlType=MultilineText" `
    --param "RowIndex=5" `
    --param "AttributeLogicalName=${PublisherPrefix}_description" `
    --param "FormType=main" `
    --param "FormId=$warehouseitemFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem"

txc workspace component create pp-form-control `
    --output "src/Solutions.UI" `
    --param "ControlType=Currency" `
    --param "RowIndex=6" `
    --param "AttributeLogicalName=${PublisherPrefix}_unitprice" `
    --param "FormType=main" `
    --param "FormId=$warehouseitemFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem"

txc workspace component create pp-form-control `
    --output "src/Solutions.UI" `
    --param "ControlType=Decimal" `
    --param "RowIndex=7" `
    --param "AttributeLogicalName=${PublisherPrefix}_weight" `
    --param "FormType=main" `
    --param "FormId=$warehouseitemFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem"

txc workspace component create pp-form-control `
    --output "src/Solutions.UI" `
    --param "ControlType=OptionSet" `
    --param "RowIndex=8" `
    --param "AttributeLogicalName=${PublisherPrefix}_category" `
    --param "FormType=main" `
    --param "FormId=$warehouseitemFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem"

txc workspace component create pp-form-control `
    --output "src/Solutions.UI" `
    --param "ControlType=OptionSet" `
    --param "RowIndex=9" `
    --param "AttributeLogicalName=${PublisherPrefix}_isperishable" `
    --param "FormType=main" `
    --param "FormId=$warehouseitemFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem"

txc workspace component create pp-form-control `
    --output "src/Solutions.UI" `
    --param "ControlType=DateTime" `
    --param "RowIndex=10" `
    --param "AttributeLogicalName=${PublisherPrefix}_expirationdate" `
    --param "FormType=main" `
    --param "FormId=$warehouseitemFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem"

txc workspace component create pp-form-control `
    --output "src/Solutions.UI" `
    --param "ControlType=Text" `
    --param "RowIndex=11" `
    --param "AttributeLogicalName=${PublisherPrefix}_barcode" `
    --param "FormType=main" `
    --param "FormId=$warehouseitemFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem"

txc workspace component create pp-form-control `
    --output "src/Solutions.UI" `
    --param "ControlType=WholeNumber" `
    --param "RowIndex=12" `
    --param "AttributeLogicalName=${PublisherPrefix}_reorderpoint" `
    --param "FormType=main" `
    --param "FormId=$warehouseitemFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem"

Write-Host "  ✓ warehouseitem controls: name, sku, availablequantity, locationid, description, unitprice, weight, category, isperishable, expirationdate, barcode, reorderpoint" -ForegroundColor Green

# --- Warehouse Transaction controls ---

txc workspace component create pp-form-control `
    --output "src/Solutions.UI" `
    --param "ControlType=Text" `
    --param "RowIndex=1" `
    --param "AttributeLogicalName=${PublisherPrefix}_name" `
    --param "FormType=main" `
    --param "FormId=$warehousetransactionFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction"

txc workspace component create pp-form-control `
    --output "src/Solutions.UI" `
    --param "ControlType=Lookup" `
    --param "RowIndex=2" `
    --param "AttributeLogicalName=${PublisherPrefix}_itemid" `
    --param "FormType=main" `
    --param "FormId=$warehousetransactionFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction"

txc workspace component create pp-form-control `
    --output "src/Solutions.UI" `
    --param "ControlType=WholeNumber" `
    --param "RowIndex=3" `
    --param "AttributeLogicalName=${PublisherPrefix}_quantity" `
    --param "FormType=main" `
    --param "FormId=$warehousetransactionFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction"

txc workspace component create pp-form-control `
    --output "src/Solutions.UI" `
    --param "ControlType=OptionSet" `
    --param "RowIndex=4" `
    --param "AttributeLogicalName=${PublisherPrefix}_transactiontype" `
    --param "FormType=main" `
    --param "FormId=$warehousetransactionFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction"

txc workspace component create pp-form-control `
    --output "src/Solutions.UI" `
    --param "ControlType=DateTime" `
    --param "RowIndex=5" `
    --param "AttributeLogicalName=${PublisherPrefix}_transactiondate" `
    --param "FormType=main" `
    --param "FormId=$warehousetransactionFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction"

txc workspace component create pp-form-control `
    --output "src/Solutions.UI" `
    --param "ControlType=MultilineText" `
    --param "RowIndex=6" `
    --param "AttributeLogicalName=${PublisherPrefix}_notes" `
    --param "FormType=main" `
    --param "FormId=$warehousetransactionFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction"

txc workspace component create pp-form-control `
    --output "src/Solutions.UI" `
    --param "ControlType=Currency" `
    --param "RowIndex=7" `
    --param "AttributeLogicalName=${PublisherPrefix}_totalvalue" `
    --param "FormType=main" `
    --param "FormId=$warehousetransactionFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction"

txc workspace component create pp-form-control `
    --output "src/Solutions.UI" `
    --param "ControlType=OptionSet" `
    --param "RowIndex=8" `
    --param "AttributeLogicalName=${PublisherPrefix}_isprocessed" `
    --param "FormType=main" `
    --param "FormId=$warehousetransactionFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction"

txc workspace component create pp-form-control `
    --output "src/Solutions.UI" `
    --param "ControlType=Text" `
    --param "RowIndex=9" `
    --param "AttributeLogicalName=${PublisherPrefix}_processedby" `
    --param "FormType=main" `
    --param "FormId=$warehousetransactionFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction"

txc workspace component create pp-form-control `
    --output "src/Solutions.UI" `
    --param "ControlType=Text" `
    --param "RowIndex=10" `
    --param "AttributeLogicalName=${PublisherPrefix}_referencenumber" `
    --param "FormType=main" `
    --param "FormId=$warehousetransactionFormGuid" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction"

Write-Host "  ✓ warehousetransaction controls: name, itemid, quantity, transactiontype, transactiondate, notes, totalvalue, isprocessed, processedby, referencenumber" -ForegroundColor Green
