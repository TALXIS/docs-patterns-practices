namespace WarehouseScripts {
    export class RibbonActions {
        /**
         * Check Stock Levels — opens an alert showing the current stock for the selected item.
         * Called from a ribbon button on the Warehouse Item form.
         */
        public static async checkStockLevels(formContext: Xrm.FormContext): Promise<void> {
            const name = (formContext.getAttribute("dmpp_name") as Xrm.Attributes.StringAttribute)?.getValue() ?? "Unknown";
            const qty = (formContext.getAttribute("dmpp_availablequantity") as Xrm.Attributes.NumberAttribute)?.getValue() ?? 0;
            const reorder = (formContext.getAttribute("dmpp_reorderpoint") as Xrm.Attributes.NumberAttribute)?.getValue() ?? 0;

            let message = "Stock level for " + name + ": " + qty + " units.";
            if (qty <= reorder) {
                message += "\n⚠ Below reorder point (" + reorder + "). Consider restocking.";
            } else {
                message += "\n✓ Stock is above reorder point (" + reorder + ").";
            }

            await Xrm.Navigation.openAlertDialog({ text: message, title: "Stock Check" });
        }
    }
}
