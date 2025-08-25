# Todesk 更换 ID 脚本

远程软件 Todesk 更新 ID 脚本

[中文](README.md) [English](README_EN.md)

运行截图

[](images/Todesk_Change_ID.png)

## 关键代码

先读取原有的 ID

``` bat 读取 UUID/GUID
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\ToDesk" /v "GUID"
```

生成4位的随机数

```生成4位的随机数
set "code1="
for /l %%i in (1,1,4) do (
    set /a "rand=!random! %% 9 + 1"
    set "code1=!code1!!rand!"
)
```

把原来的 UUID 移除最后 4 位，然后把生成的随机数连接上去

```移除最后4位，再添加随机数
set "new_guid=!guid:~0,-3!!code1!"
```

把生成的 UUID/GUID 写回注册表

```写回注册表
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\ToDesk" /v "GUID" /t REG_SZ /d "%new_guid%"
```

## 脚本原由

做工控项目，有几个软件安装的时候很麻烦，就想封装已经做好的系统。

封装的系统恢复之后远程软件的 ID （远程码）都是一样的，导致恢复系统记录的 ID 后期无法使用。

所以就研究恢复系统之后直接生成新的 ID ，研究了这个脚本。
