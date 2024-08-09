@echo off
title PC Cleaner - Loading...
setlocal enabledelayedexpansion

set "url=https://github.com/FurryBoyYT/pc-cleaner/raw/main/pc-cleaner/clean.bat"

set "base_dir=%temp%\pc-cleaner"
set "script=%base_dir%\clean.bat"

if not exist "%base_dir%" ( mkdir "%base_dir%" )

echo Loading...
echo Downloading cleaner...
bitsadmin /transfer "FetchScript" "%url%" "%script%" >nul

if %errorlevel% equ -2147024809 (
    echo ERROR: Failed to download cleaner. Error code: -2147024809
    echo Press any key to exit...
    pause >nul
    exit /b 1
) else (
    echo Download successful.
    echo Running cleaner...
    %script%
)