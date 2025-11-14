// type CFT02 and then press control+space to trigger suggestions of snippets
//
// ╔══════════════════════════════════════════════════════════════════════════════════════╗
// ║ CFT02: SubtractQuantityPlugin – stock update tests                                  ║
// ╚══════════════════════════════════════════════════════════════════════════════════════╝
//
// These tests cover the stock update logic that runs on Create of udpp_warehousetransaction.
// They verify that the plugin subtracts the requested quantity from udpp_availablequantity
// on the related udpp_warehouseitem record.
//
using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Query;
using FakeXrmEasy.Plugins;
using Plugins.Warehouse;

namespace Plugins.Tests
{
    [TestClass]
    public class SubtractQuantityPluginTests : FakeXrmEasyTestBase
    {
        [TestMethod]
        public void CreateTransaction_Should_Subtract_Quantity_From_Item()
        {
            var itemId = Guid.NewGuid();
            var startQty = 10;
            var delta = 3;

            var item = new Entity("udpp_warehouseitem")
            {
                Id = itemId
            };
            item["udpp_availablequantity"] = startQty;

            _context.Initialize(new[] { item });

            var transactionEntity = new Entity("udpp_warehousetransaction")
            {
                Id = Guid.NewGuid()
            };
            transactionEntity["udpp_quantity"] = delta;
            transactionEntity["udpp_itemid"] =
                new EntityReference("udpp_warehouseitem", itemId);

            var pluginContext = _context.GetDefaultPluginContext();
            pluginContext.MessageName = "Create";
            pluginContext.PrimaryEntityName = "udpp_warehousetransaction";
            pluginContext.InputParameters["Target"] = transactionEntity;

            var plugin = new SubtractQuantityPlugin(
                unsecureConfiguration: string.Empty,
                secureConfiguration: string.Empty);

            _context.ExecutePluginWith(pluginContext, plugin);

            var updatedItem = _service.Retrieve(
                "udpp_warehouseitem",
                itemId,
                new ColumnSet("udpp_availablequantity"));

            var actual = updatedItem.GetAttributeValue<int>("udpp_availablequantity");
            Assert.AreEqual(startQty - delta, actual);
        }
    }
}