// type CFG03 and then press control+space to trigger suggestions of snippets
// ╔════════════════════════════════════════════════════════════════════════════════════════╗
// ║            CFG03: Plugin - Validate Warehouse Transaction Quantity (PreValidation)     ║
// ╚════════════════════════════════════════════════════════════════════════════════════════╝
//
// This plugin checks if the requested quantity exceeds available quantity
// for a Warehouse Item and throws an exception if validation fails.
//
// Triggered on: Create → udpp_warehousetransaction
// Stage: PreValidation
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Query;
using System;

namespace Plugins.Warehouse
{
    public class ValidateWarehouseTransactionPlugin : PluginBase
    {
        public ValidateWarehouseTransactionPlugin(string unsecureConfiguration, string secureConfiguration)
            : base(typeof(ValidateWarehouseTransactionPlugin))
        {
        }

        protected override void ExecuteDataversePlugin(ILocalPluginContext localPluginContext)
        {
            if (localPluginContext == null)
            {
                throw new ArgumentNullException(nameof(localPluginContext));
            }

            var context = localPluginContext.PluginExecutionContext;
            var serviceFactory = localPluginContext.OrgSvcFactory;
            var service = serviceFactory.CreateOrganizationService(context.UserId);
            var tracingService = localPluginContext.TracingService;

            if (!(context.InputParameters.Contains("Target") && context.InputParameters["Target"] is Entity target) || target.LogicalName != "udpp_warehousetransaction")
                return;

            if (!target.Contains("udpp_quantity") || !target.Contains("udpp_itemid"))
                return;

            try
            {
                var quantity = (int)target["udpp_quantity"];
                var itemRef = (EntityReference)target["udpp_itemid"];

                var item = service.Retrieve("udpp_warehouseitem", itemRef.Id, new ColumnSet("udpp_availablequantity"));
                var available = (int)item["udpp_availablequantity"];

                if (item == null || !item.Contains("udpp_availablequantity"))
                {
                    available = 0;
                }
                else
                {
                    available = (int)item["udpp_availablequantity"];
                }

                if (quantity > available)
                {
                    throw new InvalidPluginExecutionException($"Not enough product in stock. Available: {available}, requested: {quantity}.");
                }
            }
            catch (Exception ex)
            {
                tracingService.Trace("Plugin Exception: {0}", ex.ToString());
                throw;
            }
        }
    }
}