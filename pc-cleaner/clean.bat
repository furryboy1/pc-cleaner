:----start----
@echo off
cls
title PC Cleaner - Loading... - https://github.com/FurryBoyYT/pc-cleaner

net session > nul 2>&1
if %errorLevel% == 0 (
    goto :admin
) else (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process '%~0' -Verb runAs"
    exit
)

:admin
echo A restore point is being created incase something bad happened with the PC Cleaner, you can restore your PC back after!
wmic /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "PC Cleaner restore point", 100, 7
cls

title PC Cleaner - Starting... - https://github.com/FurryBoyYT/pc-cleaner
for /l %%i in (5,-1,1) do (
    echo [1;32mCleaning process will start in [0;33m%%i seconds![1;32m
    echo [1;31mPlease do not close while it's cleaning![0m
    timeout /nobreak /t 1 > nul
    cls
)
title PC Cleaner - Cleaning... - https://github.com/FurryBoyYT/pc-cleaner

:----system----
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
echo [1;32mCleaning windows registry cache...[1;31m
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /f

reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" > nul
if %errorlevel% == 0 (
    echo.
    set "IS_PENDING_UPDATES=0"
    echo [1;32mCleaning software distribution download cache...[1;31m
    del /s /f /q "%systemroot%\SoftwareDistribution\Download"
) else (
    set "IS_PENDING_UPDATES=1"
)

:-----roblox-----
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

:-----other-----
echo.
echo [1;32mCleaning unnecessary system files...[1;31m
cleanmgr /sagerun:1
echo Cleaned!

echo.
echo [1;32mCleaning crash dump files...[1;31m
del /q /s "%localappdata%\CrashDumps\*"

echo.
echo [1;32mCleaning downloaded program files...[1;31m
del /q "%systemroot%\Downloaded Program Files\*"

echo.
echo [1;32mEmptying recycle bin...[1;31m
rd /s /q "%systemdrive%\$Recycle.bin"

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
netsh winsock reset > nul
echo Reset winsock!
powershell -Command "Disable-MMAgent -MemoryCompression" > nul
echo Memory compression disabled!
echo [0;31mIP Config configuration complete! A PC restart is required to take changes.

title PC Cleaner - Finished! - https://github.com/FurryBoyYT/pc-cleaner
echo.
echo [1;32mPC Cleaning finished!
echo Exiting in 10 seconds.
if %IS_PENDING_UPDATES% == 1 (
    echo W_W_W
    @REM echo [0;31mThere was a problem while attempting to clean some of the files:
    @REM echo Unable to clean software distribution download cache:
    @REM echo There are pending windows updates, please update and try running the cleaner again!
)
timeout /nobreak /t 10 > nul
exit /b
:-----end-----