using Microsoft.Extensions.Configuration;

namespace Tests.BDD.Support;

public class TestConfiguration
{
    private static readonly IConfiguration Config = new ConfigurationBuilder()
        .SetBasePath(Directory.GetCurrentDirectory())
        .AddJsonFile("appsettings.json", optional: false)
        .Build();

    public static string BaseUrl => Config["TestConfiguration:BaseUrl"] 
        ?? throw new InvalidOperationException("BaseUrl not configured in appsettings.json");

    public static int Timeout => int.Parse(Config["TestConfiguration:Timeout"] ?? "30000");

    public static string BrowserType => Config["TestConfiguration:BrowserType"] ?? "chromium";
}
