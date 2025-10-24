var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
// type CFI15 and then press control+space to trigger suggestions of snippets
// ╔════════════════════════════════════════════════════════════════════════════════════════╗
// ║              CFG09: Open Warehouse Transaction Dialog from Ribbon Button              ║
// ╚════════════════════════════════════════════════════════════════════════════════════════╝
//
// This TypeScript function opens the warehouse transaction dialog form when called
// from a ribbon button. It uses the Xrm.Navigation API to open the dialog form.
//
// The dialog form was created in CFI04-ui-forms with FormType "dialog"
//
// ──────────────────────────────────────────────────────────────────────────────────────────
//                                        Function
// ──────────────────────────────────────────────────────────────────────────────────────────
var MyRibbon;
(function (MyRibbon) {
    class Dialogs {
        /**
         * Open dialog by unique name using modern API and optionally refresh grid control.
         */
        static OpenDialog(dialogUniqueName, selectedControl) {
            return __awaiter(this, void 0, void 0, function* () {
                // @ts-ignore - openDialog is available in supported clients
                yield Xrm.Navigation.openDialog(dialogUniqueName, {
                    position: 1,
                    height: 900,
                    width: 900
                }, null);
                selectedControl === null || selectedControl === void 0 ? void 0 : selectedControl.refresh();
            });
        }
    }
    MyRibbon.Dialogs = Dialogs;
    MyRibbon.openLegacyDialog = Dialogs.OpenDialog;
})(MyRibbon || (MyRibbon = {}));
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
var UdppDialog;
(function (UdppDialog) {
    class Actions {
        /**
         * Save dialog data into udpp_warehousetransaction and close the window.
         * Can be invoked from a Ribbon button or OnClick.
         */
        static saveAndClose(executionContext) {
            var _a, _b, _c, _d, _e, _f, _g, _h, _j, _k, _l;
            return __awaiter(this, void 0, void 0, function* () {
                try {
                    const form = (_b = (_a = executionContext === null || executionContext === void 0 ? void 0 : executionContext.getFormContext) === null || _a === void 0 ? void 0 : _a.call(executionContext)) !== null && _b !== void 0 ? _b : Xrm.Page;
                    // 1) Read dialog field values (logical names from FormXml)
                    const name = (_d = (_c = form.getAttribute("udpp_name")) === null || _c === void 0 ? void 0 : _c.getValue()) !== null && _d !== void 0 ? _d : "";
                    const quantity = (_f = (_e = form.getAttribute("udpp_quantity")) === null || _e === void 0 ? void 0 : _e.getValue()) !== null && _f !== void 0 ? _f : null;
                    const paymentMethod = (_h = (_g = form.getAttribute("udpp_paymentmethod")) === null || _g === void 0 ? void 0 : _g.getValue()) !== null && _h !== void 0 ? _h : null;
                    // lookup
                    const itemAttr = form.getAttribute("udpp_itemid");
                    // Minimal validation
                    if (!name) {
                        yield Xrm.Navigation.openAlertDialog({ text: "Enter Name." });
                        return;
                    }
                    if (quantity == null) {
                        yield Xrm.Navigation.openAlertDialog({ text: "Enter Quantity." });
                        return;
                    }
                    // 2) Prepare payload for createRecord
                    const payload = {
                        udpp_name: name,
                        udpp_quantity: quantity,
                        udpp_paymentmethod: paymentMethod // optionset (can be null if optional)
                    };
                    // 3) Bind lookup udpp_itemid (generic, without hardcoding EntitySet)
                    const itemVal = itemAttr === null || itemAttr === void 0 ? void 0 : itemAttr.getValue();
                    if (itemVal && itemVal.length) {
                        const id = itemVal[0].id.replace(/[{}]/g, "");
                        const logicalName = itemVal[0].entityType; // e.g. "udpp_item"
                        const meta = yield Xrm.Utility.getEntityMetadata(logicalName, ["EntitySetName"]);
                        payload["udpp_itemid@odata.bind"] = `/${meta.EntitySetName}(${id})`;
                    }
                    // 4) Create udpp_warehousetransaction record
                    const createRes = yield Xrm.WebApi.createRecord("udpp_warehousetransaction", payload);
                    if (((_j = form === null || form === void 0 ? void 0 : form.ui) === null || _j === void 0 ? void 0 : _j.close) && typeof form.ui.close === "function") {
                        form.ui.close();
                    }
                    else if (((_k = Xrm === null || Xrm === void 0 ? void 0 : Xrm.Navigation) === null || _k === void 0 ? void 0 : _k.close) && typeof Xrm.Navigation.close === "function") {
                        Xrm.Navigation.close();
                    }
                    else {
                        window.close();
                    }
                }
                catch (e) {
                    yield Xrm.Navigation.openErrorDialog({
                        message: (_l = e === null || e === void 0 ? void 0 : e.message) !== null && _l !== void 0 ? _l : String(e)
                    });
                }
            });
        }
    }
    UdppDialog.Actions = Actions;
    // Backward compatibility: keep old exported function symbol
    UdppDialog.saveAndClose = Actions.saveAndClose;
})(UdppDialog || (UdppDialog = {}));
//# sourceMappingURL=udpp_main.js.map