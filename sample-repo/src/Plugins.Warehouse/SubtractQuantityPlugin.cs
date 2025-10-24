// type CFG04 and then press control+space to trigger suggestions of snippets
// ╔════════════════════════════════════════════════════════════════════════════════════════╗
// ║         CFG04: Plugin - Subtract Quantity From Available (PostOperation)               ║
// ╚════════════════════════════════════════════════════════════════════════════════════════╝
//
// This plugin subtracts the requested quantity from the available quantity of
// a Warehouse Item after a transaction is created.
//
// Triggered on: Create → udpp_warehousetransaction
// Stage: PostOperation
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Query;
using System;

namespace Plugins.Warehouse
{
    public class SubtractQuantityPlugin : PluginBase
    {
        public SubtractQuantityPlugin(string unsecureConfiguration, string secureConfiguration)
            : base(typeof(SubtractQuantityPlugin))
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

            if (!(context.InputParameters["Target"] is Entity target) || target.LogicalName != "udpp_warehousetransaction")
                return;

            if (!target.Contains("udpp_quantity") || !target.Contains("udpp_itemid"))
                return;

            var quantity = ((int)target["udpp_quantity"]);
            var itemRef = (EntityReference)target["udpp_itemid"];

            var item = service.Retrieve("udpp_warehouseitem", itemRef.Id, new ColumnSet("udpp_availablequantity"));
            var available = ((int)item["udpp_availablequantity"]);

            item["udpp_availablequantity"] = available - quantity;
            service.Update(item);
        }
    }
}