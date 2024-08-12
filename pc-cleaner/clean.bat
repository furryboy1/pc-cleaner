:----start----
@echo off
cls
title PC Cleaner - Loading... - https://github.com/FurryBoyYT/pc-cleaner

net session >nul 2>&1
if %errorLevel% == 0 (
    goto :admin
) else (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process '%~0' -Verb runAs"
    exit
)

:admin
echo A restore point will be created incase something bad happened, you can restore your pc back after!
wmic /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "PC Cleaner restore point", 100, 7
cls

title PC Cleaner - Starting... - https://github.com/FurryBoyYT/pc-cleaner
for /l %%i in (5,-1,1) do (
    echo [1;32mCleaning process will start in [0;33m%%i seconds[1;32m!
    echo [1;31mPlease do not close while it's cleaning![0m
    timeout /nobreak /t 1 >nul
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

:----web-browsers----
echo.
echo [1;32mCleaning applications cache...
echo Google[1;31m
del /q /s "%localappdata%\Google\Chrome\User Data\Default\Cache\*"

echo.
echo [1;32mFirefox[1;31m
del /q /s "%localappdata%\Mozilla\Firefox\Profiles\*\cache2\entries\*"

echo.
echo [1;32mMicrosoft[1;31m
del /q /s "%localappdata%\Microsoft\Edge\User Data\Default\Cache\*"

echo.
echo [1;32mINetCache[1;31m
rd /s /q "%localappdata%\Microsoft\Windows\INetCache"

echo.
echo [1;32mOpera[1;31m
del /q /s "%appdata%\Opera Software\Opera Stable\Cache\*"

echo.
echo [1;32mOpera GX[1;31m
del /q /s "%appdata%\Opera Software\Opera GX Stable\Cache\*"

echo.
echo [1;32mBrave[1;31m
del /q /s "%localappdata%\BraveSoftware\Brave-Browser\User Data\Default\Cache\*"

echo.
echo [1;32mVivaldi[1;31m
del /q /s "%localappdata%\Vivaldi\User Data\Default\Cache\*"

echo.
echo [1;32mTor[1;31m
del /q /s "%localappdata%\Tor Browser\Browser\TorBrowser\Data\Browser\profile.default\cache2\entries\*"

:echo.
:echo [1;32mPowerToys[1;31m
:del /q /s "%localappdata%\Microsoft\PowerToys\*\*"

echo.
echo [1;32mSteam[1;31m
del /q /s "%localappdata%\Steam\htmlcache\*"

:echo.
:echo [1;32mVMware[1;31m
:del /q /s "%appdata%\VMware\*"

echo.
echo [1;32mGithub Desktop[1;31m
del /q /s "%appdata%\GitHub Desktop\Cache\*"

echo.
echo [1;32mOneDrive[1;31m
del /q /s "%localappdata%\Microsoft\OneDrive\settings\Business1\*"

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
ipconfig /flushdns >nul
ipconfig /registerdns >nul
ipconfig /release >nul
ipconfig /renew >nul
netsh winsock reset >nul
powershell -Command "Disable-MMAgent -MemoryCompression" >nul
echo IP Config configuration complete! Restart is required to take changes.

title PC Cleaner - Finished! - https://github.com/FurryBoyYT/pc-cleaner
echo.
echo [1;32mPC Cleaning finished!
echo Exiting in 10 seconds.
timeout /nobreak /t 10 >nul
exit /b
:-----end----- 