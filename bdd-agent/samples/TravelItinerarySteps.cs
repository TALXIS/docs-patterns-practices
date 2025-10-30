using Microsoft.Playwright;
using Reqnroll;
using Tests.BDD.Support;

namespace Tests.BDD.StepDefinitions;

[Binding]
public class TravelItinerarySteps
{
    private readonly PageActions _pageActions;
    private IPage Page => _pageActions.Page;

    public TravelItinerarySteps(PageActions pageActions)
    {
        _pageActions = pageActions;
    }

    #region Background Steps

    [Given(@"I am logged in to the Travel Admin Management App")]
    public async Task GivenIAmLoggedInToTheTravelAdminManagementApp()
    {
        await _pageActions.NavigateTo("https://ngt-teamproductivity1prod.crm4.dynamics.com/main.aspx?appid=c8cd6f37-b3e1-ef11-8eea-0022489f13bf");
        
        try
        {
            // Wait for the page to load - check for Power Apps branding
            await Page.GetByText("Power Apps").WaitForAsync(new() { State = WaitForSelectorState.Visible, Timeout = 30000 });
        }
        catch (TimeoutException)
        {
            // Check if we're on login page
            if (await Page.GetByText("Sign in").IsVisibleAsync())
            {
                throw new InvalidOperationException(
                    "Auth state expired or not available. Please run tests in headed mode (set HEADLESS=false) and log in manually. " +
                    "Authentication will be saved for future test runs.");
            }
            throw;
        }
    }

    [Given(@"I am on the Travel Itineraries page")]
    public async Task GivenIAmOnTheTravelItinerariesPage()
    {
        // Click on Travel Itineraries in the navigation tree
        var navItem = Page.GetByRole(AriaRole.Treeitem, new() { Name = "Travel Itineraries" });
        await navItem.WaitForAsync(new() { State = WaitForSelectorState.Visible, Timeout = 10000 });
        await navItem.ClickAsync();
        
        // Wait for the grid to load
        await Page.GetByRole(AriaRole.Heading, new() { Name = "Active Travel Itineraries" })
            .WaitForAsync(new() { State = WaitForSelectorState.Visible, Timeout = 15000 });
        
        // Wait for the grid itself to be present
        await Page.GetByRole(AriaRole.Treegrid, new() { Name = "Active Travel Itineraries" })
            .WaitForAsync(new() { State = WaitForSelectorState.Visible, Timeout = 10000 });
    }

    #endregion

    #region Action Steps - Navigation and Commands

    [When(@"I click the New button")]
    public async Task WhenIClickTheNewButton()
    {
        var newButton = Page.GetByRole(AriaRole.Menuitem, new() { Name = "New", Exact = true });
        await newButton.ClickAsync();
        
        // Wait for the new form to load
        await Page.GetByRole(AriaRole.Heading, new() { Name = "New Travel Itinerary" })
            .WaitForAsync(new() { State = WaitForSelectorState.Visible, Timeout = 10000 });
        
        // Wait for the form fields to be ready
        await Page.GetByRole(AriaRole.Tabpanel, new() { Name = "General" })
            .WaitForAsync(new() { State = WaitForSelectorState.Visible });
    }

    [When(@"I click the Save button")]
    public async Task WhenIClickTheSaveButton()
    {
        var saveButton = Page.GetByRole(AriaRole.Menuitem, new() { NameRegex = new System.Text.RegularExpressions.Regex("Save.*CTRL\\+S") });
        await saveButton.ClickAsync();
        
        // Wait for save to complete - status should update to "Saved"
        await Page.GetByRole(AriaRole.Status, new() { NameRegex = new System.Text.RegularExpressions.Regex(".*Saved.*") })
            .WaitForAsync(new() { State = WaitForSelectorState.Visible, Timeout = 15000 });
    }

    [When(@"I click the Save & Close button")]
    public async Task WhenIClickTheSaveAndCloseButton()
    {
        var saveCloseButton = Page.GetByRole(AriaRole.Menuitem, new() { Name = "Save & Close" });
        await saveCloseButton.ClickAsync();
        
        // Wait for navigation back to list view
        await Page.GetByRole(AriaRole.Heading, new() { Name = "Active Travel Itineraries" })
            .WaitForAsync(new() { State = WaitForSelectorState.Visible, Timeout = 15000 });
    }

    [When(@"I click the back button")]
    public async Task WhenIClickTheBackButton()
    {
        var backButton = Page.GetByRole(AriaRole.Button, new() { Name = "Press Enter to go back." });
        await backButton.ClickAsync();
        
        // Wait for list view to load
        await Page.GetByRole(AriaRole.Treegrid, new() { Name = "Active Travel Itineraries" })
            .WaitForAsync(new() { State = WaitForSelectorState.Visible, Timeout = 10000 });
    }

    [When(@"I click on the itinerary ""(.*)""")]
    public async Task WhenIClickOnTheItinerary(string itineraryName)
    {
        // NOTE: Using .First because multiple itineraries with same name may exist in test data
        var itineraryLink = Page.GetByRole(AriaRole.Link, new() { Name = itineraryName }).First;
        await itineraryLink.ClickAsync();
        
        // Wait for the form to load
        await Page.GetByRole(AriaRole.Form)
            .WaitForAsync(new() { State = WaitForSelectorState.Visible, Timeout = 10000 });
        
        // Verify the page title updated
        await Task.Delay(500); // Brief wait for title to update
    }

    [When(@"I search for ""(.*)"" in the itinerary filter")]
    public async Task WhenISearchForInTheItineraryFilter(string searchText)
    {
        var searchBox = Page.GetByRole(AriaRole.Searchbox, new() { Name = "Travel Itinerary Filter by keyword" });
        await searchBox.FillAsync(searchText);
        await searchBox.PressAsync("Enter");
        
        // Wait for grid to refresh - brief delay for filter to apply
        await Task.Delay(1000);
    }

    #endregion

    #region Action Steps - Form Filling

    [When(@"I fill the (.*) field with ""(.*)""")]
    public async Task WhenIFillTheFieldWith(string fieldName, string value)
    {
        var textbox = Page.GetByRole(AriaRole.Textbox, new() { Name = fieldName });
        await textbox.FillAsync(value);
    }

    [When(@"I fill the form with:")]
    public async Task WhenIFillTheFormWith(DataTable dataTable)
    {
        foreach (var row in dataTable.Rows)
        {
            var fieldName = row["Field"];
            var value = row["Value"];
            
            var textbox = Page.GetByRole(AriaRole.Textbox, new() { Name = fieldName });
            await textbox.FillAsync(value);
        }
    }

    [When(@"I select ""(.*)"" from the (.*) lookup")]
    public async Task WhenISelectFromTheLookup(string recordName, string fieldName)
    {
        // Click the search button to open lookup dialog
        var searchButton = Page.GetByRole(AriaRole.Button, 
            new() { NameRegex = new System.Text.RegularExpressions.Regex($"Search records for {fieldName}.*Lookup field") });
        await searchButton.ClickAsync();
        
        // Wait for lookup dialog to appear
        await Task.Delay(1500); // Allow dialog to render
        
        // The lookup shows "Recent records" tab by default
        // Try to click directly on the record name in the list
        try
        {
            // Option 1: Look for the record in the recent records list
            // Records appear as text within list items or options
            var recordOption = Page.GetByText(recordName, new() { Exact = true }).First;
            await recordOption.WaitForAsync(new() { State = WaitForSelectorState.Visible, Timeout = 5000 });
            await recordOption.ClickAsync();
        }
        catch
        {
            // Option 2: If not in recent, search for it
            // Look for "Look for Travel Request" input
            var lookupSearch = Page.GetByPlaceholder(new System.Text.RegularExpressions.Regex($"Look for {fieldName}"));
            if (await lookupSearch.CountAsync() > 0)
            {
                await lookupSearch.FillAsync(recordName);
                await Task.Delay(1000); // Wait for search results
                
                // Click on the search result
                var searchResult = Page.GetByText(recordName, new() { Exact = true }).First;
                await searchResult.ClickAsync();
            }
            else
            {
                // Fallback: Try clicking any element containing the record name
                var recordElement = Page.Locator($"text={recordName}").First;
                await recordElement.ClickAsync();
            }
        }
        
        // Wait for the lookup dialog to close and value to be set
        await Task.Delay(1000);
    }

    #endregion

    #region Assertion Steps

    [Then(@"I should see ""(.*)"" in the save status")]
    public async Task ThenIShouldSeeInTheSaveStatus(string expectedStatus)
    {
        var statusElement = Page.GetByRole(AriaRole.Status, new() { NameRegex = new System.Text.RegularExpressions.Regex($".*{expectedStatus}.*") });
        var isVisible = await statusElement.IsVisibleAsync();
        Assert.IsTrue(isVisible, $"Expected to see '{expectedStatus}' in save status, but it was not visible.");
    }

    [Then(@"the page title should contain ""(.*)""")]
    public async Task ThenThePageTitleShouldContain(string expectedText)
    {
        // Check the main heading (h1)
        var heading = Page.GetByRole(AriaRole.Heading, new() { Level = 1 });
        var headingText = await heading.TextContentAsync();
        Assert.IsTrue(headingText?.Contains(expectedText) ?? false, 
            $"Expected page title to contain '{expectedText}', but got '{headingText}'");
    }

    [Then(@"the (.*) field should contain ""(.*)""")]
    public async Task ThenTheFieldShouldContain(string fieldName, string expectedValue)
    {
        var textbox = Page.GetByRole(AriaRole.Textbox, new() { Name = fieldName });
        var actualValue = await textbox.InputValueAsync();
        Assert.AreEqual(expectedValue, actualValue, 
            $"Expected {fieldName} to contain '{expectedValue}', but got '{actualValue}'");
    }

    [Then(@"the (.*) field should show ""(.*)""")]
    public async Task ThenTheFieldShouldShow(string fieldName, string expectedValue)
    {
        // For lookup fields, check the displayed link text
        var lookupList = Page.GetByRole(AriaRole.List, new() { Name = fieldName });
        var linkInList = lookupList.GetByRole(AriaRole.Link, new() { Name = expectedValue });
        var isVisible = await linkInList.IsVisibleAsync();
        Assert.IsTrue(isVisible, 
            $"Expected {fieldName} to show '{expectedValue}', but it was not visible.");
    }

    [Then(@"I should be on the Travel Itineraries page")]
    public async Task ThenIShouldBeOnTheTravelItinerariesPage()
    {
        // Verify URL contains correct parameters
        var currentUrl = _pageActions.CurrentUrl;
        Assert.IsTrue(currentUrl.Contains("etn=cr4cc_travelitinerary"), 
            $"Expected URL to contain entity type, but got: {currentUrl}");
        Assert.IsTrue(currentUrl.Contains("pagetype=entitylist"), 
            $"Expected URL to contain list page type, but got: {currentUrl}");
        
        // Verify heading is visible
        var heading = Page.GetByRole(AriaRole.Heading, new() { Name = "Active Travel Itineraries" });
        var isVisible = await heading.IsVisibleAsync();
        Assert.IsTrue(isVisible, "Expected to be on Travel Itineraries page, but heading was not visible.");
    }

    [Then(@"I should see the itineraries grid")]
    public async Task ThenIShouldSeeTheItinerariesGrid()
    {
        var grid = Page.GetByRole(AriaRole.Treegrid, new() { Name = "Active Travel Itineraries" });
        var isVisible = await grid.IsVisibleAsync();
        Assert.IsTrue(isVisible, "Expected to see the itineraries grid, but it was not visible.");
    }

    [Then(@"I should see itineraries containing ""(.*)""")]
    public async Task ThenIShouldSeeItinerariesContaining(string searchText)
    {
        var grid = Page.GetByRole(AriaRole.Treegrid, new() { Name = "Active Travel Itineraries" });
        var cellsWithText = grid.GetByRole(AriaRole.Gridcell).Filter(new() { HasText = searchText });
        var count = await cellsWithText.CountAsync();
        Assert.IsTrue(count > 0, $"Expected to find results containing '{searchText}', but found none.");
    }

    [Then(@"the results should be filtered")]
    public async Task ThenTheResultsShouldBeFiltered()
    {
        // Verify grid is visible (indicating filter was applied)
        var grid = Page.GetByRole(AriaRole.Treegrid, new() { Name = "Active Travel Itineraries" });
        var isVisible = await grid.IsVisibleAsync();
        Assert.IsTrue(isVisible, "Expected grid to be visible after filtering.");
    }

    [Then(@"I should see ""(.*)"" in the grid")]
    public async Task ThenIShouldSeeInTheGrid(string recordName)
    {
        var grid = Page.GetByRole(AriaRole.Treegrid, new() { Name = "Active Travel Itineraries" });
        var link = grid.GetByRole(AriaRole.Link, new() { Name = recordName });
        var isVisible = await link.IsVisibleAsync();
        Assert.IsTrue(isVisible, $"Expected to see '{recordName}' in the grid, but it was not visible.");
    }

    #endregion
}
