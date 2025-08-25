# Todesk ID Change Script

Remote Software Todesk Update ID Script

[中文](README.md) [English](README_EN.md)

ScreenShot

[](images/Todesk_Change_ID.png)

## Key Code

First, read the original ID.

``` bat to read the UUID/GUID.

reg query "HKEY_LOCAL_MACHINE\SOFTWARE\ToDesk" /v "GUID"

Generate a 4-digit random number.

```Generate a 4-digit random number.

set "code1="
for /l %%i in (1,1,4) do (
set /a "rand=!random! %% ​​9 + 1"
set "code1=!code1!!rand!"
)
```

Remove the last 4 digits from the original UUID, then concatenate the generated random number.

```Remove the last 4 digits, then append the random number.

set "new_guid=!guid:~0,-3!!code1!"
```

Concatenate the generated UUID/GUID. Writing back to the registry

```Writing back to the registry
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\ToDesk" /v "GUID" /t REG_SZ /d "%new_guid%"
```

## Script Origin

Working on an industrial control project, I had trouble installing several software packages, so I wanted to repackage the pre-built system.

After restoring the repackaged system, the remote software IDs (remote codes) were all the same, making the IDs recorded in the restored system unusable later.

So, I researched how to directly generate new IDs after restoring the system, and developed this script.
