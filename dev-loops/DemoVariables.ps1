# Shared store
$DemoVarsFile = ".demo/variables.json"

function Import-DemoVariables {
    if (Test-Path $DemoVarsFile) {
        try {
            $data = Get-Content -Raw -Path $DemoVarsFile | ConvertFrom-Json -AsHashtable
            foreach ($k in $data.Keys) { Set-Variable -Scope Global -Name $k -Value $data[$k] -Force }
        } catch { Write-Warning "Import failed: $($_.Exception.Message)" }
    }
}

function Save-DemoVariables {
    [CmdletBinding()]
    param(
        # Exact variable names to save, e.g. -Names randomIdentifier,devEnvDomain
        [string[]] $Names,
        # Wildcard patterns to include, e.g. -IncludeLike '*Env*','ado*'
        [string[]] $IncludeLike,
        # Wildcard patterns to exclude (applies after Names/IncludeLike/default filter)
        [string[]] $ExcludeLike
    )

    # Load existing to merge (keep keys from other scripts)
    $store = @{}
    if (Test-Path $DemoVarsFile) {
        try { $store = Get-Content -Raw -Path $DemoVarsFile | ConvertFrom-Json -AsHashtable } catch { $store = @{} }
    }

    # Default skip of PowerShell/system vars
    $skip = @(
        'PS*','*Preference','PSScriptRoot','Pwd','HOME','Host','ExecutionContext','MyInvocation',
        'Error','Args','true','false','null','PID','PSVersionTable','DemoVarsFile'
    )

    $vars = Get-Variable -Scope Global

    # If -Names provided: exact match only
    if ($Names) {
        $vars = $vars | Where-Object { $Names -contains $_.Name }
    }
    # Else if -IncludeLike provided: match any wildcard
    elseif ($IncludeLike) {
        $vars = $vars | Where-Object {
            $n = $_.Name
            ($IncludeLike | Where-Object { $n -like $_ } | Select-Object -First 1)
        }
    }
    # Else: default = keep non-internal variables using skip list
    else {
        $vars = $vars | Where-Object {
            $n = $_.Name
            -not ($skip | Where-Object { $n -like $_ } | Select-Object -First 1)
        }
    }

    # Apply optional exclusions
    if ($ExcludeLike) {
        $vars = $vars | Where-Object {
            $n = $_.Name
            -not ($ExcludeLike | Where-Object { $n -like $_ } | Select-Object -First 1)
        }
    }

    # Skip read-only/constant items
    $vars = $vars | Where-Object {
        -not ( $_.Options -band [System.Management.Automation.ScopedItemOptions]::ReadOnly ) -and
        -not ( $_.Options -band [System.Management.Automation.ScopedItemOptions]::Constant )
    }

    foreach ($v in $vars) { $store[$v.Name] = $v.Value }

    try { $store | ConvertTo-Json -Depth 10 | Set-Content -Path $DemoVarsFile -Encoding UTF8 }
    catch { Write-Warning "Save failed: $($_.Exception.Message)" }
}

# Auto-load on dot-source
Import-DemoVariables
