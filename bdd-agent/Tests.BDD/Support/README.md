# Support Infrastructure

This folder contains the core infrastructure for Reqnroll + Playwright BDD testing.

## Files

### TestConfiguration.cs
Reads test configuration from `appsettings.json`:
- `BaseUrl` - Application base URL (no hardcoded URLs in step definitions)
- `Timeout` - Default timeout for operations
- `BrowserType` - Default browser (chromium/firefox/webkit)

**Usage:**
```csharp
await _pageActions.NavigateTo($"{TestConfiguration.BaseUrl}/login");
```

### BrowserContext.cs
Manages the Playwright browser lifecycle per scenario. Holds references to:
- `IPlaywright` - Playwright instance
- `IBrowser` - Browser instance (Chromium/Firefox/WebKit)
- `IBrowserContext` - Browser context with optional auth state
- `IPage` - Current page being tested

**Injected into:**
- Step definitions (via dependency injection)
- PageActions helper
- Hooks

### Hooks.cs
Manages browser setup/teardown for each scenario:

**BeforeScenario:**
- Initializes Playwright
- Launches browser (type determined by `BROWSER` env var: chromium/firefox/webkit)
- Creates browser context with viewport and auth state
- Loads encrypted auth state if available (from previous runs)
- Creates new page

**AfterScenario:**
- Saves encrypted auth state (login persists between runs)
- Closes page, context, browser
- Disposes Playwright

**Environment Variables:**
- `BROWSER=chromium|firefox|webkit` - Browser type (default: chromium)
- `HEADLESS=true|false` - Run headless or headed (default: false)

### PageActions.cs
Provides 60+ helper methods for common UI interactions. Injected into step definitions.

**Categories:**
- **Navigation:** `NavigateTo()`, `GoBack()`, `Reload()`, `CurrentUrl`
- **Click:** `ClickByRole()`, `ClickByText()`, `ClickByLabel()`, `Click()`
- **Fill:** `FillByLabel()`, `FillByPlaceholder()`, `Fill()`, `Type()`, `Press()`
- **Select:** `SelectOption()`, `Check()`, `Uncheck()`
- **Wait:** `WaitForSelector()`, `WaitForUrl()`, `WaitForLoadState()`
- **Assert:** `IsVisible()`, `IsEnabled()`, `HasText()`, `GetText()`, `GetElementCount()`
- **Utility:** `Hover()`, `Focus()`, `ScrollIntoView()`, `TakeScreenshot()`
- **Direct Access:** `Page` property for advanced Playwright features

**Usage in Step Definitions:**
```csharp
[Binding]
public class MyFeatureSteps
{
    private readonly PageActions _pageActions;
    private IPage Page => _pageActions.Page; // Direct access when needed

    public MyFeatureSteps(PageActions pageActions)
    {
        _pageActions = pageActions;
    }

    [Given(@"I am on the login page")]
    public async Task GivenIAmOnLoginPage()
    {
        await _pageActions.NavigateTo("https://example.com/login");
    }

    [When(@"I fill in credentials")]
    public async Task WhenIFillCredentials()
    {
        // Use helpers for simple actions
        await _pageActions.FillByLabel("Username", "user@example.com");
        
        // Use direct Page access for complex scenarios
        await Page.GetByRole(AriaRole.Combobox, new() { Name = "Country" })
            .SelectOptionAsync("USA");
    }

    [Then(@"I should see welcome message")]
    public async Task ThenIShouldSeeWelcome()
    {
        Assert.IsTrue(await _pageActions.HasText("Welcome back!"));
    }
}
```

### StorageStateProtector.cs
Handles encrypted storage of authentication state using Windows DPAPI (Data Protection API).

**Features:**
- Saves browser authentication state after each scenario
- Encrypts cookies/localStorage/sessionStorage
- Restores auth state on next run (no need to login every time)
- Windows-specific (uses DPAPI for encryption)

**Storage Location:**
- Encrypted: `TestResults/storageState.dat`
- Decrypted temp: `%TEMP%/playwright-auth-state.json` (deleted after use)

## Integration with BDD Generator Chatmode

The **BDD Generator chatmode** (`.github/chatmodes/bdd-generator-streamlined.chatmode.md`) is optimized for this infrastructure:

1. **Discovers existing structure** - Finds PageActions and other helpers
2. **Reuses infrastructure** - Injects PageActions instead of creating duplicate helpers
3. **Generates step definitions** - Uses PageActions methods and direct Page access
4. **Follows conventions** - Matches this template's namespace and patterns

## Customization

**To use different browsers:**
```bash
# Run tests with Firefox
$env:BROWSER="firefox"; dotnet test

# Run headless
$env:HEADLESS="true"; dotnet test
```

**To modify browser options:**
Edit `Hooks.cs` - BeforeScenario method, `BrowserTypeLaunchOptions` section.

**To add custom helpers:**
1. Add methods to `PageActions.cs` for reusable actions
2. Or create new helper classes in `StepDefinitions/Helpers/` for feature-specific logic

**To disable auth persistence:**
Comment out the `StorageStateProtector` calls in `Hooks.cs`.

## Why This Structure?

**Opinionated but flexible:**
- ✅ **Works out of the box** - No setup needed for basic scenarios
- ✅ **AI-friendly** - Chatmode knows about PageActions and can generate code using it
- ✅ **Escape hatches** - Direct `Page` access when helpers aren't enough
- ✅ **DRY principle** - Common actions in PageActions, feature-specific in step definitions
- ✅ **Auth persistence** - Login once, use encrypted state for all subsequent runs
- ✅ **Multi-browser** - Easy switching via environment variables

**Can be adapted:**
- Users with different structures can still use the chatmode (it adapts)
- This is a recommended starting point, not a strict requirement
