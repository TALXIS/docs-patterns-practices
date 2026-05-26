#
# ╔════════════════════════════════════════════════════════════════════════════════════════╗
# ║                        01: Prerequisites Check                                        ║
# ╚════════════════════════════════════════════════════════════════════════════════════════╝
#
# Checks: dotnet CLI, TALXIS Dataverse templates, git availability.
# Expects: $SkipGitInit from parent scope.
#
# ──────────────────────────────────────────────────────────────────────────────────────────

Write-Host "`n── Prerequisites ──" -ForegroundColor Cyan

# Check dotnet CLI
$dotnetVersion = & dotnet --version 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "  ✗ dotnet CLI not found. Install .NET SDK from https://dot.net" -ForegroundColor Red
    exit 1
}
Write-Host "  ✓ dotnet CLI: $dotnetVersion" -ForegroundColor Green

# Check TALXIS templates
$templateList = & dotnet new list pp-solution 2>&1 | Out-String
if ($templateList -notmatch "pp-solution") {
    Write-Host "  ✗ TALXIS Dataverse templates not found." -ForegroundColor Red
    Write-Host "    Install with: dotnet new install TALXIS.DevKit.Templates.Dataverse" -ForegroundColor Yellow
    exit 1
}
Write-Host "  ✓ TALXIS Dataverse templates installed" -ForegroundColor Green

# Check git
if (-not $SkipGitInit) {
    $gitVersion = & git --version 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  ⚠ git not found — will skip git init" -ForegroundColor Yellow
        $SkipGitInit = $true
    } else {
        Write-Host "  ✓ git: $gitVersion" -ForegroundColor Green
    }
}
