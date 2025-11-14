// type CFT01 and then press control+space to trigger suggestions of snippets
//
// ╔══════════════════════════════════════════════════════════════════════════════════════╗
// ║ CFT01: ValidateWarehouseTransactionPlugin – quantity validation tests                ║
// ╚══════════════════════════════════════════════════════════════════════════════════════╝
//
// These tests cover the validation logic that runs on Create of udpp_warehousetransaction.
// They verify that:
//  - a transaction with enough quantity does not throw and does not change stock,
//  - a transaction with too high quantity throws InvalidPluginExecutionException.
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
    public class ValidateWarehouseTransactionPluginTests : FakeXrmEasyTestBase
    {
        [TestMethod]
        public void CreateTransaction_With_Enough_Quantity_Does_Not_Throw()
        {
            var itemId = Guid.NewGuid();
            var available = 10;
            var requested = 3;

            var item = new Entity("udpp_warehouseitem")
            {
                Id = itemId
            };
            item["udpp_availablequantity"] = available;

            _context.Initialize(new[] { item });

            var transaction = new Entity("udpp_warehousetransaction")
            {
                Id = Guid.NewGuid()
            };
            transaction["udpp_quantity"] = requested;
            transaction["udpp_itemid"] = new EntityReference("udpp_warehouseitem", itemId);

            var pluginContext = _context.GetDefaultPluginContext();
            pluginContext.MessageName = "Create";
            pluginContext.PrimaryEntityName = "udpp_warehousetransaction";
            pluginContext.InputParameters["Target"] = transaction;

            var plugin = new ValidateWarehouseTransactionPlugin(string.Empty, string.Empty);

            _context.ExecutePluginWith(pluginContext, plugin);

            var reloaded = _service.Retrieve(
                "udpp_warehouseitem",
                itemId,
                new ColumnSet("udpp_availablequantity"));

            var actual = reloaded.GetAttributeValue<int>("udpp_availablequantity");
            Assert.AreEqual(available, actual);
        }

        [TestMethod]
        public void CreateTransaction_With_Too_High_Quantity_Throws_InvalidPluginExecutionException()
        {
            var itemId = Guid.NewGuid();
            var available = 5;
            var requested = 10;

            var item = new Entity("udpp_warehouseitem")
            {
                Id = itemId
            };
            item["udpp_availablequantity"] = available;

            _context.Initialize(new[] { item });

            var transaction = new Entity("udpp_warehousetransaction")
            {
                Id = Guid.NewGuid()
            };
            transaction["udpp_quantity"] = requested;
            transaction["udpp_itemid"] = new EntityReference("udpp_warehouseitem", itemId);

            var pluginContext = _context.GetDefaultPluginContext();
            pluginContext.MessageName = "Create";
            pluginContext.PrimaryEntityName = "udpp_warehousetransaction";
            pluginContext.InputParameters["Target"] = transaction;
            pluginContext.Stage = 10;

            var plugin = new ValidateWarehouseTransactionPlugin(string.Empty, string.Empty);

            // Act + Assert
            var ex = Assert.ThrowsException<InvalidPluginExecutionException>(() =>
            {
                _context.ExecutePluginWith(pluginContext, plugin);
            });

            StringAssert.Contains(ex.Message, "Not enough product in stock");
            StringAssert.Contains(ex.Message, $"Available: {available}");
            StringAssert.Contains(ex.Message, $"requested: {requested}");
        }
    }
}