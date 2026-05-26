#
# ╔════════════════════════════════════════════════════════════════════════════════════════╗
# ║                  07: Plugins — Plugin Project and Plugin Classes                       ║
# ╚════════════════════════════════════════════════════════════════════════════════════════╝
#
# Creates the Plugins.Warehouse project with signing key and two plugin classes:
# - ValidateWarehouseTransactionPlugin (PreValidation on Create)
# - SubtractQuantityPlugin (PostOperation on Create)
#
# Expects: $PublisherName, $PublisherPrefix, $SolutionName from parent scope.
#
# ──────────────────────────────────────────────────────────────────────────────────────────
#                              Signing Key Generation
# ──────────────────────────────────────────────────────────────────────────────────────────

Write-Host "`n── Plugins.Warehouse ──" -ForegroundColor Cyan

if (-not (Test-Path "src/Plugins.Warehouse")) {
    New-Item -ItemType Directory -Path "src/Plugins.Warehouse" -Force | Out-Null
}

# Generate signing key using RSACryptoServiceProvider (cross-platform)
$keyFile = "src/Plugins.Warehouse/PluginKey.snk"
if (-not (Test-Path $keyFile)) {
    $rsa = New-Object System.Security.Cryptography.RSACryptoServiceProvider 2048
    try {
        $rsa.PersistKeyInCsp = $false
        $blob = $rsa.ExportCspBlob($true)
        [System.IO.File]::WriteAllBytes((Join-Path (Get-Location).Path $keyFile), $blob)
        Write-Host "  ✓ PluginKey.snk generated" -ForegroundColor Green
    }
    finally {
        $rsa.Dispose()
    }
}

# ──────────────────────────────────────────────────────────────────────────────────────────
#                              Plugin Project
# ──────────────────────────────────────────────────────────────────────────────────────────

dotnet new pp-plugin `
    --output "src/Plugins.Warehouse" `
    --PublisherName $PublisherName `
    --SigningKeyFilePath "PluginKey.snk" `
    --Company $PublisherName `
    --allow-scripts yes

dotnet sln add src/Plugins.Warehouse

Write-Host "  ✓ Plugins.Warehouse project" -ForegroundColor Green

# ──────────────────────────────────────────────────────────────────────────────────────────
#                         ValidateWarehouseTransactionPlugin.cs
# ──────────────────────────────────────────────────────────────────────────────────────────

$prefix = $PublisherPrefix
$validatePlugin = @"
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Query;
using System;

namespace Plugins.Warehouse
{
    public class ValidateWarehouseTransactionPlugin : PluginBase
    {
        public ValidateWarehouseTransactionPlugin(string unsecureConfiguration, string secureConfiguration)
            : base(typeof(ValidateWarehouseTransactionPlugin))
        {
        }

        protected override void ExecuteDataversePlugin(ILocalPluginContext localPluginContext)
        {
            if (localPluginContext == null)
            {
                throw new ArgumentNullException(nameof(localPluginContext));
            }

            var context = localPluginContext.PluginExecutionContext;
            var serviceFactory = localPluginContext.OrgSvcFactory;
            var service = serviceFactory.CreateOrganizationService(context.UserId);
            var tracingService = localPluginContext.TracingService;

            if (!(context.InputParameters.Contains("Target") && context.InputParameters["Target"] is Entity target) || target.LogicalName != "${prefix}_warehousetransaction")
                return;

            if (!target.Contains("${prefix}_quantity") || !target.Contains("${prefix}_itemid"))
                return;

            try
            {
                var quantity = (int)target["${prefix}_quantity"];
                var itemRef = (EntityReference)target["${prefix}_itemid"];

                var item = service.Retrieve("${prefix}_warehouseitem", itemRef.Id, new ColumnSet("${prefix}_availablequantity"));

                int available = 0;
                if (item != null && item.Contains("${prefix}_availablequantity"))
                {
                    available = (int)item["${prefix}_availablequantity"];
                }

                if (quantity > available)
                {
                    throw new InvalidPluginExecutionException(
                        `$"Not enough product in stock. Available: {available}, requested: {quantity}.");
                }
            }
            catch (InvalidPluginExecutionException)
            {
                throw;
            }
            catch (Exception ex)
            {
                tracingService.Trace("Plugin Exception: {0}", ex.ToString());
                throw;
            }
        }
    }
}
"@

Set-Content -Path "src/Plugins.Warehouse/ValidateWarehouseTransactionPlugin.cs" -Value $validatePlugin -Encoding UTF8
Write-Host "  ✓ ValidateWarehouseTransactionPlugin.cs" -ForegroundColor Green

# ──────────────────────────────────────────────────────────────────────────────────────────
#                            SubtractQuantityPlugin.cs
# ──────────────────────────────────────────────────────────────────────────────────────────

$subtractPlugin = @"
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Query;
using System;

namespace Plugins.Warehouse
{
    public class SubtractQuantityPlugin : PluginBase
    {
        public SubtractQuantityPlugin(string unsecureConfiguration, string secureConfiguration)
            : base(typeof(SubtractQuantityPlugin))
        {
        }

        protected override void ExecuteDataversePlugin(ILocalPluginContext localPluginContext)
        {
            if (localPluginContext == null)
            {
                throw new ArgumentNullException(nameof(localPluginContext));
            }

            var context = localPluginContext.PluginExecutionContext;
            var serviceFactory = localPluginContext.OrgSvcFactory;
            var service = serviceFactory.CreateOrganizationService(context.UserId);

            if (!(context.InputParameters["Target"] is Entity target) || target.LogicalName != "${prefix}_warehousetransaction")
                return;

            if (!target.Contains("${prefix}_quantity") || !target.Contains("${prefix}_itemid"))
                return;

            var quantity = (int)target["${prefix}_quantity"];
            var itemRef = (EntityReference)target["${prefix}_itemid"];

            var item = service.Retrieve("${prefix}_warehouseitem", itemRef.Id, new ColumnSet("${prefix}_availablequantity"));
            var available = (int)item["${prefix}_availablequantity"];

            item["${prefix}_availablequantity"] = available - quantity;
            service.Update(item);
        }
    }
}
"@

Set-Content -Path "src/Plugins.Warehouse/SubtractQuantityPlugin.cs" -Value $subtractPlugin -Encoding UTF8
Write-Host "  ✓ SubtractQuantityPlugin.cs" -ForegroundColor Green

# ──────────────────────────────────────────────────────────────────────────────────────────
#                              Build Plugin Project
# ──────────────────────────────────────────────────────────────────────────────────────────

Write-Host "  → Building Plugins.Warehouse..." -ForegroundColor White
cd src/Plugins.Warehouse
dotnet build --nologo --verbosity quiet
if ($LASTEXITCODE -eq 0) {
    Write-Host "  ✓ Plugin build succeeded" -ForegroundColor Green
} else {
    Write-Host "  ⚠ Plugin build had issues (exit code: $LASTEXITCODE)" -ForegroundColor Yellow
}

dotnet publish --nologo --verbosity quiet
if ($LASTEXITCODE -eq 0) {
    Write-Host "  ✓ Plugin publish succeeded" -ForegroundColor Green
} else {
    Write-Host "  ⚠ Plugin publish had issues (exit code: $LASTEXITCODE)" -ForegroundColor Yellow
}
cd ../..
