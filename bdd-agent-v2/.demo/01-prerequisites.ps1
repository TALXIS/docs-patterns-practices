#
# ╔════════════════════════════════════════════════════════════════════════════════════════╗
# ║                        01: Prerequisites Check                                        ║
# ╚════════════════════════════════════════════════════════════════════════════════════════╝
#
# Checks: dotnet CLI, TALXIS DevKit CLI (txc), git availability.
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

# Check TALXIS DevKit CLI (txc). It scaffolds the components and fetches the
# templates itself, so no separate template install is needed.
$txcTypes = & txc workspace component type list 2>&1 | Out-String
if ($LASTEXITCODE -ne 0) {
    Write-Host "  ✗ TALXIS DevKit CLI (txc) not found." -ForegroundColor Red
    Write-Host "    Install with: dotnet tool install --global TALXIS.CLI" -ForegroundColor Yellow
    exit 1
}
Write-Host "  ✓ TALXIS DevKit CLI (txc) available" -ForegroundColor Green

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
