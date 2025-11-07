@echo off

:: Check for admin privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:menu
cls
color 0F
title Optimizer
echo.
echo.
echo.
echo                                        [+]====================================[+]
echo                                        [+]                                    [+]
echo                                        [+]            Game Utility            [+]
echo                                        [+]       Developed By. PECA3142       [+]
echo                                        [+]                                    [+]
echo                                        [+]====================================[+]
echo. 
echo.
echo.
echo                           [+] 1. FiveM                          [+] 2. Exit
echo.

set /p choice=Enter a number choice: 

if "%choice%"=="1" (
    setlocal enabledelayedexpansion
    set "URL=https://github.com/braden1071/5Ware-Optimizer-Files/raw/refs/heads/main/FiveM_Utility.bat"
    set "FILE=%TEMP%\FiveM_Utility.bat"

    :: Download the batch script
    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
        "try { Invoke-WebRequest -Uri '!URL!' -OutFile '!FILE!' -UseBasicParsing } catch { exit 1 }"

    if not exist "!FILE!" (
        echo Failed to download the script.
        endlocal
        goto menu
    )

    :: Run the downloaded batch script
    call "!FILE!"

    :: Clean up
    if exist "!FILE!" del "!FILE!"
    echo File deleted.
    echo.
    endlocal
    goto menu
)

if "%choice%"=="2" (
    echo Exiting script...
    exit
)
