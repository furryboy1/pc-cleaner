@echo off
title PC Cleaner - Loading... - https://github.com/FurryBoyYT/pc-cleaner
setlocal enabledelayedexpansion

set "url=https://github.com/FurryBoyYT/pc-cleaner/raw/main/pc-cleaner/clean.bat"
set "base_dir=%appdata%\pc-cleaner"
set "script_path=%base_dir%\clean.bat"

if not exist "%base_dir%" ( mkdir "%base_dir%" )

echo Loading...
title PC Cleaner - Downloading... - https://github.com/FurryBoyYT/pc-cleaner
echo Downloading cleaner...

C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -Command "Invoke-WebRequest -Uri %url% -OutFile %script_path%" >nul

if %errorlevel% neq 0 (
    title PC Cleaner - Error - https://github.com/FurryBoyYT/pc-cleaner
    echo.
    echo ERROR: Failed to get cleaner
    echo POWERSHELL_WEB_REQUEST_ERROR_CODE: %errorlevel%
    echo.
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