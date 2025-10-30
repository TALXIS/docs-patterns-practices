# Support Infrastructure

Pre-built infrastructure for Reqnroll + Playwright testing. **Do not modify** these files unless customizing framework behavior.

## Core Components

### TestConfiguration.cs
Reads `appsettings.json` configuration:
```csharp
TestConfiguration.BaseUrl      // Your application URL
TestConfiguration.Timeout      // Default timeout (ms)
TestConfiguration.BrowserType  // chromium/firefox/webkit
```

### BrowserContext.cs
Dependency injection container holding Playwright objects:
- `IPlaywright`, `IBrowser`, `IBrowserContext`, `IPage`
- Auto-injected into step definitions and helpers

### Hooks.cs
**BeforeScenario:** Launches browser, loads encrypted auth state  
**AfterScenario:** Saves auth state, closes browser

**Environment variables:**
- `BROWSER=chromium|firefox|webkit` (default: chromium)
- `HEADLESS=true|false` (default: false)

### ScreenshotHooks.cs
Captures full-page screenshots on test failure. Saved to `TestResults/Screenshots/` and attached to Azure DevOps test results.

### PageActions.cs
60+ helper methods for common UI interactions. Inject into step definitions:

```csharp
[Binding]
public class MySteps
{
    private readonly PageActions _pageActions;
    private IPage Page => _pageActions.Page; // Direct Playwright access
    
    public MySteps(PageActions pageActions) => _pageActions = pageActions;
    
    [When(@"I fill in credentials")]
    public async Task WhenIFillCredentials()
    {
        await _pageActions.FillByLabel("Username", "user@example.com");
        await _pageActions.ClickByRole("button", "Sign In");
    }
}
```

**API Categories:**
- **Navigation:** `NavigateTo()`, `GoBack()`, `Reload()`, `CurrentUrl`
- **Clicks:** `ClickByRole()`, `ClickByText()`, `ClickByLabel()`, `ClickByTestId()`
- **Fill:** `FillByLabel()`, `FillByPlaceholder()`, `Fill()`
- **Select:** `SelectOption()`, `Check()`, `Uncheck()`
- **Wait:** `WaitForSelector()`, `WaitForUrl()`, `WaitForLoadState()`
- **Assert:** `IsVisible()`, `IsEnabled()`, `HasText()`, `GetText()`
- **Utility:** `Hover()`, `Focus()`, `TakeScreenshot()`

**For complex scenarios:** Use `Page` property for direct Playwright access.

### StorageStateProtector.cs
Encrypts/decrypts authentication state using Windows DPAPI:
- **Location:** `%TEMP%/playwright-auth-state.encrypted`
- **Clear auth:** `Remove-Item "$env:TEMP\playwright-auth-state.encrypted"`

## Customization

**Browser options:** Edit `Hooks.cs` → `BrowserTypeLaunchOptions`  
**Custom helpers:** Add to `PageActions.cs` or create feature-specific helpers in `StepDefinitions/`  
**Disable auth persistence:** Comment out `StorageStateProtector` calls in `Hooks.cs`

## AI Integration

The chatmodes in `.github/chatmodes/` are optimized for this structure:
- **bdd-planner:** Explores UI, designs scenarios, reuses existing steps
- **bdd-binder:** Discovers selectors, implements step definitions using PageActions
