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

dotnet new pp-solution `
    --output "src/Solutions.Logic" `
    --PublisherName $PublisherName `
    --PublisherPrefix $PublisherPrefix `
    --GeneratePluginAssembly "true" `
    --allow-scripts yes

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

# Note: Template post-action scripts use dotnet run --file, which sets the CWD
# to the .template.scripts/ directory instead of the project root. This causes
# generated files to land in .template.scripts/ subdirectories. We suppress
# the template error and relocate the generated files manually.

$ErrorActionPreference = "Continue"

dotnet new pp-plugin-assembly `
    --output "src/Solutions.Logic" `
    --AssemblyId "$assemblyGuid" `
    --PluginProjectRootPath "../../Plugins.Warehouse" `
    --allow-scripts yes 2>&1 | Out-Null

$ErrorActionPreference = "Stop"

# Relocate files from .template.scripts/ to the correct locations
$logicRoot = Resolve-Path "src/Solutions.Logic"
$tsDir = Join-Path $logicRoot ".template.scripts"

# Remove the incorrect PluginAssemblies stub (placed by template before post-action)
$stubPA = Join-Path $logicRoot "PluginAssemblies" "PluginsWarehouse.dll.data.xml"
if (Test-Path $stubPA) {
    Remove-Item $stubPA -Force
}

# Move correctly generated PluginAssemblies from .template.scripts/
$tsPADir = Join-Path $tsDir "PluginAssemblies"
if (Test-Path $tsPADir) {
    Get-ChildItem $tsPADir -Directory | ForEach-Object {
        $destDir = Join-Path $logicRoot "PluginAssemblies" $_.Name
        if (-not (Test-Path $destDir)) {
            New-Item -ItemType Directory -Path $destDir -Force | Out-Null
        }
        Copy-Item (Join-Path $_.FullName "*") $destDir -Force
    }
    Remove-Item $tsPADir -Recurse -Force
}

# Move RootComponent.xml and apply to Solution.xml (remove any existing duplicate)
$tsRootComp = Join-Path $tsDir ".template.temp" "RootComponent.xml"
$solutionXmlPath = Join-Path $logicRoot "Other" "Solution.xml"
if ((Test-Path $tsRootComp) -and (Test-Path $solutionXmlPath)) {
    [xml]$sourceXml = Get-Content $tsRootComp
    [xml]$destinationXml = Get-Content $solutionXmlPath

    # Remove any existing assembly root components (duplicates from template stub)
    $rootComponentsNode = $destinationXml.SelectSingleNode("//RootComponents")
    if ($rootComponentsNode) {
        $existing = $rootComponentsNode.SelectNodes("RootComponent[@type='91']")
        foreach ($node in $existing) {
            $rootComponentsNode.RemoveChild($node) | Out-Null
        }
        $importNode = $destinationXml.ImportNode($sourceXml.DocumentElement, $true)
        $rootComponentsNode.AppendChild($importNode) | Out-Null
        $destinationXml.Save((Resolve-Path $solutionXmlPath).Path)
    }
}

# Clean up template temp/scripts
Remove-Item (Join-Path $logicRoot ".template.temp") -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item (Join-Path $tsDir ".template.temp") -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item $tsDir -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "  ✓ Plugin assembly registered" -ForegroundColor Green

# ──────────────────────────────────────────────────────────────────────────────────────────
#                      SDK Message Processing Steps
# ──────────────────────────────────────────────────────────────────────────────────────────

# Use --allow-scripts no to skip broken post-actions, then handle file placement manually
$destStepsDir = Join-Path $logicRoot "SdkMessageProcessingSteps"
if (-not (Test-Path $destStepsDir)) {
    New-Item -ItemType Directory -Path $destStepsDir -Force | Out-Null
}

# PreValidation step — ValidateWarehouseTransactionPlugin
dotnet new pp-plugin-assembly-step `
    --output "src/Solutions.Logic" `
    --PrimaryEntity "${PublisherPrefix}_warehousetransaction" `
    --PluginProjectName "Plugins.Warehouse" `
    --PluginName "ValidateWarehouseTransactionPlugin" `
    --Stage "Pre-validation" `
    --SdkMessage "Create" `
    --allow-scripts no

# Move generated step XML from .template.temp/ to SdkMessageProcessingSteps/
foreach ($tempDir in @(
    (Join-Path $logicRoot ".template.temp"),
    (Join-Path $logicRoot ".template.scripts" ".template.temp")
)) {
    if (Test-Path $tempDir) {
        Get-ChildItem $tempDir -Filter "*.xml" | ForEach-Object {
            Copy-Item $_.FullName (Join-Path $destStepsDir "{$($_.BaseName)}.xml") -Force
        }
        Remove-Item $tempDir -Recurse -Force
    }
}

Write-Host "  ✓ Step: ValidateWarehouseTransactionPlugin (Pre-validation, Create)" -ForegroundColor Green

# PostOperation step — SubtractQuantityPlugin
dotnet new pp-plugin-assembly-step `
    --output "src/Solutions.Logic" `
    --PrimaryEntity "${PublisherPrefix}_warehousetransaction" `
    --PluginProjectName "Plugins.Warehouse" `
    --PluginName "SubtractQuantityPlugin" `
    --Stage "Post-operation" `
    --SdkMessage "Create" `
    --allow-scripts no `
    --force

# Move generated step XML
foreach ($tempDir in @(
    (Join-Path $logicRoot ".template.temp"),
    (Join-Path $logicRoot ".template.scripts" ".template.temp")
)) {
    if (Test-Path $tempDir) {
        Get-ChildItem $tempDir -Filter "*.xml" | ForEach-Object {
            Copy-Item $_.FullName (Join-Path $destStepsDir "{$($_.BaseName)}.xml") -Force
        }
        Remove-Item $tempDir -Recurse -Force
    }
}

Write-Host "  ✓ Step: SubtractQuantityPlugin (Post-operation, Create)" -ForegroundColor Green

# Add step RootComponents to Solution.xml
$solutionXmlPath = Join-Path $logicRoot "Other" "Solution.xml"
[xml]$destinationXml = Get-Content $solutionXmlPath
$rootComponentsNode = $destinationXml.SelectSingleNode("//RootComponents")

Get-ChildItem $destStepsDir -Filter "*.xml" | ForEach-Object {
    $guidStr = $_.BaseName
    $stepRootComp = $destinationXml.CreateElement("RootComponent")
    $stepRootComp.SetAttribute("type", "92")
    $stepRootComp.SetAttribute("id", $guidStr)
    $stepRootComp.SetAttribute("behavior", "0")
    $rootComponentsNode.AppendChild($stepRootComp) | Out-Null
}

$destinationXml.Save((Resolve-Path $solutionXmlPath).Path)

# Clean up template artifacts
Remove-Item (Join-Path $logicRoot ".template.scripts") -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item (Join-Path $logicRoot ".template.temp") -Recurse -Force -ErrorAction SilentlyContinue
