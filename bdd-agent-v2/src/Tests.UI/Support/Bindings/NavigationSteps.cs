using Microsoft.Playwright;
using Reqnroll;

namespace Tests.UI.Support.Bindings;

[Binding]
public sealed class NavigationSteps
{
    private readonly ScenarioContext _scenarioContext;
    private IPage Page => (IPage)_scenarioContext[Hooks.PageKey];

    public NavigationSteps(ScenarioContext scenarioContext)
    {
        _scenarioContext = scenarioContext;
    }

    [Given("I am logged in as {string}")]
    public Task GivenIAmLoggedInAs(string profile)
    {
        _scenarioContext["Profile"] = profile;
        return Task.CompletedTask;
    }

    [Given("I open the {string} app")]
    public async Task GivenIOpenTheApp(string appName)
    {
        await OpenAppAsync(appName);
    }

    [When("I click on {string} in the sitemap")]
    public async Task WhenIClickOnInTheSitemap(string name)
    {
        await ClickSitemapItemAsync(name);
    }

    [When("I navigate to {string} > {string}")]
    public async Task WhenINavigateTo(string area, string subarea)
    {
        await ClickSitemapItemAsync(area);
        await ClickSitemapItemAsync(subarea);
    }

    [When("I navigate to {string} > {string} > {string}")]
    public async Task WhenINavigateTo(string area, string group, string subarea)
    {
        await ClickSitemapItemAsync(area);
        await ClickSitemapItemAsync(group);
        await ClickSitemapItemAsync(subarea);
    }

    [When("I switch to the {string} app")]
    public async Task WhenISwitchToTheApp(string appName)
    {
        await OpenAppAsync(appName);
    }

    [Then("I should see the {string} view")]
    public async Task ThenIShouldSeeTheView(string viewName)
    {
        var viewSelector = Page.Locator("[data-id*='ViewSelector'], button[data-id*='ViewSelector']").First;
        await viewSelector.WaitForAsync(new LocatorWaitForOptions
        {
            State = WaitForSelectorState.Visible,
            Timeout = TestConfiguration.Timeout
        });

        var viewText = await viewSelector.InnerTextAsync();
        Assert.IsTrue(
            viewText.Contains(viewName, StringComparison.OrdinalIgnoreCase),
            $"Expected view '{viewName}' but found '{viewText}'.");
    }

    [When("I search for {string} in global search")]
    public async Task WhenISearchForInGlobalSearch(string text)
    {
        var searchBox = Page.GetByPlaceholder("Search");
        await searchBox.ClickAsync();
        await searchBox.FillAsync(text);
        await searchBox.PressAsync("Enter");
    }

    private async Task OpenAppAsync(string appName)
    {
        var baseUrl = TestConfiguration.EnvironmentUrl.TrimEnd('/');
        var url = $"{baseUrl}/main.aspx?appname={Uri.EscapeDataString(appName)}";

        await Page.GotoAsync(url, new PageGotoOptions { WaitUntil = WaitUntilState.DOMContentLoaded });

        // Wait for the MDA app shell to fully render.
        // The sitemap tree or command bar indicates readiness — [data-id='sitemap-entity'] does
        // not exist in modern MDA; instead we look for treeitem nodes or the command bar.
        await Page.Locator(
            "[role='treeitem'], [data-lp-id*='sitemap-entity'], [role='menuitem']"
        ).First.WaitForAsync(new LocatorWaitForOptions
        {
            State = WaitForSelectorState.Visible,
            Timeout = TestConfiguration.Timeout
        });
    }

    private async Task ClickSitemapItemAsync(string name)
    {
        // Modern MDA renders sitemap subareas as treeitem elements inside a navigation tree.
        // We try several robust selectors in priority order.
        var locator = Page.Locator(string.Join(", ",
            $"li[role='treeitem'][title='{name}']",
            $"[role='treeitem'][title='{name}']",
            $"[data-lp-id*='sitemap'] [title='{name}']",
            $"nav[aria-label*='itemap'] [title='{name}']",
            $"button[title='{name}']"
        )).First;

        await locator.WaitForAsync(new LocatorWaitForOptions
        {
            State = WaitForSelectorState.Visible,
            Timeout = TestConfiguration.Timeout
        });

        await locator.ClickAsync();

        // After clicking a sitemap item, wait for navigation to settle.
        await Page.WaitForLoadStateAsync(LoadState.DOMContentLoaded);
    }
}
