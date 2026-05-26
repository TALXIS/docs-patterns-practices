#
# ╔════════════════════════════════════════════════════════════════════════════════════════╗
# ║             09: Form Scripts — Script Library, TypeScript, Event Handlers              ║
# ╚════════════════════════════════════════════════════════════════════════════════════════╝
#
# Creates a Script Library project (TypeScript → JS web resource) and registers
# form event handlers on the warehouse transaction form.
# Expects: $PublisherPrefix, $warehousetransactionFormGuid from parent scope.
#
# ──────────────────────────────────────────────────────────────────────────────────────────
#                              Script Library Project
# ──────────────────────────────────────────────────────────────────────────────────────────

Write-Host "`n── Scripts.UI ──" -ForegroundColor Cyan

dotnet new pp-script-library `
    --LibraryName "main" `
    --PublisherPrefix $PublisherPrefix `
    --output "src/Scripts.UI"

dotnet sln add src/Scripts.UI

Write-Host "  ✓ Scripts.UI project (TypeScript → JS)" -ForegroundColor Green

# ──────────────────────────────────────────────────────────────────────────────────────────
#                              TypeScript Source Files
# ──────────────────────────────────────────────────────────────────────────────────────────

$prefix = $PublisherPrefix

# Form handlers — written to src/index.ts which is the rollup entry point.
# The UMD global name in rollup.config.mjs must be "WarehouseScripts" so the
# form event handlers can resolve WarehouseScripts.TransactionForm.onLoad etc.
$indexScript = @"
export class TransactionForm {
    /**
     * OnLoad handler for the Warehouse Transaction main form.
     * Sets default transaction date to today if empty.
     */
    public static onLoad(executionContext: Xrm.Events.EventContext): void {
        const formContext = executionContext.getFormContext();

        // Default transaction date to today
        const dateAttr = formContext.getAttribute("${prefix}_transactiondate");
        if (dateAttr && !dateAttr.getValue()) {
            dateAttr.setValue(new Date());
        }
    }

    /**
     * OnChange handler for the quantity field.
     * Recalculates total value based on quantity x item unit price.
     */
    public static async onQuantityChange(executionContext: Xrm.Events.EventContext): Promise<void> {
        const formContext = executionContext.getFormContext();

        const quantity = (formContext.getAttribute("${prefix}_quantity") as Xrm.Attributes.NumberAttribute)?.getValue();
        const itemAttr = formContext.getAttribute("${prefix}_itemid") as Xrm.Attributes.LookupAttribute;
        const itemVal = itemAttr?.getValue() as Xrm.LookupValue[] | null;

        if (quantity && itemVal && itemVal.length) {
            try {
                const item = await Xrm.WebApi.retrieveRecord(
                    "${prefix}_warehouseitem",
                    itemVal[0].id.replace(/[{}]/g, ""),
                    "?\`$select=${prefix}_unitprice"
                );
                const unitPrice = item["${prefix}_unitprice"] as number;
                if (unitPrice) {
                    const totalValue = quantity * unitPrice;
                    (formContext.getAttribute("${prefix}_totalvalue") as Xrm.Attributes.NumberAttribute)?.setValue(totalValue);
                }
            } catch {
                // Item not found or no price — leave total value unchanged
            }
        }
    }
}

export class RibbonActions {
    /**
     * Check Stock Levels — opens an alert showing the current stock for the selected item.
     */
    public static async checkStockLevels(formContext: Xrm.FormContext): Promise<void> {
        const name = (formContext.getAttribute("${prefix}_name") as Xrm.Attributes.StringAttribute)?.getValue() ?? "Unknown";
        const qty = (formContext.getAttribute("${prefix}_availablequantity") as Xrm.Attributes.NumberAttribute)?.getValue() ?? 0;
        const reorder = (formContext.getAttribute("${prefix}_reorderpoint") as Xrm.Attributes.NumberAttribute)?.getValue() ?? 0;

        let message = "Stock level for " + name + ": " + qty + " units.";
        if (qty <= reorder) {
            message += "\n⚠ Below reorder point (" + reorder + "). Consider restocking.";
        } else {
            message += "\n✓ Stock is above reorder point (" + reorder + ").";
        }

        await Xrm.Navigation.openAlertDialog({ text: message, title: "Stock Check" });
    }
}
"@

Set-Content -Path "src/Scripts.UI/src/index.ts" -Value $indexScript -Encoding UTF8
Write-Host "  ✓ src/index.ts (TransactionForm + RibbonActions)" -ForegroundColor Green

# Update rollup UMD name to match the namespace expected by form event handlers
$rollupConfig = Get-Content "src/Scripts.UI/rollup.config.mjs" -Raw
$rollupConfig = $rollupConfig -replace "name: '${prefix}_main'", "name: 'WarehouseScripts'"
Set-Content -Path "src/Scripts.UI/rollup.config.mjs" -Value $rollupConfig -Encoding UTF8
Write-Host "  ✓ rollup.config.mjs (UMD name → WarehouseScripts)" -ForegroundColor Green

# ──────────────────────────────────────────────────────────────────────────────────────────
#                         Link Script Library to UI Solution
# ──────────────────────────────────────────────────────────────────────────────────────────

cd src/Solutions.UI
dotnet add reference ../Scripts.UI/Scripts.UI.csproj
cd ../..

Write-Host "  ✓ ProjectReference: Scripts.UI → Solutions.UI" -ForegroundColor Green

# ──────────────────────────────────────────────────────────────────────────────────────────
#                              Build Script Library
# ──────────────────────────────────────────────────────────────────────────────────────────

Write-Host "  → Building Scripts.UI..." -ForegroundColor White
cd src/Scripts.UI
dotnet build --nologo --verbosity quiet
if ($LASTEXITCODE -eq 0) {
    Write-Host "  ✓ Scripts build succeeded" -ForegroundColor Green
} else {
    Write-Host "  ⚠ Scripts build had issues (exit code: $LASTEXITCODE)" -ForegroundColor Yellow
}
cd ../..

# ──────────────────────────────────────────────────────────────────────────────────────────
#                              Form Event Handlers
# ──────────────────────────────────────────────────────────────────────────────────────────

Write-Host "`n── Form Event Handlers ──" -ForegroundColor Cyan

# OnLoad handler on warehouse transaction form
dotnet new pp-form-event-handler `
    --output "src/Solutions.UI" `
    --FormType "main" `
    --FormId $warehousetransactionFormGuid `
    --EntityLogicalName "${PublisherPrefix}_warehousetransaction" `
    --LibraryName "${PublisherPrefix}_main" `
    --FunctionName "WarehouseScripts.TransactionForm.onLoad" `
    --EventType "onload" `
    --allow-scripts yes

Write-Host "  ✓ Event handler: warehousetransaction form → onLoad" -ForegroundColor Green

# OnChange handler on quantity field
dotnet new pp-form-event-handler `
    --output "src/Solutions.UI" `
    --FormType "main" `
    --FormId $warehousetransactionFormGuid `
    --EntityLogicalName "${PublisherPrefix}_warehousetransaction" `
    --LibraryName "${PublisherPrefix}_main" `
    --FunctionName "WarehouseScripts.TransactionForm.onQuantityChange" `
    --EventType "onchange" `
    --AttributeName "${PublisherPrefix}_quantity" `
    --allow-scripts yes

Write-Host "  ✓ Event handler: warehousetransaction quantity → onChange" -ForegroundColor Green
