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

txc workspace component create pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem" `
    --param "AttributeType=WholeNumber" `
    --param "RequiredLevel=required" `
    --param "PublisherPrefix=$PublisherPrefix" `
    --param "LogicalName=availablequantity" `
    --param "DisplayName=Available Quantity"

Write-Host "  ✓ warehouseitem.availablequantity (WholeNumber)" -ForegroundColor Green

txc workspace component create pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem" `
    --param "AttributeType=Text" `
    --param "RequiredLevel=required" `
    --param "PublisherPrefix=$PublisherPrefix" `
    --param "LogicalName=sku" `
    --param "DisplayName=SKU"

Write-Host "  ✓ warehouseitem.sku (Text)" -ForegroundColor Green

txc workspace component create pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem" `
    --param "AttributeType=Lookup" `
    --param "RequiredLevel=none" `
    --param "PublisherPrefix=$PublisherPrefix" `
    --param "LogicalName=locationid" `
    --param "DisplayName=Location" `
    --param "LookupTarget=${PublisherPrefix}_warehouselocation"

Write-Host "  ✓ warehouseitem.locationid (Lookup → warehouselocation)" -ForegroundColor Green

txc workspace component create pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem" `
    --param "AttributeType=MultilineText" `
    --param "RequiredLevel=none" `
    --param "PublisherPrefix=$PublisherPrefix" `
    --param "LogicalName=description" `
    --param "DisplayName=Description"

Write-Host "  ✓ warehouseitem.description (MultilineText)" -ForegroundColor Green

txc workspace component create pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem" `
    --param "AttributeType=Money" `
    --param "RequiredLevel=none" `
    --param "PublisherPrefix=$PublisherPrefix" `
    --param "LogicalName=unitprice" `
    --param "DisplayName=Unit Price" `
    --param "DecimalPrecision=2"

Write-Host "  ✓ warehouseitem.unitprice (Money)" -ForegroundColor Green

txc workspace component create pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem" `
    --param "AttributeType=Decimal" `
    --param "RequiredLevel=none" `
    --param "PublisherPrefix=$PublisherPrefix" `
    --param "LogicalName=weight" `
    --param "DisplayName=Weight (kg)" `
    --param "DecimalPrecision=3"

Write-Host "  ✓ warehouseitem.weight (Decimal)" -ForegroundColor Green

txc workspace component create pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem" `
    --param "AttributeType=OptionSet(Local)" `
    --param "RequiredLevel=none" `
    --param "PublisherPrefix=$PublisherPrefix" `
    --param "LogicalName=category" `
    --param "DisplayName=Category" `
    --param "OptionSetOptions=Electronics,Clothing,Food,Hardware,Other"

Write-Host "  ✓ warehouseitem.category (OptionSet Local)" -ForegroundColor Green

txc workspace component create pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem" `
    --param "AttributeType=Boolean" `
    --param "RequiredLevel=none" `
    --param "PublisherPrefix=$PublisherPrefix" `
    --param "LogicalName=isperishable" `
    --param "DisplayName=Is Perishable" `
    --param "BooleanTrueLabel=Yes" `
    --param "BooleanFalseLabel=No"

Write-Host "  ✓ warehouseitem.isperishable (Boolean)" -ForegroundColor Green

txc workspace component create pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem" `
    --param "AttributeType=DateTime" `
    --param "RequiredLevel=none" `
    --param "PublisherPrefix=$PublisherPrefix" `
    --param "LogicalName=expirationdate" `
    --param "DisplayName=Expiration Date" `
    --param "DateTimeFormat=date"

Write-Host "  ✓ warehouseitem.expirationdate (DateTime, date only)" -ForegroundColor Green

txc workspace component create pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem" `
    --param "AttributeType=Text" `
    --param "RequiredLevel=none" `
    --param "PublisherPrefix=$PublisherPrefix" `
    --param "LogicalName=barcode" `
    --param "DisplayName=Barcode"

Write-Host "  ✓ warehouseitem.barcode (Text)" -ForegroundColor Green

txc workspace component create pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouseitem" `
    --param "AttributeType=WholeNumber" `
    --param "RequiredLevel=none" `
    --param "PublisherPrefix=$PublisherPrefix" `
    --param "LogicalName=reorderpoint" `
    --param "DisplayName=Reorder Point"

Write-Host "  ✓ warehouseitem.reorderpoint (WholeNumber)" -ForegroundColor Green

# --- warehouselocation columns ---

txc workspace component create pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouselocation" `
    --param "AttributeType=WholeNumber" `
    --param "RequiredLevel=none" `
    --param "PublisherPrefix=$PublisherPrefix" `
    --param "LogicalName=capacity" `
    --param "DisplayName=Capacity"

Write-Host "  ✓ warehouselocation.capacity (WholeNumber)" -ForegroundColor Green

txc workspace component create pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouselocation" `
    --param "AttributeType=Text" `
    --param "RequiredLevel=none" `
    --param "PublisherPrefix=$PublisherPrefix" `
    --param "LogicalName=address" `
    --param "DisplayName=Address"

Write-Host "  ✓ warehouselocation.address (Text)" -ForegroundColor Green

txc workspace component create pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouselocation" `
    --param "AttributeType=Boolean" `
    --param "RequiredLevel=none" `
    --param "PublisherPrefix=$PublisherPrefix" `
    --param "LogicalName=isactive" `
    --param "DisplayName=Is Active" `
    --param "BooleanTrueLabel=Active" `
    --param "BooleanFalseLabel=Inactive"

Write-Host "  ✓ warehouselocation.isactive (Boolean)" -ForegroundColor Green

txc workspace component create pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --param "EntitySchemaName=${PublisherPrefix}_warehouselocation" `
    --param "AttributeType=MultilineText" `
    --param "RequiredLevel=none" `
    --param "PublisherPrefix=$PublisherPrefix" `
    --param "LogicalName=notes" `
    --param "DisplayName=Notes"

Write-Host "  ✓ warehouselocation.notes (MultilineText)" -ForegroundColor Green

# --- warehousetransaction columns ---

txc workspace component create pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction" `
    --param "AttributeType=Lookup" `
    --param "RequiredLevel=required" `
    --param "PublisherPrefix=$PublisherPrefix" `
    --param "LogicalName=itemid" `
    --param "DisplayName=Item" `
    --param "LookupTarget=${PublisherPrefix}_warehouseitem"

Write-Host "  ✓ warehousetransaction.itemid (Lookup → warehouseitem)" -ForegroundColor Green

txc workspace component create pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction" `
    --param "AttributeType=WholeNumber" `
    --param "RequiredLevel=required" `
    --param "PublisherPrefix=$PublisherPrefix" `
    --param "LogicalName=quantity" `
    --param "DisplayName=Quantity"

Write-Host "  ✓ warehousetransaction.quantity (WholeNumber)" -ForegroundColor Green

txc workspace component create pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction" `
    --param "AttributeType=OptionSet(Local)" `
    --param "RequiredLevel=required" `
    --param "PublisherPrefix=$PublisherPrefix" `
    --param "LogicalName=transactiontype" `
    --param "DisplayName=Transaction Type" `
    --param "OptionSetOptions=Inbound,Outbound"

Write-Host "  ✓ warehousetransaction.transactiontype (OptionSet Local)" -ForegroundColor Green

txc workspace component create pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction" `
    --param "AttributeType=DateTime" `
    --param "RequiredLevel=required" `
    --param "PublisherPrefix=$PublisherPrefix" `
    --param "LogicalName=transactiondate" `
    --param "DisplayName=Transaction Date"

Write-Host "  ✓ warehousetransaction.transactiondate (DateTime)" -ForegroundColor Green

txc workspace component create pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction" `
    --param "AttributeType=MultilineText" `
    --param "RequiredLevel=none" `
    --param "PublisherPrefix=$PublisherPrefix" `
    --param "LogicalName=notes" `
    --param "DisplayName=Notes"

Write-Host "  ✓ warehousetransaction.notes (MultilineText)" -ForegroundColor Green

txc workspace component create pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction" `
    --param "AttributeType=Money" `
    --param "RequiredLevel=none" `
    --param "PublisherPrefix=$PublisherPrefix" `
    --param "LogicalName=totalvalue" `
    --param "DisplayName=Total Value" `
    --param "DecimalPrecision=2"

Write-Host "  ✓ warehousetransaction.totalvalue (Money)" -ForegroundColor Green

txc workspace component create pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction" `
    --param "AttributeType=Boolean" `
    --param "RequiredLevel=none" `
    --param "PublisherPrefix=$PublisherPrefix" `
    --param "LogicalName=isprocessed" `
    --param "DisplayName=Is Processed" `
    --param "BooleanTrueLabel=Yes" `
    --param "BooleanFalseLabel=No"

Write-Host "  ✓ warehousetransaction.isprocessed (Boolean)" -ForegroundColor Green

txc workspace component create pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction" `
    --param "AttributeType=Text" `
    --param "RequiredLevel=none" `
    --param "PublisherPrefix=$PublisherPrefix" `
    --param "LogicalName=processedby" `
    --param "DisplayName=Processed By"

Write-Host "  ✓ warehousetransaction.processedby (Text)" -ForegroundColor Green

txc workspace component create pp-entity-attribute `
    --output "src/Solutions.DataModel" `
    --param "EntitySchemaName=${PublisherPrefix}_warehousetransaction" `
    --param "AttributeType=Text" `
    --param "RequiredLevel=none" `
    --param "PublisherPrefix=$PublisherPrefix" `
    --param "LogicalName=referencenumber" `
    --param "DisplayName=Reference Number"

Write-Host "  ✓ warehousetransaction.referencenumber (Text)" -ForegroundColor Green
