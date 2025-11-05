using Microsoft.Playwright;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Reqnroll;

namespace Tests.BDD.Support;

[Binding]
public class ScreenshotHooks
{
    private readonly BrowserContext _browserContext;
    private readonly ScenarioContext _scenarioContext;
    private readonly TestContext _testContext;

    public ScreenshotHooks(BrowserContext browserContext, ScenarioContext scenarioContext, TestContext testContext)
    {
        _browserContext = browserContext;
        _scenarioContext = scenarioContext;
        _testContext = testContext;
    }

    [AfterScenario(Order = int.MaxValue)]
    public async Task CaptureScreenshotOnFailure()
    {
        // Only capture screenshot if test failed
        if (_scenarioContext.TestError != null && _browserContext.Page != null)
        {
            try
            {
                var timestamp = DateTime.Now.ToString("yyyyMMdd_HHmmss");
                var scenarioName = _scenarioContext.ScenarioInfo.Title
                    .Replace(" ", "_")
                    .Replace("/", "_")
                    .Replace("\\", "_")
                    .Replace(":", "_");

                var screenshotDir = Path.Combine(AppContext.BaseDirectory, "TestResults", "Screenshots");
                Directory.CreateDirectory(screenshotDir);

                var screenshotPath = Path.Combine(screenshotDir, $"{scenarioName}_{timestamp}.png");

                // Capture full page screenshot
                await _browserContext.Page.ScreenshotAsync(new PageScreenshotOptions
                {
                    Path = screenshotPath,
                    FullPage = true
                });

                // Attach to test results (appears in Azure DevOps)
                _testContext.AddResultFile(screenshotPath);

                Console.WriteLine($"Screenshot captured: {screenshotPath}");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Failed to capture screenshot: {ex.Message}");
            }
        }
    }
}
