//
//  ╔══════════════════════════════════════════════════════════════════════════════════════╗
//  ║                                                                                      ║
//  ║                    CFK02: OptionSet value mappings for UI display                    ║
//  ║                                                                                      ║
//  ╚══════════════════════════════════════════════════════════════════════════════════════╝
//
// File: src/utils/optionSets.ts
//
// Maps Dataverse OptionSet numeric codes to human-readable labels.
// Used across the app wherever option set values need to be displayed.
//
// Exported constants:
//   packageTypeLabels   - enum map: 240490000 -> "Box", 240490001 -> "Bag", 240490002 -> "Envelope"
//   paymentMethodLabels - enum map: 784270000 -> "Visa", 784270001 -> "Mastercard", 784270002 -> "Cash"
//
//   packageTypeOptions   - array of {value, label} for <Select> components (package types)
//   paymentMethodOptions - array of {value, label} for <Select> components (payment methods)
//
// Source models:
//   Udpp_warehouseitemsudpp_packagetype        (from Udpp_warehouseitemsModel)
//   Udpp_warehousetransactionsudpp_paymentmethod (from Udpp_warehousetransactionsModel)
//

import {
  Udpp_warehouseitemsudpp_packagetype,
} from "@/generated/models/Udpp_warehouseitemsModel";
import {
  Udpp_warehousetransactionsudpp_paymentmethod,
} from "@/generated/models/Udpp_warehousetransactionsModel";

export const packageTypeLabels = Udpp_warehouseitemsudpp_packagetype;
export const paymentMethodLabels = Udpp_warehousetransactionsudpp_paymentmethod;

export const packageTypeOptions = Object.entries(packageTypeLabels).map(
  ([value, label]) => ({ value: Number(value), label })
);

export const paymentMethodOptions = Object.entries(paymentMethodLabels).map(
  ([value, label]) => ({ value: Number(value), label })
);