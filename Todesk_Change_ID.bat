@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: 检查管理员权限
net file >nul 2>&1
if %errorlevel% neq 0 (
    echo 请以管理员身份运行此脚本
    pause
    exit
)

:: 定义注册表路径
set "regPath=HKEY_LOCAL_MACHINE\SOFTWARE\ToDesk"

:: 读取GUID值
for /f "tokens=2,*" %%a in ('reg query "%regPath%" /v "GUID" 2^>nul') do set "guid=%%b"
if not defined guid (
    echo 未找到GUID值
    pause
    exit
)

:: 读取UUID值
for /f "tokens=2,*" %%a in ('reg query "%regPath%" /v "UUID" 2^>nul') do set "uuid=%%b"
if not defined uuid (
    echo 未找到UUID值
    pause
    exit
)

::生成4位的随机数
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

::移除最后4位，再添加随机数
set "new_guid=!guid:~0,-3!!code1!"
set "new_uuid=!uuid:~0,-3!!code2!"
echo 系统原 guid %guid%
echo 新的 guid %new_guid%

echo 系统原 uuid %uuid%
echo 新的 uuid %new_uuid%

:: 写回注册表
if defined new_guid reg add "%regPath%" /v "GUID" /t REG_SZ /d "%new_guid%" /f >nul
if defined new_uuid reg add "%regPath%" /v "UUID" /t REG_SZ /d "%new_uuid%" /f >nul

echo 操作完成！
pause
exit


exit /b