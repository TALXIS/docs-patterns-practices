namespace WarehouseScripts {
    export class TransactionForm {
        /**
         * OnLoad handler for the Warehouse Transaction main form.
         * Sets default transaction date to today if empty.
         */
        public static onLoad(executionContext: Xrm.Events.EventContext): void {
            const formContext = executionContext.getFormContext();

            // Default transaction date to today
            const dateAttr = formContext.getAttribute("dmpp_transactiondate");
            if (dateAttr && !dateAttr.getValue()) {
                dateAttr.setValue(new Date());
            }
        }

        /**
         * OnChange handler for the quantity field.
         * Recalculates total value based on quantity × item unit price.
         */
        public static async onQuantityChange(executionContext: Xrm.Events.EventContext): Promise<void> {
            const formContext = executionContext.getFormContext();

            const quantity = (formContext.getAttribute("dmpp_quantity") as Xrm.Attributes.NumberAttribute)?.getValue();
            const itemAttr = formContext.getAttribute("dmpp_itemid") as Xrm.Attributes.LookupAttribute;
            const itemVal = itemAttr?.getValue() as Xrm.LookupValue[] | null;

            if (quantity && itemVal && itemVal.length) {
                try {
                    const item = await Xrm.WebApi.retrieveRecord(
                        "dmpp_warehouseitem",
                        itemVal[0].id.replace(/[{}]/g, ""),
                        "?\$select=dmpp_unitprice"
                    );
                    const unitPrice = item["dmpp_unitprice"] as number;
                    if (unitPrice) {
                        const totalValue = quantity * unitPrice;
                        (formContext.getAttribute("dmpp_totalvalue") as Xrm.Attributes.NumberAttribute)?.setValue(totalValue);
                    }
                } catch {
                    // Item not found or no price — leave total value unchanged
                }
            }
        }
    }
}
