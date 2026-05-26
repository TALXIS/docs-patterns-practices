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

            if (!(context.InputParameters["Target"] is Entity target) || target.LogicalName != "dmpp_warehousetransaction")
                return;

            if (!target.Contains("dmpp_quantity") || !target.Contains("dmpp_itemid") || !target.Contains("dmpp_transactiontype"))
                return;

            var quantity = (int)target["dmpp_quantity"];
            var itemRef = (EntityReference)target["dmpp_itemid"];
            var transactionType = (OptionSetValue)target["dmpp_transactiontype"];

            var item = service.Retrieve("dmpp_warehouseitem", itemRef.Id, new ColumnSet("dmpp_availablequantity"));
            var available = item.Contains("dmpp_availablequantity") ? (int)item["dmpp_availablequantity"] : 0;

            // Inbound (1) = add stock, Outbound (2) = subtract stock
            if (transactionType.Value == 1)
                item["dmpp_availablequantity"] = available + quantity;
            else if (transactionType.Value == 2)
                item["dmpp_availablequantity"] = available - quantity;
            else
                return;

            service.Update(item);
        }
    }
}
