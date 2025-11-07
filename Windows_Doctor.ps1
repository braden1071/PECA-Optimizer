# Windows Doctor v1.4 – Extended Diagnostics & Safe CHKDSK Scheduling
# Works on Windows 10 and 11. Requires Administrator.

# ----------------- Admin Elevation -----------------
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Restarting script as Administrator..." -ForegroundColor Yellow
    Start-Process powershell.exe "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# ----------------- Logging -----------------
$LogDir  = "$env:ProgramData\Windows_Doctor"
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
$LogFile = Join-Path $LogDir "Windows_Doctor_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
Start-Transcript -Path $LogFile -Append | Out-Null

# Functions
function Info($t){Write-Host "[INFO]  $t" -ForegroundColor Cyan}
function Warn($t){Write-Host "[WARN]  $t" -ForegroundColor Yellow}
function Err($t){Write-Host "[ERROR] $t" -ForegroundColor Red}
function Confirm-Action([string]$Message){
    $a = Read-Host "$Message (Y/N)"
    return $a -match '^[Yy]'
}

Info "===== Windows Doctor Extended Diagnostic Started ====="
Info "Time: $(Get-Date)"
Info "User: $env:USERNAME"
Info "---------------------------------------------"

# ----------------- System File Integrity -----------------
Info "Running System File Checker..."
sfc /scannow | Out-Null
if ($LASTEXITCODE -eq 0){Info "SFC completed successfully."}else{Warn "SFC found issues; details in CBS.log."}

# ----------------- Component Store / Windows Image -----------------
Info "Running DISM image repair..."
DISM /Online /Cleanup-Image /RestoreHealth | Out-Null
if ($LASTEXITCODE -eq 0){Info "DISM completed successfully."}else{Warn "DISM encountered repair issues."}

# ----------------- Network Stack -----------------
Info "Resetting Winsock and TCP/IP..."
netsh winsock reset | Out-Null
netsh int ip reset | Out-Null
Info "Network stack reset."

# ----------------- Windows Update Health -----------------
$WUlogFile = Join-Path $LogDir "WindowsUpdate.log"
Get-WindowsUpdateLog -LogPath $WUlogFile -ErrorAction SilentlyContinue | Out-Null
if ($?) {Info "Windows Update log generated at: $WUlogFile"} else {Warn "Could not generate Windows Update log."}

# ----------------- Service Status -----------------
$Critical = "wuauserv","bits","Winmgmt","EventLog","TrustedInstaller","Dnscache"
foreach($svc in $Critical){
    $s = Get-Service $svc -ErrorAction SilentlyContinue
    if(!$s){Warn "$svc service missing!"}
    elseif($s.Status -ne 'Running'){
        Warn "$svc is stopped; attempting to start..."
        Start-Service $svc -ErrorAction SilentlyContinue
        if((Get-Service $svc).Status -eq 'Running'){Info "$svc started."}else{Err "$svc failed to start."}
    }else{Info "$svc is running."}
}

# ----------------- Safe Advanced Device Repair & Driver Update -----------------
$DoctorPath = "$env:ProgramData\Windows_Doctor"
if (!(Test-Path $DoctorPath)) { New-Item -ItemType Directory -Path $DoctorPath | Out-Null }
$DeviceLogFile = Join-Path $DoctorPath "DeviceRepair.log"

function Log($type, $msg) {
    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    $entry = "[$timestamp][$type] $msg"
    Add-Content -Path $DeviceLogFile -Value $entry
    if ($type -eq "ERROR") { Write-Host $entry -ForegroundColor Red }
    elseif ($type -eq "WARN") { Write-Host $entry -ForegroundColor Yellow }
    elseif ($type -eq "SUCCESS") { Write-Host $entry -ForegroundColor Green }
    else { Write-Host $entry -ForegroundColor Cyan }
}

Info "Checking for problematic devices..."
$bad = Get-PnpDevice | Where-Object { $_.Status -ne "OK" }

$DeepMode = $true   # Deep Mode on by default

if ($bad) {
    Warn "Devices with issues detected:"
    $bad | ForEach-Object { Write-Host " - $($_.FriendlyName) [$($_.Status)]" -ForegroundColor Yellow }
    if ($DeepMode) { Info "Deep Mode enabled — performing complete device repair and driver revalidation." }

    foreach ($dev in $bad) {
        try {
            Log "INFO" "Attempting safe repair for: $($dev.FriendlyName) [$($dev.InstanceId)]"

            # Step 1: Disable / enable (soft reset)
            Disable-PnpDevice -InstanceId $dev.InstanceId -Confirm:$false -ErrorAction SilentlyContinue
            Start-Sleep -Seconds 2
            Enable-PnpDevice -InstanceId $dev.InstanceId -Confirm:$false -ErrorAction SilentlyContinue
            Start-Sleep -Seconds 3

            # Step 2: Recheck status
            $recheck = Get-PnpDevice -InstanceId $dev.InstanceId -ErrorAction SilentlyContinue
            Start-Sleep -Seconds 1
            $recheck = Get-PnpDevice -InstanceId $dev.InstanceId -ErrorAction SilentlyContinue

            if ($recheck.Status -eq "OK") {
                Log "SUCCESS" "Device $($dev.FriendlyName) repaired successfully."
                continue
            }

            # Step 3: Automatic reinstall if still broken
            Log "WARN" "Soft reset failed for $($dev.FriendlyName). Reinstalling driver automatically..."
            pnputil /remove-device "$($dev.InstanceId)" | Out-Null
            Start-Sleep -Seconds 2
            pnputil /scan-devices | Out-Null
            Start-Sleep -Seconds 3

            $recheck = Get-PnpDevice -InstanceId $dev.InstanceId -ErrorAction SilentlyContinue
            Start-Sleep -Seconds 1
            if ($recheck.Status -eq "OK") {
                Log "SUCCESS" "Device $($dev.FriendlyName) repaired after reinstall."
                continue
            }

            # Step 4: Deep Mode extended recheck
            if ($DeepMode) {
                Log "INFO" "Deep Mode: Running extended driver recheck and dependency fix..."
                try { pnputil /enum-drivers | Out-Null; pnputil /scan-devices | Out-Null; Start-Sleep -Seconds 2 }
                catch { Log "WARN" "Deep mode extended scan error: $_" }
            }

            # Step 5: Windows Update driver attempt
            Log "WARN" "Device still reports issues. Attempting driver update via Windows Update..."
            try {
                if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
                    Log "INFO" "Installing PSWindowsUpdate module..."
                    Install-PackageProvider -Name NuGet -Force -Confirm:$false | Out-Null
                    Install-Module -Name PSWindowsUpdate -Force -Confirm:$false | Out-Null
                }
                Import-Module PSWindowsUpdate -ErrorAction SilentlyContinue
                Log "INFO" "Scanning for driver updates..."
                Get-WindowsUpdate -MicrosoftUpdate -AcceptAll -Install -IgnoreReboot -ErrorAction SilentlyContinue | Out-Null
                Log "INFO" "Driver update scan completed."
            } catch { Log "WARN" "Unable to query Windows Update: $_" }

            # Step 6: Final verification
            $recheck = Get-PnpDevice -InstanceId $dev.InstanceId -ErrorAction SilentlyContinue
            Start-Sleep -Seconds 1
            if ($recheck.Status -eq "OK") {
                Log "SUCCESS" "Device $($dev.FriendlyName) fixed after Windows Update repair."
            } else {
                Log "WARN" "Device $($dev.FriendlyName) still reports an issue."
            }

        } catch {
            Log "ERROR" "Repair failed for $($dev.FriendlyName): $_"
        }
    }

    Log "INFO" "Device repair and update routine complete. Reboot recommended."
} else {
    Log "INFO" "All devices report OK."
}

Write-Host ""
Write-Host "Detailed device repair log saved at: $DeviceLogFile" -ForegroundColor Cyan

# ----------------- WMI Repository -----------------
Info "Checking WMI repository consistency..."
if ((winmgmt /verifyrepository) -match "inconsistent"){
    Warn "WMI repository inconsistent; rebuilding..."
    winmgmt /salvagerepository | Out-Null
}else{Info "WMI repository is consistent."}

# ----------------- Event Log Scan (recent errors) -----------------
Info "Scanning System and Application logs for recent critical errors..."
$RecentErrors = @()
$RecentErrors += Get-WinEvent -FilterHashtable @{LogName='System'; Level=1; StartTime=(Get-Date).AddDays(-1)} -ErrorAction SilentlyContinue
$RecentErrors += Get-WinEvent -FilterHashtable @{LogName='Application'; Level=1; StartTime=(Get-Date).AddDays(-1)} -ErrorAction SilentlyContinue

if($RecentErrors.Count -gt 0){
    Warn "Recent critical events detected:"
    $RecentErrors | Select TimeCreated,Id,ProviderName,Message | Format-Table -AutoSize
}else{Info "No critical events in the last 24 hours."}

# ----------------- Disk & File System -----------------
if (Confirm-Action "Schedule CHKDSK on C: for next reboot?") {
    Info "Scheduling CHKDSK automatically..."
    cmd /c "chkntfs /C C:" | Out-Null
    cmd /c "fsutil dirty set C:" | Out-Null
    Info "CHKDSK scheduled for next reboot (no blocking)."
}else{
    Info "Skipping disk check scheduling."
}

# ----------------- System Resources -----------------
Info "Checking system resource usage..."
Get-Process | Sort-Object -Descending CPU | Select -First 5 Name,CPU | Format-Table
Get-PSDrive C | ForEach-Object {
    $pctFree = ($_.Free/($_.Used + $_.Free))*100
    Info ("Drive {0}: {1:N2}% free" -f $_.Name, $pctFree)
}

# ----------------- Temp Cleanup -----------------
Info "Cleaning temporary files..."
Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
Info "Temporary files removed."

# ----------------- Completion -----------------
Info "Diagnostics complete. Log saved to: $LogFile"
Stop-Transcript | Out-Null
if (Test-Path $LogFile){
    Write-Host "Opening main log in Notepad..." -ForegroundColor Green
    Start-Process notepad.exe $LogFile
}
Write-Host ""
Start-Sleep -Seconds 2