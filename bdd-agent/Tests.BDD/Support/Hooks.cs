using Microsoft.Playwright;
using Reqnroll;

namespace Tests.BDD.Support;

/// <summary>
/// Hooks for managing browser lifecycle.
/// Browser is initialized before each scenario and cleaned up after.
/// </summary>
[Binding]
public class Hooks
{
    private readonly BrowserContext _browserContext;

    public Hooks(BrowserContext browserContext)
    {
        _browserContext = browserContext;
    }

    [BeforeScenario]
    public async Task BeforeScenario()
    {
        // Initialize Playwright
        _browserContext.Playwright = await Playwright.CreateAsync();
        
        // Determine browser type from environment variable (default: chromium)
        var browserType = Environment.GetEnvironmentVariable("BROWSER")?.ToLower() ?? "chromium";
        var headless = Environment.GetEnvironmentVariable("HEADLESS")?.ToLower() == "true";
        
        // Launch browser
        _browserContext.Browser = browserType switch
        {
            "firefox" => await _browserContext.Playwright.Firefox.LaunchAsync(new BrowserTypeLaunchOptions
            {
                Headless = headless,
                SlowMo = headless ? 0 : 50 // Slow down in headed mode for visibility
            }),
            "webkit" => await _browserContext.Playwright.Webkit.LaunchAsync(new BrowserTypeLaunchOptions
            {
                Headless = headless,
                SlowMo = headless ? 0 : 50
            }),
            _ => await _browserContext.Playwright.Chromium.LaunchAsync(new BrowserTypeLaunchOptions
            {
                Headless = headless,
                SlowMo = headless ? 0 : 50
            })
        };
        
        // Create browser context with stored auth state if it exists
        var contextOptions = new BrowserNewContextOptions
        {
            ViewportSize = new ViewportSize { Width = 960, Height = 1080 },
        };
        
        // Load encrypted auth state if available (decrypts to temp location)
        var authStatePath = StorageStateProtector.GetStorageStatePath();
        if (authStatePath != null)
        {
            contextOptions.StorageStatePath = authStatePath;
        }
        
        _browserContext.Context = await _browserContext.Browser.NewContextAsync(contextOptions);
        
        // Create new page
        _browserContext.Page = await _browserContext.Context.NewPageAsync();
    }

    [AfterScenario]
    public async Task AfterScenario()
    {
        // Save authentication state for reuse (encrypted with Windows DPAPI)
        if (_browserContext.Context != null)
        {
            var tempStatePath = Path.Combine(Path.GetTempPath(), "playwright-auth-state.json");
            await _browserContext.Context.StorageStateAsync(new BrowserContextStorageStateOptions
            {
                Path = tempStatePath
            });
            
            // Encrypt and save the state
            StorageStateProtector.SaveStorageState();
        }
        
        // Clean up resources in reverse order
        if (_browserContext.Page != null)
        {
            await _browserContext.Page.CloseAsync();
        }
            
        if (_browserContext.Context != null)
        {
            await _browserContext.Context.CloseAsync();
        }
            
        if (_browserContext.Browser != null)
        {
            await _browserContext.Browser.CloseAsync();
        }
            
        _browserContext.Playwright?.Dispose();
    }
}
