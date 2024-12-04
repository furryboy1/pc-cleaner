@REM ---start----
@echo off
cls
title PC Cleaner - Loading... - https://github.com/FurryBoyYT/pc-cleaner

net session > nul 2>&1
if %errorLevel% == 0 (
    goto :admin
) else (
    echo Administrative privileges is required to run the cleaner.
    powershell -Command "Start-Process '%~0' -Verb runAs"
    exit
)

:admin
echo A restore point is being created in case something goes wrong.

for /f "tokens=2 delims== " %%G in ('wmic volume where "driveletter='C:'" get automount') do (
    if /i "%%G"=="FALSE" (
        wmic /namespace:\\root\default path SystemRestore call Enable "C:"
        echo System protection on C: drive was not enabled to create a restore point. It has now been enabled.
    )
)

wmic /namespace:\\root\default path SystemRestore call CreateRestorePoint "PC Cleaner restore point", 100, 7
cls

title PC Cleaner - Starting... - https://github.com/FurryBoyYT/pc-cleaner
for /l %%i in (5,-1,1) do (
    echo [1;32mCleaning process will start in [0;33m%%i seconds![1;32m
    echo [1;31mPlease do not close while it's cleaning![0m
    timeout /nobreak /t 1 > nul
    cls
)
title PC Cleaner - Cleaning... - https://github.com/FurryBoyYT/pc-cleaner

@REM ---system----
echo [1;32mCleaning user temp...[1;31m
del /f /s /q "%temp%\*"
for /d %%i in (%temp%\*) do ( rd /s /q "%%i" )

echo.
echo [1;32mCleaning windows temp...[1;31m
del /s /f /q "%systemroot%\Temp\*"
for /d %%i in (%systemroot%\Temp\*) do ( rd /s /q "%%i" )

echo.
echo [1;32mCleaning system drive temp...[1;31m
del /s /f /q "%systemdrive%\temp\*"
for /d %%i in (%systemroot%\temp\*) do ( rd /s /q "%%i" )

echo.
echo [1;32mCleaning system temp...[1;31m
del /s /f /q "%systemroot%\SystemTemp\*"
for /d %%i in (%systemroot%\SystemTemp\*) do ( rd /s /q "%%i" )

echo.
echo [1;32mCleaning windows error report cache...[1;31m
del /s /f /q "C:\ProgramData\Microsoft\Windows\WER\Temp\*"
del /s /f /q "C:\ProgramData\Microsoft\Windows\WER\ReportArchive\*"

echo.
echo [1;32mCleaning windows prefetch...[1;31m
del /s /f /q "%systemroot%\prefetch\*"

echo.
echo [1;32mCleaning registry cache...[1;31m
reg delete "HKEY_CLASSES_ROOT\Local Settings\MuiCache" /f
reg delete "HKEY_CURRENT_USER\Software\Classes\Local Settings\MuiCache" /f
reg delete "HKEY_USERS\.DEFAULT\Software\Classes\Local Settings\MuiCache" /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /f

reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" > nul
if %errorlevel% == 1 (
    echo.
    set "IS_PENDING_UPDATES=0"
    echo [1;32mCleaning software distribution download cache...[1;31m
    del /s /f /q "%systemroot%\SoftwareDistribution\Download"
) else (
    set "IS_PENDING_UPDATES=1"
)

@REM ----roblox-----
echo.
echo [1;32mCleaning Roblox logs...[1;31m
del /q /s "%localappdata%\Roblox\logs\*"

echo.
echo [1;32mCleaning Roblox downloads cache...[1;31m
del /q /s "%localappdata%\Roblox\Downloads\*"

echo.
echo [1;32mCleaning Bloxstrap downloads cache...[1;31m
del /q /s "%localappdata%\Bloxstrap\Downloads\*"

echo.
echo [1;32mCleaning Bloxstrap logs...[1;31m
del /q /s "%localappdata%\Bloxstrap\Logs\*"

@REM ----other-----
echo.
echo [1;32mCleaning crash dump files...[1;31m
del /q /s "%localappdata%\CrashDumps\*"

echo.
echo [1;32mCleaning downloaded program files...[1;31m
del /q "%systemroot%\Downloaded Program Files\*"

echo.
echo [1;32mConfigurating IP Config... (hidden for security reasons)[1;31m
echo WARNING! Your internet may interrupt during this operation.
ipconfig /flushdns > nul
echo Flushed DNS!
ipconfig /registerdns > nul
echo Registered DNS!
ipconfig /release > nul
echo Released!
ipconfig /renew > nul
echo Renewed!

powershell -Command "Disable-MMAgent -MemoryCompression" > nul
echo Memory compression disabled!

title PC Cleaner - Finished! - https://github.com/FurryBoyYT/pc-cleaner
echo.
echo [1;32mPC Cleaning finished!
echo Exiting in 10 seconds.
if %IS_PENDING_UPDATES% == 1 (
    echo Skipped cleaning software distribution download cache,
    echo There are pending windows updates.
)
timeout /nobreak /t 10 > nul
exit /b
@REM ----end-----