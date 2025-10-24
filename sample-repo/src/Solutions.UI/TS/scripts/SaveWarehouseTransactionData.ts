// type CFI16 and then press control+space to trigger suggestions of snippets
// ╔════════════════════════════════════════════════════════════════════════════════════════╗
// ║                CFG10: Save Warehouse Transaction Data from Form Button                ║
// ╚════════════════════════════════════════════════════════════════════════════════════════╝
//
// This TypeScript function saves the warehouse transaction data when called from a form button.
// It validates the form data, creates a new warehouse transaction record, and handles errors.
//
// This function should be called from a button in the warehouse transaction dialog form
// created in CFI04-ui-forms
//
// ──────────────────────────────────────────────────────────────────────────────────────────
//                                        Function
// ──────────────────────────────────────────────────────────────────────────────────────────
namespace UdppDialog {
    export class Actions {
        /**
         * Save dialog data into udpp_warehousetransaction and close the window.
         * Can be invoked from a Ribbon button or OnClick.
         */
        public static async saveAndClose(executionContext?: Xrm.Events.EventContext): Promise<void> {
            try {
                const form = executionContext?.getFormContext?.() ?? (Xrm as any).Page;

                // 1) Read dialog field values (logical names from FormXml)
                const name = (form.getAttribute("udpp_name") as Xrm.Attributes.StringAttribute)?.getValue() ?? "";
                const quantity = (form.getAttribute("udpp_quantity") as Xrm.Attributes.NumberAttribute)?.getValue() ?? null;
                const paymentMethod = (form.getAttribute("udpp_paymentmethod") as Xrm.Attributes.OptionSetAttribute)?.getValue() ?? null;

                // lookup
                const itemAttr = form.getAttribute("udpp_itemid") as Xrm.Attributes.LookupAttribute;

                // Minimal validation
                if (!name) {
                    await Xrm.Navigation.openAlertDialog({ text: "Enter Name." });
                    return;
                }
                if (quantity == null) {
                    await Xrm.Navigation.openAlertDialog({ text: "Enter Quantity." });
                    return;
                }

                // 2) Prepare payload for createRecord
                const payload: any = {
                    udpp_name: name,
                    udpp_quantity: quantity,
                    udpp_paymentmethod: paymentMethod // optionset (can be null if optional)
                };

                // 3) Bind lookup udpp_itemid (generic, without hardcoding EntitySet)
                const itemVal = itemAttr?.getValue() as Xrm.LookupValue[] | null;
                if (itemVal && itemVal.length) {
                    const id = itemVal[0].id.replace(/[{}]/g, "");
                    const logicalName = itemVal[0].entityType; // e.g. "udpp_item"
                    const meta = await Xrm.Utility.getEntityMetadata(logicalName, ["EntitySetName"]);
                    payload["udpp_itemid@odata.bind"] = `/${meta.EntitySetName}(${id})`;
                }

                // 4) Create udpp_warehousetransaction record
                const createRes = await Xrm.WebApi.createRecord("udpp_warehousetransaction", payload);

                if ((form as any)?.ui?.close && typeof (form as any).ui.close === "function") {
                    (form as any).ui.close();
                } else if ((Xrm as any)?.Navigation?.close && typeof (Xrm as any).Navigation.close === "function") {
                    (Xrm as any).Navigation.close();
                } else {
                    window.close();
                }
            } catch (e: any) {
                await Xrm.Navigation.openErrorDialog({
                    message: e?.message ?? String(e)
                });
            }
        }
    }

    // Backward compatibility: keep old exported function symbol
    export const saveAndClose = Actions.saveAndClose;
}