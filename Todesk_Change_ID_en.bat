@echo off
setlocal enabledelayedexpansion

:: check Administrator permision
net file >nul 2>&1
if %errorlevel% neq 0 (
    echo Run this script with Administrator permision
    pause
    exit
)

:: define regPath
set "regPath=HKEY_LOCAL_MACHINE\SOFTWARE\ToDesk"

:: Read GUID Value
for /f "tokens=2,*" %%a in ('reg query "%regPath%" /v "GUID" 2^>nul') do set "guid=%%b"
if not defined guid (
    echo Did Not Find GUID
    pause
    exit
)

:: Read UUID Value
for /f "tokens=2,*" %%a in ('reg query "%regPath%" /v "UUID" 2^>nul') do set "uuid=%%b"
if not defined uuid (
    echo Did Not Find UUID
    pause
    exit
)

:: generate random 4-digit number
set "code1="
for /l %%i in (1,1,4) do (
    set /a "rand=!random! %% 9 + 1"
    set "code1=!code1!!rand!"
)

set "code2="
for /l %%i in (1,1,4) do (
    set /a "rand=!random! %% 9 + 1"
    set "code2=!code2!!rand!"
)

::Remove the last four digits and add the random number
set "new_guid=!guid:~0,-3!!code1!"
set "new_uuid=!uuid:~0,-3!!code2!"
echo Old guid %guid%
echo New guid %new_guid%

echo Old uuid %uuid%
echo New uuid %new_uuid%

:: Write Back
if defined new_guid reg add "%regPath%" /v "GUID" /t REG_SZ /d "%new_guid%" /f >nul
if defined new_uuid reg add "%regPath%" /v "UUID" /t REG_SZ /d "%new_uuid%" /f >nul

echo Done��
pause
exit


exit /b