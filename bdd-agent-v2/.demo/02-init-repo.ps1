#
# ╔════════════════════════════════════════════════════════════════════════════════════════╗
# ║                        02: Initialize Repository                                      ║
# ╚════════════════════════════════════════════════════════════════════════════════════════╝
#
# Creates output directory, git init, .gitignore, .sln, src/, NuGet.config,
# and performs the initial commit.
# Expects: $OutputPath, $SkipGitInit, $SolutionName from parent scope.
#
# ──────────────────────────────────────────────────────────────────────────────────────────

Write-Host "`n── Initialize Repository ──" -ForegroundColor Cyan

if (Test-Path $OutputPath) {
    Write-Host "  ⚠ Directory already exists: $OutputPath" -ForegroundColor Yellow
} else {
    New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
    Write-Host "  ✓ Created: $OutputPath" -ForegroundColor Green
}

Push-Location $OutputPath
try {

# Step 1: Initialize git repository
if (-not $SkipGitInit) {
    git init -b main --quiet
    Write-Host "  ✓ git init (main branch)" -ForegroundColor Green
}

# Step 2: Generate .gitignore
dotnet new gitignore
Write-Host "  ✓ .gitignore" -ForegroundColor Green

# Step 3: Create Visual Studio solution file
dotnet new sln --name $SolutionName
Write-Host "  ✓ $SolutionName.sln" -ForegroundColor Green

# Step 4: Create src/ directory
if (-not (Test-Path "src")) {
    New-Item -ItemType Directory -Path "src" -Force | Out-Null
}
Write-Host "  ✓ src/ directory" -ForegroundColor Green

# Step 5: Create NuGet.config
$nugetConfig = @"
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <packageSources>
    <add key="nuget.org" value="https://api.nuget.org/v3/index.json" protocolVersion="3" />
  </packageSources>
</configuration>
"@
Set-Content -Path "NuGet.config" -Value $nugetConfig -Encoding UTF8
Write-Host "  ✓ NuGet.config" -ForegroundColor Green

# Step 6: Initial commit
if (-not $SkipGitInit) {
    git add --all
    git commit -m "chore: Initialize repository" --quiet
    Write-Host "  ✓ Initial commit" -ForegroundColor Green
}

} finally {
    Pop-Location
}
