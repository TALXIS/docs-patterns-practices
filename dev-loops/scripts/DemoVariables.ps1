# Shared store
$DemoVarsFile = ".demo/variables.json"

# --- Compatibility: convert PSCustomObject -> Hashtable (works on PS 5.1 and 7+) ---
function ConvertTo-Hashtable {
    param([Parameter(Mandatory)][object] $InputObject)

    if ($null -eq $InputObject) { return $null }

    if ($InputObject -is [System.Collections.IDictionary]) { return $InputObject }

    if ($InputObject -is [System.Collections.IEnumerable] -and -not ($InputObject -is [string])) {
        $list = @()
        foreach ($item in $InputObject) { $list += (ConvertTo-Hashtable -InputObject $item) }
        return ,$list
    }

    if ($InputObject -is [pscustomobject]) {
        $h = @{}
        foreach ($p in $InputObject.PSObject.Properties) {
            $h[$p.Name] = ConvertTo-Hashtable -InputObject $p.Value
        }
        return $h
    }

    return $InputObject
}

function Import-DemoVariables {
    if (Test-Path $DemoVarsFile) {
        try {
            $raw = Get-Content -Raw -Path $DemoVarsFile
            $data = $null
            # Use -AsHashtable if supported, else fall back
            if ((Get-Command ConvertFrom-Json).Parameters.ContainsKey('AsHashtable')) {
                $data = ConvertFrom-Json -InputObject $raw -AsHashtable
            } else {
                $data = ConvertTo-Hashtable (ConvertFrom-Json -InputObject $raw)
            }
            foreach ($k in $data.Keys) { Set-Variable -Scope Global -Name $k -Value $data[$k] -Force }
        } catch { Write-Warning "Import failed: $($_.Exception.Message)" }
    }
}

function Save-DemoVariables {
    [CmdletBinding()]
    param(
        [string[]] $Names,        # e.g. -Names randomIdentifier,devEnvDomain
        [string[]] $IncludeLike,  # e.g. -IncludeLike '*Env*','ado*'
        [string[]] $ExcludeLike   # e.g. -ExcludeLike '*Secret*'
    )

    # Load existing store for merge
    $store = @{}
    if (Test-Path $DemoVarsFile) {
        try {
            $raw = Get-Content -Raw -Path $DemoVarsFile
            if ((Get-Command ConvertFrom-Json).Parameters.ContainsKey('AsHashtable')) {
                $store = ConvertFrom-Json -InputObject $raw -AsHashtable
            } else {
                $store = ConvertTo-Hashtable (ConvertFrom-Json -InputObject $raw)
            }
        } catch { $store = @{} }
    }

    # Default skip of PowerShell/system vars
    $skip = @(
        'PS*','*Preference','PSScriptRoot','Pwd','HOME','Host','ExecutionContext','MyInvocation',
        'Error','Args','true','false','null','PID','PSVersionTable','DemoVarsFile'
    )

    $vars = Get-Variable -Scope Global

    if ($Names) {
        $vars = $vars | Where-Object { $Names -contains $_.Name }
    } elseif ($IncludeLike) {
        $vars = $vars | Where-Object {
            $n = $_.Name
            ($IncludeLike | Where-Object { $n -like $_ } | Select-Object -First 1)
        }
    } else {
        $vars = $vars | Where-Object {
            $n = $_.Name
            -not ($skip | Where-Object { $n -like $_ } | Select-Object -First 1)
        }
    }

    if ($ExcludeLike) {
        $vars = $vars | Where-Object {
            $n = $_.Name
            -not ($ExcludeLike | Where-Object { $n -like $_ } | Select-Object -First 1)
        }
    }

    # Skip read-only/constant
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
