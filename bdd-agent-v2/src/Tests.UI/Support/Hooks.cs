using Microsoft.Playwright;
using Reqnroll;

namespace Tests.UI.Support;

[Binding]
public sealed class Hooks
{
    public const string BrowserContextKey = "Playwright.BrowserContext";
    public const string PageKey = "Playwright.Page";

    private static IPlaywright? _playwright;
    private static IBrowser? _browser;

    private readonly ScenarioContext _scenarioContext;

    public Hooks(ScenarioContext scenarioContext)
    {
        _scenarioContext = scenarioContext;
    }

    [BeforeTestRun]
    public static async Task BeforeTestRun()
    {
        // Browser binaries must be installed before running tests.
        // Run `pwsh bin/Debug/net8.0/playwright.ps1 install chromium` or see the README.

        _playwright = await Playwright.CreateAsync();
        _browser = await _playwright.Chromium.LaunchAsync(new BrowserTypeLaunchOptions
        {
            Headless = TestConfiguration.Headless,
            SlowMo = TestConfiguration.SlowMo,
            Args = new[] { "--start-maximized", "--window-size=1920,1080" }
        });
    }

    [BeforeScenario]
    public async Task BeforeScenario()
    {
        if (_browser is null)
        {
            throw new InvalidOperationException("Browser is not initialized. BeforeTestRun must complete first.");
        }

        var contextOptions = new BrowserNewContextOptions
        {
            // NoViewport allows --start-maximized to fill the screen in headed mode.
            // In headless mode, --window-size=1920,1080 provides the fallback dimensions.
            ViewportSize = ViewportSize.NoViewport
        };

        var storagePath = TestConfiguration.ResolvedStorageStatePath;
        if (!string.IsNullOrWhiteSpace(storagePath) && File.Exists(storagePath))
        {
            contextOptions.StorageStatePath = storagePath;
        }

        var browserContext = await _browser.NewContextAsync(contextOptions);
        if (TestConfiguration.TracingEnabled)
        {
            await browserContext.Tracing.StartAsync(new TracingStartOptions
            {
                Screenshots = true,
                Snapshots = true,
                Sources = true
            });
        }

        var page = await browserContext.NewPageAsync();
        page.SetDefaultTimeout(TestConfiguration.Timeout);

        _scenarioContext[BrowserContextKey] = browserContext;
        _scenarioContext[PageKey] = page;
    }

    [AfterScenario(Order = int.MaxValue)]
    public async Task AfterScenario()
    {
        if (TestConfiguration.TracingEnabled &&
            _scenarioContext.TestError is null &&
            _scenarioContext.ContainsKey(BrowserContextKey))
        {
            var context = (IBrowserContext)_scenarioContext[BrowserContextKey];
            await context.Tracing.StopAsync();
        }

        // Persist auth state so subsequent runs skip manual login
        var savePath = TestConfiguration.ResolvedStorageStatePath;
        if (!string.IsNullOrWhiteSpace(savePath) &&
            _scenarioContext.ContainsKey(BrowserContextKey))
        {
            var context = (IBrowserContext)_scenarioContext[BrowserContextKey];
            await context.StorageStateAsync(new BrowserContextStorageStateOptions
            {
                Path = savePath
            });
        }

        if (_scenarioContext.ContainsKey(BrowserContextKey))
        {
            var context = (IBrowserContext)_scenarioContext[BrowserContextKey];
            await context.CloseAsync();
        }
    }

    [AfterTestRun]
    public static async Task AfterTestRun()
    {
        if (_browser is not null)
        {
            await _browser.CloseAsync();
            _browser = null;
        }

        _playwright?.Dispose();
        _playwright = null;
    }
}
