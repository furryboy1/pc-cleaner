@echo off
cls

:: --- Initialization ----
title PC Cleaner - Loading... - https://github.com/FurryBoyYT/pc-cleaner

echo [1;33mWARNING! The code was rewritten with some new paths as of April 5, 2025 and hasn't been tested.
echo [1;33mUse at your own risk and report any issues on the GitHub issues page if there are any within the script.
echo [1;32m^-^-^-^> [4;34m[1;36mhttps://github.com/FurryBoyYT/pc-cleaner/issues[0m [1;32m^<^-^-^-
set /p userInput=[1;33mType "I agree" to continue: [0m
if /i not "%userInput%"=="i agree" (
    echo [1;31mYou did not agree. Exiting in 3 seconds...[0m
    timeout /t 3 >nul
    exit /b
)
echo [1;32mNow continuing with the script, [1;33myou have been warned.[0m

setlocal enabledelayedexpansion
:: Admin Check with better elevation handling
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [1;33m[!] Administrative privileges required![0m
    echo [0;36m[~] Restarting with elevated permissions...[0m
    timeout /t 2 >nul
    powershell -Command "Start-Process '%~0' -Verb RunAs" >nul 2>&1
    exit /b
)

:admin
cls
echo [1;32m[✓] Running with administrative privileges[0m

:: --- Restore Point Creation ----
echo [1;36m[~] Creating system restore point...[0m

set "restore_enabled=false"
for /f "tokens=2 delims== " %%G in ('wmic volume where "driveletter='C:'" get automount 2^>nul') do (
    if /i "%%G"=="FALSE" (
        wmic /namespace:\\root\default path SystemRestore call Enable "C:" >nul 2>&1
        set "restore_enabled=true"
    )
)

if "!restore_enabled!"=="true" (
    echo [1;33m[!] Enabled system protection on C: drive[0m
    timeout /t 3 >nul
)

wmic /namespace:\\root\default path SystemRestore call CreateRestorePoint "PC Cleaner Restore Point", 100, 7 >nul 2>&1
echo [1;32m[✓] Restore point created successfully[0m
timeout /t 2 >nul
cls

:: --- Cleaning Countdown ----
title PC Cleaner - Starting... - https://github.com/FurryBoyYT/pc-cleaner
echo [1;32m[~] Cleaning process starting in:[0m
for /l %%i in (5,-1,1) do (
    echo [1;33m %%i seconds remaining...[0m
    echo [1;31m[!] DO NOT CLOSE DURING CLEANING![0m
    timeout /nobreak /t 1 >nul
    cls
)

:: --- Main Cleaning Routine ----
title PC Cleaner - Cleaning... - https://github.com/FurryBoyYT/pc-cleaner

:: System Temp Cleaners
call :clean_dir "user temp" "%temp%"
call :clean_dir "windows temp" "%systemroot%\Temp"
call :clean_dir "system drive temp" "%systemdrive%\temp"
call :clean_dir "system temp" "%systemroot%\SystemTemp"

:: Windows Error Reporting
call :clean_dir "WER Temp" "C:\ProgramData\Microsoft\Windows\WER\Temp"
call :clean_dir "WER Archive" "C:\ProgramData\Microsoft\Windows\WER\ReportArchive"

:: Prefetch Cleaner
if exist "%systemroot%\prefetch\" (
    echo [1;36m[~] Cleaning windows prefetch...[0m
    del /f /q "%systemroot%\prefetch\*" >nul 2>&1
)

:: Registry Cleanup
echo [1;36m[~] Cleaning registry cache...[0m
for %%k in (
    "HKCR\Local Settings\MuiCache"
    "HKCU\Software\Classes\Local Settings\MuiCache"
    "HKU\.DEFAULT\Software\Classes\Local Settings\MuiCache"
    "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs"
    "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU"
) do reg delete "%%~k" /f >nul 2>&1

:: Windows Update Cleanup (Improved)
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" >nul 2>&1
if errorlevel 1 (
    set "IS_PENDING_UPDATES=0"
    call :clean_dir "software distribution" "%systemroot%\SoftwareDistribution\Download"
) else (
    set "IS_PENDING_UPDATES=1"
    echo [1;33m[!] Skipping Windows Update cleanup - pending reboot required[0m
)

:: Roblox Cleaners
call :clean_dir "Roblox logs" "%localappdata%\Roblox\logs"
call :clean_dir "Roblox downloads" "%localappdata%\Roblox\Downloads"
call :clean_dir "Bloxstrap downloads" "%localappdata%\Bloxstrap\Downloads"
call :clean_dir "Bloxstrap logs" "%localappdata%\Bloxstrap\Logs"

:: System Maintenance
call :clean_dir "crash dumps" "%localappdata%\CrashDumps"
call :clean_dir "downloaded files" "%systemroot%\Downloaded Program Files"

:: Network Configuration
echo [1;36m[~] Resetting network configuration...[0m
ipconfig /flushdns >nul && echo [1;32m[✓] DNS cache flushed[0m
ipconfig /registerdns >nul && echo [1;32m[✓] DNS registration refreshed[0m
ipconfig /release >nul && echo [1;32m[✓] IP addresses released[0m
ipconfig /renew >nul && echo [1;32m[✓] IP addresses renewed[0m

:: Memory Optimization
powershell -Command "Disable-MMAgent -MemoryCompression -ErrorAction SilentlyContinue" >nul 2>&1
echo [1;32m[✓] Memory compression disabled[0m

:: --- Finalization ----
title PC Cleaner - Finished! - https://github.com/FurryBoyYT/pc-cleaner
echo.
echo [1;32m[✓] PC Cleaning completed successfully![0m

if %IS_PENDING_UPDATES% == 1 (
    echo [1;33m[!] Note: Windows Update cleanup skipped - pending updates require reboot[0m
)

echo.
echo [0;36m[~] Exiting in 10 seconds...[0m
timeout /nobreak /t 10 >nul
exit /b

:: --- Functions ----
:clean_dir
echo.
echo [1;36m[~] Cleaning %~1...[0m
if exist "%~2\" (
    del /f /s /q "%~2\*" >nul 2>&1
    for /d %%i in ("%~2\*") do rd /s /q "%%i" >nul 2>&1
    echo [1;32m[✓] %~1 cleaned[0m
) else (
    echo [1;33m[!] %~1 directory not found[0m
)
exit /b