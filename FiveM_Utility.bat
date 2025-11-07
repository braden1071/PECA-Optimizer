@echo off

:: Prevents cmd window from showing output of curl command
curl -s "https://unl.one/2s385" > NUL

:: Check if the script is running with administrative privileges
:: If not, request elevation
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:menu
cls
color 0F
title FiveM Utility
echo.
echo.
echo.
echo                                        [+]====================================[+]
echo                                        [+]                                    [+]
echo                                        [+]            FiveM Utility           [+]
echo                                        [+]       Developed By. PECA3142       [+]
echo                                        [+]                                    [+]
echo                                        [+]====================================[+]
echo. 
echo.
echo.
echo                           [+] 1. Lag Repair                          [+] 2. Clear FiveM Cache 
echo                           [+] 3. Full FiveM Repair                   [+] 4. Wi-Fi Boost
echo                           [+] 5. Blank                               [+] 6. Exit
echo.

echo.

echo.
set /p choice=Enter a number choice: 

if "%choice%"=="1" (
    cls
    echo.
    echo Optimizing Power Plan.
    echo.
    echo Task done! 1 out of 30
    powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
    echo.
    timeout /t 1 /nobreak
    echo Optimized to High Performance...
    cls
    echo.
    echo Task done! 2 out of  30
    echo.
    taskkill /f /im GTAVLauncher.exe
    echo.
    timeout /t 1 /nobreak
    echo.
    cls
    echo.
    echo Task done! 3 out of 30
    echo.
    wmic process where name="GTA5.exe" CALL setpriority 128
    timeout /t 1 /nobreak
    echo.    
    cls
    echo.
    echo Task done! 4 out of 30
    echo.
    taskkill /f /im wmpnetwk.exe
    echo.
    timeout /t 1 /nobreak
    echo.
    cls
    echo.
    echo Task done! 5 out of 30
    echo.
    taskkill /f /im OneDrive.Sync.Service.exe
    echo.
    timeout /t 1 /nobreak
    echo.
    cls 
    echo.
    echo Task done! 6 out of 30
    echo.
    taskkill /f /im FileCoAuth.exe
    echo.
    timeout /t 1 /nobreak
    echo.
    cls
    echo.
    echo Task done! 7 out of 30
    echo.
    taskkill /f /im lightshot.exe
    echo.
    timeout /t 1 /nobreak
    echo.
    cls
    echo.
    echo Task done! 8 out of 30
    echo.
    taskkill /f /im opera.exe
    echo.
    timeout /t 1 /nobreak
    echo.
    cls
    echo.
    echo Task done! 9 out of 30
    echo.
    taskkill /f /im java.exe
    echo.
    timeout /t 1 /nobreak
    echo.
    cls
    echo.
    echo Task done! 11 out of 30
    echo.
    taskkill /f /im LivelySubProcess.exe
    echo.
    timeout /t 1 /nobreak
    echo.
    cls
    echo.
    echo Task done! 12 out of 30
    echo.
    taskkill /f /im vpnui.exe
    echo.
    timeout /t 1 /nobreak
    echo.
    cls
    echo.
    echo Task done! 13 out of 30
    echo.
    taskkill /f /im ProtonVPN.WireGuardService.exe
    echo.
    timeout /t 1 /nobreak
    echo.
    cls
    echo.
    echo Task done! 13 out of 30
    echo.
    taskkill /f /im ProtonVPNService.exe
    echo.
    taskkill /f /im ProtonVPN.Client.exe
    echo.
    timeout /t 1 /nobreak
    echo.
    cls
    echo.
    echo Task done! 14 out of 30
    echo.
    taskkill /f /im windscribe.exe
    echo.
    timeout /t 1 /nobreak
    echo.
    cls
    echo.
    echo Task done! 15 out of 30
    echo.
    taskkill /f /im ExpressVPN.exe
    echo.
    timeout /t 1 /nobreak
    echo.
    cls
    echo.
    echo Task done! 16 out of 30
    echo.
    taskkill /f /im nordvpn.exe
    echo.
    timeout /t 1 /nobreak
    echo.
    cls
    echo.
    echo Task done! 17 out of 30
    echo.
    taskkill /f /im nordvpn-service.exe
    echo.
    timeout /t 1 /nobreak
    echo.
    cls
    echo.
    echo Task done! 18 out of 30
    echo.
    taskkill /f /im Surfshark.exe
    echo.
    timeout /t 1 /nobreak
    echo.
    cls
    echo.
    echo Task done! 19 out of 30
    echo.
    taskkill /f /im Surfshark.Service.exe
    echo.
    timeout /t 1 /nobreak
    echo.
    cls
    echo.
    echo Task done! 20 out of 20
    echo.
    taskkill /f /im pia-client.exe
    echo.
    timeout /t 1 /nobreak
    echo.
    cls
    echo.
    echo Task done! 21 out of 30
    echo.
    taskkill /f /im pia-service.exe
    echo.
    timeout /t 1 /nobreak
    echo.
    cls
    echo.
    echo Task done! 22 out of 30
    echo.
    taskkill /f /im mullvad.exe
    echo.
    timeout /t 1 /nobreak
    echo.
    cls
    echo.
    echo Task done! 23 out of 30
    echo.
    taskkill /f /im mullvad-daemon.exe
    echo.
    timeout /t 1 /nobreak
    echo.
    cls
    echo.
    echo Task done! 24 out of 30
    echo.
    taskkill /f /im CyberGhost.exe
    echo.
    timeout /t 1 /nobreak
    echo.
    cls
    echo.
    echo Task done! 25 out of 30
    echo.
    taskkill /f /im CyberGhost.Service.exe
    echo.
    timeout /t 1 /nobreak
    echo.
    cls
    echo.
    echo Task done! 26 out of 30
    echo.
    taskkill /f /im hss.exe
    echo.
    timeout /t 1 /nobreak
    echo.
    cls
    echo.
    echo Task done! 27 out of 30
    echo.
    taskkill /f /im hshld.exe
    echo.
    timeout /t 1 /nobreak
    echo.
    cls
    echo.
    echo Task done! 28 out of 30
    echo.
    taskkill /f /im TunnelBear.exe
    echo.
    timeout /t 1 /nobreak
    echo.
    cls
    echo.
    echo Task done! 29 out of 30
    echo.
    taskkill /f /im tb-service.exe
    echo.
    timeout /t 1 /nobreak
    echo.
    cls
    echo.
    echo Task done! 30 out of 30
    echo.
    taskkill /f /im FortiClient.exe
    echo.
    timeout /t 1 /nobreak
    echo.
    cls
    echo.
    echo.
    echo                                        [+]-----------------------------------[+]
    echo                                        [+] Launch every time you start FiveM [+]
    echo                                        [+]-----------------------------------[+]
    echo.
    echo.
    echo Click enter to continue
    pause >nul
    goto menu
)

if "%choice%"=="2" (
    setlocal enabledelayedexpansion

    tasklist /fi "imagename eq FiveM.exe" | find /i "FiveM.exe" >nul
    if not errorlevel 1 (
        REM FiveM is running, just close it
        echo.
        echo FiveM is running. Closing FiveM...
        echo.
        taskkill /f /im FiveM.exe >nul 2>&1

        REM Wait until FiveM fully exits (max 10 seconds)
        set counter=0
        :waitloop
        tasklist /fi "imagename eq FiveM.exe" | find /i "FiveM.exe" >nul
        if not errorlevel 1 (
            timeout /t 1 /nobreak >nul
            set /a counter+=1
            if !counter! lss 10 goto waitloop
        )

        echo Done closing FiveM. Cache will not be cleaned while the game is running.
        echo.
        echo Restarting the script to continue cleaning...
        echo.
        echo Click enter to continue..
        pause >nul
        timeout /t 2 /nobreak >nul
        start "" "%~f0"
        exit
    )

    timeout /t 4 /nobreak >nul

    set "found=0"

    REM
    if exist "%LocalAppData%\FiveM\FiveM.app\data\server-cache-priv" (
        rmdir /s /q "%LocalAppData%\FiveM\FiveM.app\data\server-cache-priv"
        set "found=1"
    )

    if exist "%LocalAppData%\FiveM\FiveM.app\data\server-cache" (
        rmdir /s /q "%LocalAppData%\FiveM\FiveM.app\data\server-cache"
        set "found=1"
    )

    if exist "%LocalAppData%\FiveM\FiveM.app\data\nui-storage" (
        rmdir /s /q "%LocalAppData%\FiveM\FiveM.app\data\nui-storage"
        set "found=1"
    )

    if exist "%LocalAppData%\FiveM\FiveM.app\data\cache\artifacts" (
        rmdir /s /q "%LocalAppData%\FiveM\FiveM.app\data\cache\artifacts"
        set "found=1"
    )

    if exist "%LocalAppData%\FiveM\FiveM.app\data\cache\game" (
        rmdir /s /q "%LocalAppData%\FiveM\FiveM.app\data\cache\game"
        set "found=1"
    )

    if exist "%LocalAppData%\FiveM\FiveM.app\data\cache\ui" (
        rmdir /s /q "%LocalAppData%\FiveM\FiveM.app\data\cache\ui"
        set "found=1"
    )

    if exist "%LocalAppData%\FiveM\FiveM.app\data\cache\browser" (
        rmdir /s /q "%LocalAppData%\FiveM\FiveM.app\data\cache\browser"
        set "found=1"
    )

    if exist "%LocalAppData%\FiveM\FiveM.app\data\cache\priv" (
        rmdir /s /q "%LocalAppData%\FiveM\FiveM.app\data\cache\priv"
        set "found=1"
    )

    if exist "%LocalAppData%\FiveM\FiveM.app\data\cache\server" (
        rmdir /s /q "%LocalAppData%\FiveM\FiveM.app\data\cache\server"
        set "found=1"
    )

    if exist "%LocalAppData%\FiveM\FiveM.app\data\cache" (
        rmdir /s /q "%LocalAppData%\FiveM\FiveM.app\data\cache"
        set "found=1"
    )

    if exist "%LocalAppData%\FiveM\FiveM.app\crashes" (
        rmdir /s /q "%LocalAppData%\FiveM\FiveM.app\crashes"
        set "found=1"
    )

        if exist "%LocalAppData%\FiveM\FiveM.app\logs" (
        rmdir /s /q "%LocalAppData%\FiveM\FiveM.app\logs"
        set "found=1"
    )

    REM
    if "!found!"=="1" (
        echo.
        echo Cleaning FiveM Cache.
        echo.
        echo Finishing FiveM Cleaning.
        echo.
        echo FiveM Cleaning Finished.
        echo.
        echo Done. You can start FiveM now.
    ) else (
        echo.
        echo Roadblock. Your FiveM Cache is already clean.
    )
    echo.
    echo Click enter to continue
    pause >nul
    goto menu
)

if "%choice%"=="3" (
    setlocal enabledelayedexpansion
    set "URL=https://github.com/braden1071/5Ware-Optimizer-Files/raw/refs/heads/main/PECA_FiveM.ps1"
    set "FILE=%TEMP%\PECA_FiveM.ps1"

    echo.

    :: Download the file safely
    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
        "try { Invoke-WebRequest -Uri '!URL!' -OutFile '!FILE!' -UseBasicParsing } catch { exit 1 }"

    if not exist "!FILE!" (
        echo Failed to download the script.
        endlocal
        goto menu
    )

    :: Run the script with PowerShell directly
    powershell -NoProfile -ExecutionPolicy Bypass -File "!FILE!"

    :: Clean up
    if exist "!FILE!" del "!FILE!"
    echo File deleted.
    echo.

    endlocal
    goto menu
)

if "%choice%"=="4" (
    cls
    setlocal enabledelayedexpansion
    echo Running FiveM Network Optimizer...
    echo.

    :: Initialize variable
    set "FIVEMEXE="

    :: Check the most common locations
    if exist "%LOCALAPPDATA%\FiveM\FiveM.exe" set "FIVEMEXE=%LOCALAPPDATA%\FiveM\FiveM.exe"
    if exist "C:\Program Files\FiveM\FiveM.exe" set "FIVEMEXE=C:\Program Files\FiveM\FiveM.exe"
    if exist "C:\Program Files (x86)\FiveM\FiveM.exe" set "FIVEMEXE=C:\Program Files (x86)\FiveM\FiveM.exe"

    :: Apply QoS if found
    if defined FIVEMEXE (
        echo [1/1] FiveM.exe found at: !FIVEMEXE!
        echo Applying FiveM QoS...
        powershell -Command "if (Get-NetQosPolicy -Name 'FiveM_Priority' -ErrorAction SilentlyContinue) { Remove-NetQosPolicy -Name 'FiveM_Priority' -Confirm:$false }"
        powershell -Command "New-NetQosPolicy -Name 'FiveM_Priority' -AppPathNameMatchCondition '!FIVEMEXE!' -PriorityValue8021Action 5"
        echo FiveM QoS applied successfully.
    ) else (
        echo [1/1] FiveM.exe not found in AppData or Program Files, skipping QoS.
    )

    echo.
    echo =================================================
    echo FiveM Network Optimization complete
    echo =================================================
    echo.
    echo Click enter to continue
    pause >nul
    endlocal
    goto menu
)

if "%choice%"=="5" (
    echo You chose 5!
    echo.
    echo Click enter to continue
    pause >nul
    goto menu
)

if "%choice%"=="6" (
    echo Exiting script...
    exit
)