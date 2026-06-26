#
# ╔════════════════════════════════════════════════════════════════════════════════════════╗
# ║                         03a: Package Deployer (Packages.Main)                          ║
# ╚════════════════════════════════════════════════════════════════════════════════════════╝
#
# Creates the Package Deployer project that deploys all solutions.
# Expects: $PublisherName, $PublisherPrefix from parent scope.
#
# ──────────────────────────────────────────────────────────────────────────────────────────

Write-Host "`n── Package Deployer ──" -ForegroundColor Cyan

txc workspace component create pp-package `
    --output "src/Packages.Main"

# Add the package project to the Visual Studio solution file
cd "src/Packages.Main"
dotnet sln ../../ add Packages.Main.csproj
cd ../..

Write-Host "  ✓ Packages.Main" -ForegroundColor Green
