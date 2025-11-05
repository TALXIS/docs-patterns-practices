# Reqnroll + Playwright BDD Template

AI-powered BDD test automation template using **Reqnroll**, **Playwright**, and **.NET 9**.

## Quick Start

### 1. Prerequisites
- [.NET 9 SDK](https://dotnet.microsoft.com/download)
- [VS Code](https://code.visualstudio.com/) with extensions:
  - `cucumber.cucumber-official` (Gherkin syntax)
  - `ms-dotnettools.csdevkit` (C# development)

### 2. Setup
```powershell
# Install dependencies
dotnet restore
dotnet build

# Install Playwright browsers
pwsh Tests.BDD/bin/Debug/net9.0/playwright.ps1 install
```

### 3. Configure
Edit `Tests.BDD/appsettings.json` with your application URL:
```json
{
  "TestConfiguration": {
    "BaseUrl": "https://your-app.example.com"
  }
}
```

### 4. Run Tests
```powershell
dotnet test
```

## Writing Tests

### AI-Powered Generation (Recommended)
Use GitHub Copilot with the included chatmodes in `.github/chatmodes/`:
1. **bdd-planner** - Explores your app and designs Gherkin scenarios
2. **bdd-binder** - Discovers selectors and implements step definitions

### Manual Creation
Create `.feature` files and C# step definitions. Infrastructure is ready to use - see `samples/` folder for working examples.

## Configuration

**Browser:** Set `$env:BROWSER="chromium|firefox|webkit"` (default: chromium)  
**Headless:** Set `$env:HEADLESS="true"` (default: false)  
**Authentication:** First run requires manual login. Auth state persists automatically. See [AUTHENTICATION.md](AUTHENTICATION.md).

