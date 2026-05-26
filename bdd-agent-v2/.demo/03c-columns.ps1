#
# ╔════════════════════════════════════════════════════════════════════════════════════════╗
# ║                            03c: Columns (Entity Attributes)                            ║
# ╚════════════════════════════════════════════════════════════════════════════════════════╝
#
# All entity attribute (column) definitions for warehouseitem, warehouselocation,
# and warehousetransaction.
# Expects: $PublisherPrefix from parent scope.
#
# ──────────────────────────────────────────────────────────────────────────────────────────

Write-Host "`n── Columns ──" -ForegroundColor Cyan

# --- warehouseitem columns ---

dotnet new pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --AttributeType "WholeNumber" `
    --RequiredLevel "required" `
    --PublisherPrefix $PublisherPrefix `
    --LogicalName "availablequantity" `
    --DisplayName "Available Quantity" `
    --allow-scripts yes

Write-Host "  ✓ warehouseitem.availablequantity (WholeNumber)" -ForegroundColor Green

dotnet new pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --AttributeType "Text" `
    --RequiredLevel "required" `
    --PublisherPrefix $PublisherPrefix `
    --LogicalName "sku" `
    --DisplayName "SKU" `
    --allow-scripts yes

Write-Host "  ✓ warehouseitem.sku (Text)" -ForegroundColor Green

dotnet new pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --AttributeType "Lookup" `
    --RequiredLevel "none" `
    --PublisherPrefix $PublisherPrefix `
    --LogicalName "locationid" `
    --DisplayName "Location" `
    --LookupTarget "${PublisherPrefix}_warehouselocation" `
    --allow-scripts yes

Write-Host "  ✓ warehouseitem.locationid (Lookup → warehouselocation)" -ForegroundColor Green

dotnet new pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --AttributeType "MultilineText" `
    --RequiredLevel "none" `
    --PublisherPrefix $PublisherPrefix `
    --LogicalName "description" `
    --DisplayName "Description" `
    --allow-scripts yes

Write-Host "  ✓ warehouseitem.description (MultilineText)" -ForegroundColor Green

dotnet new pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --AttributeType "Money" `
    --RequiredLevel "none" `
    --PublisherPrefix $PublisherPrefix `
    --LogicalName "unitprice" `
    --DisplayName "Unit Price" `
    --DecimalPrecision "2" `
    --allow-scripts yes

Write-Host "  ✓ warehouseitem.unitprice (Money)" -ForegroundColor Green

dotnet new pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --AttributeType "Decimal" `
    --RequiredLevel "none" `
    --PublisherPrefix $PublisherPrefix `
    --LogicalName "weight" `
    --DisplayName "Weight (kg)" `
    --DecimalPrecision "3" `
    --allow-scripts yes

Write-Host "  ✓ warehouseitem.weight (Decimal)" -ForegroundColor Green

dotnet new pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --AttributeType "OptionSet(Local)" `
    --RequiredLevel "none" `
    --PublisherPrefix $PublisherPrefix `
    --LogicalName "category" `
    --DisplayName "Category" `
    --OptionSetOptions "Electronics,Clothing,Food,Hardware,Other" `
    --allow-scripts yes

Write-Host "  ✓ warehouseitem.category (OptionSet Local)" -ForegroundColor Green

dotnet new pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --AttributeType "Boolean" `
    --RequiredLevel "none" `
    --PublisherPrefix $PublisherPrefix `
    --LogicalName "isperishable" `
    --DisplayName "Is Perishable" `
    --BooleanTrueLabel "Yes" `
    --BooleanFalseLabel "No" `
    --allow-scripts yes

Write-Host "  ✓ warehouseitem.isperishable (Boolean)" -ForegroundColor Green

dotnet new pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --AttributeType "DateTime" `
    --RequiredLevel "none" `
    --PublisherPrefix $PublisherPrefix `
    --LogicalName "expirationdate" `
    --DisplayName "Expiration Date" `
    --DateTimeFormat "date" `
    --allow-scripts yes

Write-Host "  ✓ warehouseitem.expirationdate (DateTime, date only)" -ForegroundColor Green

dotnet new pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --AttributeType "Text" `
    --RequiredLevel "none" `
    --PublisherPrefix $PublisherPrefix `
    --LogicalName "barcode" `
    --DisplayName "Barcode" `
    --allow-scripts yes

Write-Host "  ✓ warehouseitem.barcode (Text)" -ForegroundColor Green

dotnet new pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --EntitySchemaName "${PublisherPrefix}_warehouseitem" `
    --AttributeType "WholeNumber" `
    --RequiredLevel "none" `
    --PublisherPrefix $PublisherPrefix `
    --LogicalName "reorderpoint" `
    --DisplayName "Reorder Point" `
    --allow-scripts yes

Write-Host "  ✓ warehouseitem.reorderpoint (WholeNumber)" -ForegroundColor Green

# --- warehouselocation columns ---

dotnet new pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --EntitySchemaName "${PublisherPrefix}_warehouselocation" `
    --AttributeType "WholeNumber" `
    --RequiredLevel "none" `
    --PublisherPrefix $PublisherPrefix `
    --LogicalName "capacity" `
    --DisplayName "Capacity" `
    --allow-scripts yes

Write-Host "  ✓ warehouselocation.capacity (WholeNumber)" -ForegroundColor Green

dotnet new pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --EntitySchemaName "${PublisherPrefix}_warehouselocation" `
    --AttributeType "Text" `
    --RequiredLevel "none" `
    --PublisherPrefix $PublisherPrefix `
    --LogicalName "address" `
    --DisplayName "Address" `
    --allow-scripts yes

Write-Host "  ✓ warehouselocation.address (Text)" -ForegroundColor Green

dotnet new pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --EntitySchemaName "${PublisherPrefix}_warehouselocation" `
    --AttributeType "Boolean" `
    --RequiredLevel "none" `
    --PublisherPrefix $PublisherPrefix `
    --LogicalName "isactive" `
    --DisplayName "Is Active" `
    --BooleanTrueLabel "Active" `
    --BooleanFalseLabel "Inactive" `
    --allow-scripts yes

Write-Host "  ✓ warehouselocation.isactive (Boolean)" -ForegroundColor Green

dotnet new pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --EntitySchemaName "${PublisherPrefix}_warehouselocation" `
    --AttributeType "MultilineText" `
    --RequiredLevel "none" `
    --PublisherPrefix $PublisherPrefix `
    --LogicalName "notes" `
    --DisplayName "Notes" `
    --allow-scripts yes

Write-Host "  ✓ warehouselocation.notes (MultilineText)" -ForegroundColor Green

# --- warehousetransaction columns ---

dotnet new pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --AttributeType "Lookup" `
    --RequiredLevel "required" `
    --PublisherPrefix $PublisherPrefix `
    --LogicalName "itemid" `
    --DisplayName "Item" `
    --LookupTarget "${PublisherPrefix}_warehouseitem" `
    --allow-scripts yes

Write-Host "  ✓ warehousetransaction.itemid (Lookup → warehouseitem)" -ForegroundColor Green

dotnet new pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --AttributeType "WholeNumber" `
    --RequiredLevel "required" `
    --PublisherPrefix $PublisherPrefix `
    --LogicalName "quantity" `
    --DisplayName "Quantity" `
    --allow-scripts yes

Write-Host "  ✓ warehousetransaction.quantity (WholeNumber)" -ForegroundColor Green

dotnet new pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --AttributeType "OptionSet(Local)" `
    --RequiredLevel "required" `
    --PublisherPrefix $PublisherPrefix `
    --LogicalName "transactiontype" `
    --DisplayName "Transaction Type" `
    --OptionSetOptions "Inbound,Outbound" `
    --allow-scripts yes

Write-Host "  ✓ warehousetransaction.transactiontype (OptionSet Local)" -ForegroundColor Green

dotnet new pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --AttributeType "DateTime" `
    --RequiredLevel "required" `
    --PublisherPrefix $PublisherPrefix `
    --LogicalName "transactiondate" `
    --DisplayName "Transaction Date" `
    --allow-scripts yes

Write-Host "  ✓ warehousetransaction.transactiondate (DateTime)" -ForegroundColor Green

dotnet new pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --AttributeType "MultilineText" `
    --RequiredLevel "none" `
    --PublisherPrefix $PublisherPrefix `
    --LogicalName "notes" `
    --DisplayName "Notes" `
    --allow-scripts yes

Write-Host "  ✓ warehousetransaction.notes (MultilineText)" -ForegroundColor Green

dotnet new pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --AttributeType "Money" `
    --RequiredLevel "none" `
    --PublisherPrefix $PublisherPrefix `
    --LogicalName "totalvalue" `
    --DisplayName "Total Value" `
    --DecimalPrecision "2" `
    --allow-scripts yes

Write-Host "  ✓ warehousetransaction.totalvalue (Money)" -ForegroundColor Green

dotnet new pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --AttributeType "Boolean" `
    --RequiredLevel "none" `
    --PublisherPrefix $PublisherPrefix `
    --LogicalName "isprocessed" `
    --DisplayName "Is Processed" `
    --BooleanTrueLabel "Yes" `
    --BooleanFalseLabel "No" `
    --allow-scripts yes

Write-Host "  ✓ warehousetransaction.isprocessed (Boolean)" -ForegroundColor Green

dotnet new pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --AttributeType "Text" `
    --RequiredLevel "none" `
    --PublisherPrefix $PublisherPrefix `
    --LogicalName "processedby" `
    --DisplayName "Processed By" `
    --allow-scripts yes

Write-Host "  ✓ warehousetransaction.processedby (Text)" -ForegroundColor Green

dotnet new pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --EntitySchemaName "${PublisherPrefix}_warehousetransaction" `
    --AttributeType "Text" `
    --RequiredLevel "none" `
    --PublisherPrefix $PublisherPrefix `
    --LogicalName "referencenumber" `
    --DisplayName "Reference Number" `
    --allow-scripts yes

Write-Host "  ✓ warehousetransaction.referencenumber (Text)" -ForegroundColor Green
