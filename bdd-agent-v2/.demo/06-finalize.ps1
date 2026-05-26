#
# ╔════════════════════════════════════════════════════════════════════════════════════════╗
# ║                        06: Finalize — Commit, Build, Deploy                            ║
# ╚════════════════════════════════════════════════════════════════════════════════════════╝
#
# Final commit, optional build/publish, and deployment instructions.
# Expects: $OutputPath, $SkipGitInit, $SkipBuild from parent scope.
#
# ──────────────────────────────────────────────────────────────────────────────────────────

Write-Host "`n── Finalize ──" -ForegroundColor Cyan

# Commit all scaffolded content
if (-not $SkipGitInit) {
    git add --all
    git commit -m "feat: Scaffold warehouse management solution" --quiet
    Write-Host "  ✓ Committed: feat: Scaffold warehouse management solution" -ForegroundColor Green
}

# Build and publish
if (-not $SkipBuild) {
    Write-Host "  → Building solution..." -ForegroundColor White
    dotnet build --nologo --verbosity quiet
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✓ Build succeeded" -ForegroundColor Green
    } else {
        Write-Host "  ⚠ Build had issues (exit code: $LASTEXITCODE)" -ForegroundColor Yellow
    }

    Write-Host "  → Publishing release..." -ForegroundColor White
    dotnet publish -c Release --nologo --verbosity quiet
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✓ Publish succeeded" -ForegroundColor Green
    } else {
        Write-Host "  ⚠ Publish had issues (exit code: $LASTEXITCODE)" -ForegroundColor Yellow
    }
} else {
    Write-Host "  ⚠ Build skipped (-SkipBuild)" -ForegroundColor Yellow
}

# ──────────────────────────────────────────────────────────────────────────────────────────
#                                 Deployment Instructions
# ──────────────────────────────────────────────────────────────────────────────────────────

Write-Host ""
Write-Host "  Repository scaffolded at: $OutputPath" -ForegroundColor Green
Write-Host ""
Write-Host "  --- Deployment ---" -ForegroundColor White
Write-Host "  1. Create a dev environment:" -ForegroundColor White
Write-Host "     pac admin create --type Developer --domain <domain>" -ForegroundColor DarkGray
Write-Host "  2. Authenticate:" -ForegroundColor White
Write-Host "     txc config profile create --url https://<domain>.crm4.dynamics.com --name demo" -ForegroundColor DarkGray
Write-Host "  3. Select profile:" -ForegroundColor White
Write-Host "     txc config profile select demo" -ForegroundColor DarkGray
Write-Host "  4. Deploy:" -ForegroundColor White
Write-Host "     txc env pkg import './src/Packages.Main/bin/Release/Packages.Main.1.0.0.pdpkg.zip'" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  Done! 🚀" -ForegroundColor Green
Write-Host ""
