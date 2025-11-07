<#
.SYNOPSIS
FixFiveM_Client_Tool_Hybrid.ps1
Balanced maintenance tool for FiveM — deep clean without redownloading.
#>

[CmdletBinding()]
param(
    [switch]$Quiet
)

# --- Run as Administrator ---
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell "-ExecutionPolicy Bypass -File `"$PSCommandPath`" $($args -join ' ')" -Verb RunAs
    exit
}

function Write-Info($msg) {
    if (-not $Quiet) { Write-Host "[*] $msg" }
}

function Safe-Delete($path) {
    if (Test-Path $path) {
        try {
            Remove-Item -LiteralPath $path -Recurse -Force -ErrorAction Stop
            Write-Info "Deleted: $path"
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Could not delete: $path`n$($_.Exception.Message)", "FixFiveM Error", 'OK', 'Warning')
        }
    }
}

Add-Type -AssemblyName System.Windows.Forms
Write-Info "Starting FixFiveM Hybrid Tool..."

# --- Close FiveM ---
Get-Process -Name "FiveM" -ErrorAction SilentlyContinue | ForEach-Object { $_.Kill() }
Start-Sleep -Seconds 2

# --- Paths ---
$FIVEM_APP = Join-Path $env:LOCALAPPDATA "FiveM\FiveM.app"
$CACHE = Join-Path $FIVEM_APP "cache"

if (-not (Test-Path $FIVEM_APP)) {
    [System.Windows.Forms.MessageBox]::Show("FiveM folder not found at $FIVEM_APP.`nMake sure FiveM is installed.", "FixFiveM Error", 'OK', 'Warning')
    exit
} else {
    Write-Info "FiveM found at: $FIVEM_APP"
}

Start-Sleep -Seconds 2

# --- Clean cache (keep game folder) ---
if (Test-Path $CACHE) {
    Write-Info "Cleaning cache..."
    Get-ChildItem -LiteralPath $CACHE -Force | ForEach-Object {
        if ($_.PSIsContainer -and ($_.Name -ieq "game")) {
            Write-Info "Skipping 'game' folder (keep core data)."
        } else {
            Safe-Delete $_.FullName
        }
    }
}

Start-Sleep -Seconds 2

# --- Clean logs, crashes, server cache ---
$stalePaths = @(
    Join-Path $FIVEM_APP "logs"
    Join-Path $FIVEM_APP "crashes"
    Join-Path $FIVEM_APP "data\cache"
    Join-Path $FIVEM_APP "data\server-cache"
    Join-Path $FIVEM_APP "data\server-cache-priv"
)
$stalePaths | ForEach-Object { Safe-Delete $_ }

Start-Sleep -Seconds 2

# --- Clean Windows temp junk related to FiveM ---
$TEMP_FIVEM = Join-Path $env:TEMP "CitizenFX"
if (Test-Path $TEMP_FIVEM) {
    Safe-Delete $TEMP_FIVEM
}

Start-Sleep -Seconds 2

# --- Networking ---
Write-Info "Flushing DNS..."
ipconfig /flushdns | Out-Null

Start-Sleep -Seconds 2

Write-Info "Resetting Winsock..."
try {
    netsh winsock reset | Out-Null
} catch {
    [System.Windows.Forms.MessageBox]::Show("Could not reset Winsock automatically.`nTry running this script as Administrator.", "Error", 'OK', 'Warning')
}

Start-Sleep -Seconds 2

# --- CPU Power Plan Normalization ---
Write-Info "Normalizing CPU power settings..."
$SUB_PROCESSOR   = "54533251-82be-4824-96c1-47b60b740d00"
$PROC_MIN        = "893dee8e-2bef-41e0-89c6-b55d0929964c"
$PROC_MAX        = "bc5038f7-23e0-4960-96da-33abaf5935ec"

powercfg -setacvalueindex scheme_current $SUB_PROCESSOR $PROC_MIN 0 | Out-Null
powercfg -setacvalueindex scheme_current $SUB_PROCESSOR $PROC_MAX 100 | Out-Null
powercfg -setdcvalueindex scheme_current $SUB_PROCESSOR $PROC_MIN 0 | Out-Null
powercfg -setdcvalueindex scheme_current $SUB_PROCESSOR $PROC_MAX 100 | Out-Null
powercfg -S scheme_current | Out-Null
Write-Info "CPU min/max restored on current plan."

[System.Windows.Forms.MessageBox]::Show("Operation Completed! Reboot if Winsock reset was done and issues persist.", "By. PECA3142", 'OK', 'Information')