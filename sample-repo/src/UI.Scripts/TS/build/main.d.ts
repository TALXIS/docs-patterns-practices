/// <reference types="xrm" />
declare namespace MyRibbon {
    class Dialogs {
        /**
         * Open dialog by unique name using modern API and optionally refresh grid control.
         */
        static OpenDialog(dialogUniqueName: string, selectedControl?: Xrm.Controls.GridControl): Promise<void>;
    }
    const openLegacyDialog: typeof Dialogs.OpenDialog;
}
declare namespace UdppDialog {
    class Actions {
        /**
         * Save dialog data into udpp_warehousetransaction and close the window.
         * Can be invoked from a Ribbon button or OnClick.
         */
        static saveAndClose(executionContext?: Xrm.Events.EventContext): Promise<void>;
    }
    const saveAndClose: typeof Actions.saveAndClose;
}
