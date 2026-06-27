#
# ╔════════════════════════════════════════════════════════════════════════════════════════╗
# ║          08: Logic Solution — Plugin Assembly Registration and Steps                   ║
# ╚════════════════════════════════════════════════════════════════════════════════════════╝
#
# Creates Solutions.Logic with plugin assembly reference and SDK message processing steps.
# Expects: $PublisherName, $PublisherPrefix from parent scope.
# Expects: Plugins.Warehouse already built (07-plugins.ps1).
#
# ──────────────────────────────────────────────────────────────────────────────────────────
#                                  Solutions.Logic
# ──────────────────────────────────────────────────────────────────────────────────────────

Write-Host "`n── Solutions.Logic ──" -ForegroundColor Cyan

txc workspace component create pp-solution `
    --output "src/Solutions.Logic" `
    --param "PublisherName=$PublisherName" `
    --param "PublisherPrefix=$PublisherPrefix"

Write-Host "  ✓ Solutions.Logic" -ForegroundColor Green

# Add Solutions.Logic to the Package Deployer project
cd src/Packages.Main
dotnet add "./Packages.Main.csproj" reference "../Solutions.Logic/Solutions.Logic.csproj"
cd ../..

Write-Host "  ✓ ProjectReference: Logic → Packages.Main" -ForegroundColor Green

# Link plugin project to the logic solution
cd src/Solutions.Logic
dotnet add reference ../Plugins.Warehouse/Plugins.Warehouse.csproj
cd ../..

Write-Host "  ✓ ProjectReference: Plugins.Warehouse → Solutions.Logic" -ForegroundColor Green

# ──────────────────────────────────────────────────────────────────────────────────────────
#                              Build Logic Solution
# ──────────────────────────────────────────────────────────────────────────────────────────

Write-Host "  → Building Solutions.Logic..." -ForegroundColor White
cd src/Solutions.Logic
dotnet build --nologo --verbosity quiet
if ($LASTEXITCODE -eq 0) {
    Write-Host "  ✓ Logic build succeeded" -ForegroundColor Green
} else {
    Write-Host "  ⚠ Logic build had issues (exit code: $LASTEXITCODE)" -ForegroundColor Yellow
}
cd ../..

# ──────────────────────────────────────────────────────────────────────────────────────────
#                         Plugin Assembly Registration
# ──────────────────────────────────────────────────────────────────────────────────────────

Write-Host "`n── Plugin Assembly & Steps ──" -ForegroundColor Cyan

$assemblyGuid = [guid]::NewGuid()

txc workspace component create pp-plugin-assembly `
    --output "src/Solutions.Logic" `
    --param "AssemblyId=$assemblyGuid" `
    --param "PluginProjectRootPath=../Plugins.Warehouse"

Write-Host "  ✓ Plugin assembly registered" -ForegroundColor Green

# ──────────────────────────────────────────────────────────────────────────────────────────
#                      SDK Message Processing Steps
# ──────────────────────────────────────────────────────────────────────────────────────────

# PreValidation step — ValidateWarehouseTransactionPlugin
txc workspace component create pp-plugin-assembly-step `
    --output "src/Solutions.Logic" `
    --param "PrimaryEntity=${PublisherPrefix}_warehousetransaction" `
    --param "PluginProjectName=Plugins.Warehouse" `
    --param "PluginName=ValidateWarehouseTransactionPlugin" `
    --param "Stage=Pre-validation" `
    --param "SdkMessage=Create"


Write-Host "  ✓ Step: ValidateWarehouseTransactionPlugin (Pre-validation, Create)" -ForegroundColor Green

# PostOperation step — SubtractQuantityPlugin
txc workspace component create pp-plugin-assembly-step `
    --output "src/Solutions.Logic" `
    --param "PrimaryEntity=${PublisherPrefix}_warehousetransaction" `
    --param "PluginProjectName=Plugins.Warehouse" `
    --param "PluginName=SubtractQuantityPlugin" `
    --param "Stage=Post-operation" `
    --param "SdkMessage=Create"


Write-Host "  ✓ Step: SubtractQuantityPlugin (Post-operation, Create)" -ForegroundColor Green