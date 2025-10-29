# Reqnroll + Playwright BDD Template

AI-driven BDD test automation template using **Reqnroll** and **Playwright** for .NET.

## Prerequisites

### Required VS Code Extensions
```
code --install-extension cucumber.cucumber-official
code --install-extension ms-dotnettools.csdevkit
```

### Required Tools
- **.NET 9 SDK**: https://dotnet.microsoft.com/download
- **Node.js** (for Playwright MCP): https://nodejs.org/

## Setup

### 1. Install Dependencies
```powershell
dotnet restore
dotnet build
```

### 2. Install Playwright Browsers
```powershell
pwsh Tests.BDD/bin/Debug/net9.0/playwright.ps1 install
```

### 3. Install Playwright MCP Server
```powershell
# Install globally
npm install -g @microsoft/playwright-mcp

# Or use npx (no install needed)
npx @microsoft/playwright-mcp
```

### 4. Configure Your Application URL
Edit `Tests.BDD/appsettings.json`:
```json
{
  "TestConfiguration": {
    "BaseUrl": "https://your-app.example.com",
    "Timeout": 30000,
    "BrowserType": "chromium"
  }
}
```

## Project Structure

```
├── .github/chatmodes/
│   └── bdd-generator.chatmode.md    # AI assistant for test generation
├── Tests.BDD/
│   ├── Features/                     # Gherkin .feature files
│   ├── StepDefinitions/              # C# step implementations
│   │   └── Helpers/                  # Reusable UI helpers
│   ├── Support/                      # Infrastructure
│   │   ├── BrowserContext.cs        # Browser lifecycle
│   │   ├── Hooks.cs                 # Setup/teardown
│   │   ├── PageActions.cs           # 60+ UI helpers
│   │   ├── StorageStateProtector.cs # Auth persistence
│   │   └── TestConfiguration.cs     # Config reader
│   └── appsettings.json             # Test configuration
└── README.md
```

## Generating Tests

### Option 1: Use AI Chatmode (Recommended)
1. Open `.github/chatmodes/bdd-generator.chatmode.md` in GitHub Copilot
2. Tell it what to test: `"Test user login"`
3. AI will explore the page, write Gherkin, and generate step definitions

### Option 2: Ask Copilot Directly
The README context is Copilot-friendly. Just ask:
```
"Create a BDD test for user login"
```

Copilot will:
- Read TestConfiguration.BaseUrl from appsettings.json
- Use PageActions helpers
- Follow Reqnroll + Playwright patterns
- Generate .feature and step definition files

## Configuration

### Environment URL
Uses `TestConfiguration.BaseUrl` from `appsettings.json` - no hardcoded URLs in step definitions.

**Example step definition:**
```csharp
[Given(@"I am on the login page")]
public async Task GivenIAmOnLoginPage()
{
    await _pageActions.NavigateTo($"{TestConfiguration.BaseUrl}/login");
}
```

### Multi-Browser Support
```powershell
# Chromium (default)
dotnet test

# Firefox
$env:BROWSER="firefox"; dotnet test

# WebKit
$env:BROWSER="webkit"; dotnet test

# Headless (CI/CD)
$env:HEADLESS="true"; dotnet test
```

## Authentication

First test run prompts for manual login (supports MFA). Auth state is encrypted and persisted locally. Subsequent runs auto-login.

**Force re-login:**
```powershell
Remove-Item "$env:TEMP\playwright-auth-state.encrypted"
```

See [AUTHENTICATION.md](AUTHENTICATION.md) for details.

## PageActions Helpers

The `PageActions` class is injected into step definitions:

```csharp
[Binding]
public class LoginSteps
{
    private readonly PageActions _pageActions;
    private IPage Page => _pageActions.Page; // Direct Playwright access

    public LoginSteps(PageActions pageActions)
    {
        _pageActions = pageActions;
    }

    [When(@"I fill in credentials")]
    public async Task WhenIFillCredentials()
    {
        await _pageActions.FillByLabel("Email", "user@example.com");
        await _pageActions.FillByLabel("Password", "SecurePass123");
        await _pageActions.ClickByRole("button", "Sign In");
    }
}
```

**Available methods:**
- Navigation: `NavigateTo()`, `GoBack()`, `Reload()`
- Clicks: `ClickByRole()`, `ClickByLabel()`, `ClickByText()`, `ClickByTestId()`
- Fills: `FillByLabel()`, `FillByPlaceholder()`, `Fill()`
- Assertions: `HasText()`, `IsVisible()`, `GetText()`

See `Tests.BDD/Support/README.md` for complete API.

## Running Tests

```powershell
# All tests
dotnet test

# Specific feature
dotnet test --filter "FullyQualifiedName~Login"

# With specific browser
$env:BROWSER="firefox"; dotnet test
```

## Best Practices

### Gherkin
- Use business language (not CSS selectors)
- 3-5 steps per scenario
- Given = context, When = action, Then = outcome

### Step Definitions
- Use semantic locators (`GetByRole`, `GetByLabel`, `GetByText`)
- Always use async/await
- Wait for elements (never `Task.Delay()`)
- Read BaseUrl from `TestConfiguration`

### Locator Priority
1. `GetByTestId()` - data-testid attributes
2. `GetByRole()` - ARIA roles
3. `GetByLabel()` - Form labels
4. `GetByText()` - Visible text
5. `Locator()` - CSS/XPath (last resort)

## Template Notes

This repository is a template. Key infrastructure:
- **Support/** classes are pre-built (browser management, auth, helpers)
- **Features/** and **StepDefinitions/** are empty - generate tests with AI
- **appsettings.json** - Configure your application URL
- **Custom chatmode** - Guides AI through test generation workflow

See `.github/chatmodes/bdd-generator.chatmode.md` for the AI workflow.

