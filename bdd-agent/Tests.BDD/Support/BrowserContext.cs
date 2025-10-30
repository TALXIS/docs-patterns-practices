using Microsoft.Playwright;

namespace Tests.BDD.Support;

/// <summary>
/// Manages the Playwright browser context for each scenario.
/// Injected into step definitions via Reqnroll's dependency injection.
/// </summary>
public class BrowserContext
{
    public IPlaywright? Playwright { get; set; }
    public IBrowser? Browser { get; set; }
    public IBrowserContext? Context { get; set; }
    public IPage? Page { get; set; }
}
