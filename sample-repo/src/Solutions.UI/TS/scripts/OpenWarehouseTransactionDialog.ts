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

namespace MyRibbon {
    export class Dialogs {
        /**
         * Open dialog by unique name using modern API and optionally refresh grid control.
         */
        public static async OpenDialog(
            dialogUniqueName: string,
            selectedControl?: Xrm.Controls.GridControl
        ): Promise<void> {
            // @ts-ignore - openDialog is available in supported clients
            await Xrm.Navigation.openDialog(dialogUniqueName, {
                position: 1,
                height: 900,
                width: 900
            }, null);

            selectedControl?.refresh();
        }
    }

    export const openLegacyDialog = Dialogs.OpenDialog;
}