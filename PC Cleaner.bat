@echo off
setlocal enabledelayedexpansion

set "script_url=https://github.com/FurryBoyYT/pc-cleaner/raw/main/pc-cleaner/clean.bat"
set "version_url=https://github.com/FurryBoyYT/pc-cleaner/raw/main/pc-cleaner/version.txt"

set "base_dir=%temp%\pc-cleaner"

set "temp_script_path=%base_dir%\TEMP_clean.bat"
set "temp_version_file=%base_dir%\TEMP_version.txt"

set "local_script_path=%base_dir%\clean.bat"
set "local_version_file=%base_dir%\version.txt"

if not exist "%base_dir%" (
    mkdir "%base_dir%"
)

if not exist "%local_version_file%" (
    echo 0 > "%local_version_file%"
)

echo Checking for updates...
bitsadmin /transfer "FetchVersion" "%version_url%" "%temp_version_file%" >nul

if not exist "%temp_version_file%" (
    echo Failed to fetch version file.
    echo Press any key to exit...
    pause >nul
    exit /b 1
)

set /p remote_version=<"%temp_version_file%"
set /p local_version=<"%local_version_file%"

if "!local_version!"=="!remote_version!" (
    echo The script is up to date.
    echo Press any key to exit...
    pause >nul
    exit /b 0
) else (
    echo New version available, updating script...
)

echo Fetching new script...
bitsadmin /transfer "FetchScript" "%script_url%" "%temp_script_path%" >nul

if not exist "%temp_script_path%" (
    echo Failed to fetch the new script.
    echo Press any key to exit...
    pause >nul
    exit /b 1
)

copy /y "%temp_script_path%" "%local_script_path%" >nul

if %errorlevel% neq 0 (
    echo Failed to update the script.
    echo Press any key to exit...
    pause >nul
    exit /b 1
)

echo %remote_version% > "%local_version_file%"

echo PC Cleaner updated successfully.
echo Starting PC Cleaner...

start "" "%local_script_path%"
exit /b 0