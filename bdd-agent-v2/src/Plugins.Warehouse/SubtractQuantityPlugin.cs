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

            if (!target.Contains("dmpp_quantity") || !target.Contains("dmpp_itemid"))
                return;

            var quantity = (int)target["dmpp_quantity"];
            var itemRef = (EntityReference)target["dmpp_itemid"];

            var item = service.Retrieve("dmpp_warehouseitem", itemRef.Id, new ColumnSet("dmpp_availablequantity"));
            var available = (int)item["dmpp_availablequantity"];

            item["dmpp_availablequantity"] = available - quantity;
            service.Update(item);
        }
    }
}
