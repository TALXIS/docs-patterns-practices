// ---------------- Type Definitions which can be imported from ./RuntimeTypes -------------------------
export interface TableRegistrations extends BaseTableRegistrations {
    "dmpp_warehouseitem": dmpp_warehouseitem,
    "dmpp_warehouselocation": dmpp_warehouselocation,
}
export interface EnumRegistrations extends BaseEnumRegistrations {
    "dmpp_warehouseitem-dmpp_category": dmpp_warehouseitem_dmpp_category,
    "dmpp_warehouseitem-dmpp_isperishable": dmpp_warehouseitem_dmpp_isperishable,
    "dmpp_warehouseitem-statecode": dmpp_warehouseitem_statecode,
    "dmpp_warehouseitem-statuscode": dmpp_warehouseitem_statuscode,
    "dmpp_warehouselocation-dmpp_isactive": dmpp_warehouselocation_dmpp_isactive,
    "dmpp_warehouselocation-statecode": dmpp_warehouselocation_statecode,
    "dmpp_warehouselocation-statuscode": dmpp_warehouselocation_statuscode,
}
export type dmpp_warehouseitem = TableRow<{
    // Primary Key Column
    readonly dmpp_warehouseitemid: string,
    readonly createdbyname: string,
    readonly createdbyyominame: string,
    readonly createdonbehalfbyname: string,
    readonly createdonbehalfbyyominame: string,
    dmpp_availablequantity: number,
    dmpp_barcode: string,
    dmpp_category: dmpp_warehouseitem_dmpp_category,
    dmpp_description: string,
    dmpp_expirationdate: Date,
    dmpp_isperishable: dmpp_warehouseitem_dmpp_isperishable,
    // Foreign Key Column
    _dmpp_locationid_value: `/dmpp_warehouselocation(${string})`,
    readonly dmpp_locationidname: string,
    dmpp_name: string,
    dmpp_reorderpoint: number,
    dmpp_sku: string,
    dmpp_unitprice: number,
    readonly dmpp_unitprice_base: number,
    dmpp_weight: number,
    readonly exchangerate: number,
    readonly modifiedbyname: string,
    readonly modifiedbyyominame: string,
    readonly modifiedonbehalfbyname: string,
    readonly modifiedonbehalfbyyominame: string,
    readonly owningbusinessunitname: string,
    statecode: dmpp_warehouseitem_statecode,
    statuscode: dmpp_warehouseitem_statuscode,
    // Foreign Key Column
    readonly _transactioncurrencyid_value: `/transactioncurrency(${string})`,
    readonly transactioncurrencyidname: string,
}>

export type dmpp_warehouselocation = TableRow<{
    // Primary Key Column
    readonly dmpp_warehouselocationid: string,
    readonly createdbyname: string,
    readonly createdbyyominame: string,
    readonly createdonbehalfbyname: string,
    readonly createdonbehalfbyyominame: string,
    dmpp_address: string,
    dmpp_capacity: number,
    dmpp_isactive: dmpp_warehouselocation_dmpp_isactive,
    dmpp_name: string,
    dmpp_notes: string,
    readonly modifiedbyname: string,
    readonly modifiedbyyominame: string,
    readonly modifiedonbehalfbyname: string,
    readonly modifiedonbehalfbyyominame: string,
    readonly owningbusinessunitname: string,
    statecode: dmpp_warehouselocation_statecode,
    statuscode: dmpp_warehouselocation_statuscode,
}>

const enum dmpp_warehouseitem_dmpp_category {
"Electronics" = 100000000,
"Clothing" = 100000001,
"Food" = 100000002,
"Hardware" = 100000003,
"Other" = 100000004,
}
const enum dmpp_warehouseitem_dmpp_isperishable {
"No" = 0,
"Yes" = 1,
}
const enum dmpp_warehouseitem_statecode {
"Active" = 0,
"Inactive" = 1,
}
const enum dmpp_warehouseitem_statuscode {
"Active" = 1,
"Inactive" = 2,
}
const enum dmpp_warehouselocation_dmpp_isactive {
"Inactive" = 0,
"Active" = 1,
}
const enum dmpp_warehouselocation_statecode {
"Active" = 0,
"Inactive" = 1,
}
const enum dmpp_warehouselocation_statuscode {
"Active" = 1,
"Inactive" = 2,
}

export interface UxAgentDataApi extends BaseUxAgentDataApi<TableRegistrations, EnumRegistrations> {}

export interface GeneratedComponentProps {
    dataApi: UxAgentDataApi;
}

