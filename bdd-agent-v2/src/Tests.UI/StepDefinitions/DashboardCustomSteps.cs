using Microsoft.Playwright;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Reqnroll;
using Tests.UI.Support;

namespace Tests.UI.StepDefinitions;

[Binding]
public sealed class DashboardCustomSteps
{
    private readonly ScenarioContext _scenarioContext;
    private IPage Page => (IPage)_scenarioContext[Hooks.PageKey];

    public DashboardCustomSteps(ScenarioContext scenarioContext)
    {
        _scenarioContext = scenarioContext;
    }

    // ── Helpers ───────────────────────────────────────────────────────

    /// <summary>
    /// Waits for the React dashboard component to render inside the MDA shell.
    /// </summary>
    private async Task WaitForDashboardReadyAsync()
    {
        await Page.Locator("main").GetByText("Warehouse Dashboard").WaitForAsync(
            new LocatorWaitForOptions { State = WaitForSelectorState.Visible, Timeout = 30000 });
    }

    /// <summary>
    /// Locates a Fluent UI summary card (role=group) by its title text.
    /// </summary>
    private ILocator GetSummaryCard(string title)
    {
        return Page.GetByRole(AriaRole.Group).Filter(new() { HasText = title });
    }

    /// <summary>
    /// Reads the numeric value displayed inside a summary card.
    /// The card structure is: group > [title text], [icon + value text].
    /// The value is the last generic text node that contains a number.
    /// </summary>
    private async Task<string> GetSummaryCardValueAsync(string title)
    {
        var card = GetSummaryCard(title);
        await card.WaitForAsync(new LocatorWaitForOptions { State = WaitForSelectorState.Visible, Timeout = 15000 });

        // The card has child elements: title text and a container with the numeric value.
        // We grab all inner text and extract the numeric portion after the title.
        var fullText = await card.InnerTextAsync();
        var lines = fullText.Split('\n', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries);

        // The numeric value is a line that is not the title itself.
        foreach (var line in lines)
        {
            if (!line.Equals(title, StringComparison.OrdinalIgnoreCase) && int.TryParse(line, out _))
            {
                return line;
            }
        }

        Assert.Fail($"Could not find a numeric value in the '{title}' summary card. Full text: '{fullText}'");
        return string.Empty; // unreachable
    }

    /// <summary>
    /// Locates the inventory table element (role=table) within the main content area.
    /// </summary>
    private ILocator GetInventoryTable()
    {
        return Page.GetByRole(AriaRole.Table);
    }

    /// <summary>
    /// Returns the column index (0-based) for a given column header name.
    /// </summary>
    private async Task<int> GetColumnIndexAsync(string columnName)
    {
        var headers = GetInventoryTable().GetByRole(AriaRole.Columnheader);
        var count = await headers.CountAsync();

        for (var i = 0; i < count; i++)
        {
            var text = (await headers.Nth(i).InnerTextAsync()).Trim();
            if (text.Equals(columnName, StringComparison.OrdinalIgnoreCase))
            {
                return i;
            }
        }

        Assert.Fail($"Column '{columnName}' not found in the inventory table.");
        return -1; // unreachable
    }

    /// <summary>
    /// Returns all data rows from the table body (excludes the header row).
    /// </summary>
    private ILocator GetDataRows()
    {
        // Data rows live in the second rowgroup (tbody). The first rowgroup is the thead.
        return GetInventoryTable().GetByRole(AriaRole.Rowgroup).Nth(1).GetByRole(AriaRole.Row);
    }

    // ── Step Definitions ─────────────────────────────────────────────

    [Then("I should see the {string} page heading")]
    public async Task ThenIShouldSeeThePageHeading(string heading)
    {
        await WaitForDashboardReadyAsync();
        var headingLocator = Page.Locator("main").GetByText(heading, new() { Exact = true });
        Assert.IsTrue(await headingLocator.IsVisibleAsync(),
            $"Expected page heading '{heading}' to be visible.");
    }

    [Then("I should see a summary card titled {string}")]
    public async Task ThenIShouldSeeASummaryCardTitled(string title)
    {
        await WaitForDashboardReadyAsync();
        var card = GetSummaryCard(title);
        await card.WaitForAsync(new LocatorWaitForOptions { State = WaitForSelectorState.Visible, Timeout = 15000 });
        Assert.IsTrue(await card.IsVisibleAsync(),
            $"Expected summary card '{title}' to be visible.");
    }

    [Then("the {string} summary card should show a value greater than {int}")]
    public async Task ThenTheSummaryCardShouldShowAValueGreaterThan(string title, int threshold)
    {
        await WaitForDashboardReadyAsync();
        var valueText = await GetSummaryCardValueAsync(title);
        Assert.IsTrue(int.TryParse(valueText, out var value),
            $"The value '{valueText}' in card '{title}' is not a valid integer.");
        Assert.IsTrue(value > threshold,
            $"Expected '{title}' card value ({value}) to be greater than {threshold}.");
    }

    [Then("the {string} summary card should show a numeric value")]
    public async Task ThenTheSummaryCardShouldShowANumericValue(string title)
    {
        await WaitForDashboardReadyAsync();
        var valueText = await GetSummaryCardValueAsync(title);
        Assert.IsTrue(int.TryParse(valueText, out _),
            $"Expected a numeric value in card '{title}' but found '{valueText}'.");
    }

    [Then("I should see the {string} table")]
    public async Task ThenIShouldSeeTheTable(string tableTitle)
    {
        await WaitForDashboardReadyAsync();

        // The table title lives in a sibling element within the same group container.
        var tableGroup = Page.GetByRole(AriaRole.Group).Filter(new() { HasText = tableTitle });
        await tableGroup.WaitForAsync(new LocatorWaitForOptions { State = WaitForSelectorState.Visible, Timeout = 15000 });

        var table = tableGroup.GetByRole(AriaRole.Table);
        Assert.IsTrue(await table.IsVisibleAsync(),
            $"Expected table '{tableTitle}' to be visible.");
    }

    [Then("the table should have columns:")]
    public async Task ThenTheTableShouldHaveColumns(DataTable dataTable)
    {
        await WaitForDashboardReadyAsync();

        var headers = GetInventoryTable().GetByRole(AriaRole.Columnheader);
        var headerCount = await headers.CountAsync();
        var actualHeaders = new List<string>();
        for (var i = 0; i < headerCount; i++)
        {
            actualHeaders.Add((await headers.Nth(i).InnerTextAsync()).Trim());
        }

        foreach (var row in dataTable.Rows)
        {
            var expected = row["Column"];
            Assert.IsTrue(actualHeaders.Contains(expected),
                $"Expected column '{expected}' not found. Actual columns: [{string.Join(", ", actualHeaders)}]");
        }
    }

    [Then("the inventory table should contain at least {int} row(s)")]
    public async Task ThenTheInventoryTableShouldContainAtLeastRows(int minRows)
    {
        await WaitForDashboardReadyAsync();

        var rows = GetDataRows();
        // Wait for at least one row to appear (data may load asynchronously).
        await rows.First.WaitForAsync(new LocatorWaitForOptions { State = WaitForSelectorState.Visible, Timeout = 15000 });

        var count = await rows.CountAsync();
        Assert.IsTrue(count >= minRows,
            $"Expected at least {minRows} row(s) in the inventory table but found {count}.");
    }

    [Then("items with quantity above their reorder point should show {string} status")]
    public async Task ThenItemsAboveReorderPointShouldShowStatus(string expectedStatus)
    {
        await WaitForDashboardReadyAsync();

        var qtyIndex = await GetColumnIndexAsync("Qty on Hand");
        var reorderIndex = await GetColumnIndexAsync("Reorder Point");
        var statusIndex = await GetColumnIndexAsync("Status");

        var rows = GetDataRows();
        var rowCount = await rows.CountAsync();

        for (var i = 0; i < rowCount; i++)
        {
            var cells = rows.Nth(i).GetByRole(AriaRole.Cell);
            var qtyText = (await cells.Nth(qtyIndex).InnerTextAsync()).Trim();
            var reorderText = (await cells.Nth(reorderIndex).InnerTextAsync()).Trim();
            var statusText = (await cells.Nth(statusIndex).InnerTextAsync()).Trim();

            if (int.TryParse(qtyText, out var qty) && int.TryParse(reorderText, out var reorder) && qty > reorder)
            {
                Assert.AreEqual(expectedStatus, statusText,
                    $"Row {i}: item with qty {qty} > reorder {reorder} should show '{expectedStatus}' but shows '{statusText}'.");
            }
        }
    }

    [Then("items at or below their reorder point should show {string} status")]
    public async Task ThenItemsAtOrBelowReorderPointShouldShowStatus(string expectedStatus)
    {
        await WaitForDashboardReadyAsync();

        var qtyIndex = await GetColumnIndexAsync("Qty on Hand");
        var reorderIndex = await GetColumnIndexAsync("Reorder Point");
        var statusIndex = await GetColumnIndexAsync("Status");

        var rows = GetDataRows();
        var rowCount = await rows.CountAsync();

        for (var i = 0; i < rowCount; i++)
        {
            var cells = rows.Nth(i).GetByRole(AriaRole.Cell);
            var qtyText = (await cells.Nth(qtyIndex).InnerTextAsync()).Trim();
            var reorderText = (await cells.Nth(reorderIndex).InnerTextAsync()).Trim();
            var statusText = (await cells.Nth(statusIndex).InnerTextAsync()).Trim();

            if (int.TryParse(qtyText, out var qty) && int.TryParse(reorderText, out var reorder) && qty <= reorder)
            {
                Assert.AreEqual(expectedStatus, statusText,
                    $"Row {i}: item with qty {qty} <= reorder {reorder} should show '{expectedStatus}' but shows '{statusText}'.");
            }
        }
    }

    [Then("the inventory table should be sorted by {string} in ascending order")]
    public async Task ThenTheInventoryTableShouldBeSortedByInAscendingOrder(string columnName)
    {
        await WaitForDashboardReadyAsync();

        var colIndex = await GetColumnIndexAsync(columnName);
        var rows = GetDataRows();
        var rowCount = await rows.CountAsync();

        var values = new List<int>();
        for (var i = 0; i < rowCount; i++)
        {
            var cellText = (await rows.Nth(i).GetByRole(AriaRole.Cell).Nth(colIndex).InnerTextAsync()).Trim();
            if (int.TryParse(cellText, out var val))
            {
                values.Add(val);
            }
            else
            {
                Assert.Fail($"Row {i}: expected numeric value in column '{columnName}' but found '{cellText}'.");
            }
        }

        for (var i = 1; i < values.Count; i++)
        {
            Assert.IsTrue(values[i] >= values[i - 1],
                $"Table is not sorted ascending by '{columnName}': row {i - 1} has {values[i - 1]} but row {i} has {values[i]}.");
        }
    }
}
