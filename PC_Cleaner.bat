@echo off
title PC Cleaner - Loading... - https://github.com/FurryBoyYT/pc-cleaner
echo Loading...
setlocal enabledelayedexpansion

set "url=https://github.com/FurryBoyYT/pc-cleaner/raw/main/pc-cleaner/clean.bat"
set "base_dir=%appdata%\pc-cleaner"
set "script_path=%base_dir%\clean.bat"

if not exist "%base_dir%" ( mkdir "%base_dir%" )

title PC Cleaner - Downloading... - https://github.com/FurryBoyYT/pc-cleaner
echo Downloading cleaner...

C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -Command "Invoke-WebRequest -Uri %url% -OutFile %script_path%" >nul

if %errorlevel% neq 0 (
    title PC Cleaner - Error - https://github.com/FurryBoyYT/pc-cleaner
    echo ERROR: Failed to fetch cleaner!
    echo Error code: %errorlevel%
    echo Press any key to exit...
    pause >nul
    exit /b 1
) else (
    echo.
    echo Download successful!
    echo Running cleaner...
    title PC Cleaner - Loading... - https://github.com/FurryBoyYT/pc-cleaner
    "%script_path%"
)