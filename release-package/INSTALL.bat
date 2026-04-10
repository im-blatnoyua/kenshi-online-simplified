@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

echo.
echo ============================================
echo   Kenshi Online - Installation
echo ============================================
echo.

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] Administrator rights required!
    echo [!] Run this file as Administrator.
    echo.
    pause
    exit /b 1
)

set "KENSHI_PATH="
echo [*] Searching for Kenshi installation...

set "PATHS[0]=C:\Steam\steamapps\common\Kenshi"
set "PATHS[1]=C:\Program Files (x86)\Steam\steamapps\common\Kenshi"
set "PATHS[2]=C:\Program Files\Steam\steamapps\common\Kenshi"
set "PATHS[3]=D:\Steam\steamapps\common\Kenshi"
set "PATHS[4]=E:\Steam\steamapps\common\Kenshi"
set "PATHS[5]=C:\GOG Games\Kenshi"
set "PATHS[6]=D:\GOG Games\Kenshi"
set "PATHS[7]=C:\Games\Kenshi"
set "PATHS[8]=D:\Games\Kenshi"

for /L %%i in (0,1,8) do (
    if exist "!PATHS[%%i]!\kenshi_x64.exe" (
        set "KENSHI_PATH=!PATHS[%%i]!"
        echo [OK] Found Kenshi: !KENSHI_PATH!
        goto found
    )
)

:notfound
echo [!] Kenshi not found automatically!
echo.
echo Example paths:
echo   C:\Program Files (x86)\Steam\steamapps\common\Kenshi
echo   C:\GOG Games\Kenshi
echo   D:\Steam\steamapps\common\Kenshi
echo.

:askpath
set /p "KENSHI_PATH=Enter full path to Kenshi folder: "
set "KENSHI_PATH=!KENSHI_PATH:"=!"

if exist "!KENSHI_PATH!\kenshi_x64.exe" (
    echo [OK] Path confirmed: !KENSHI_PATH!
    goto found
) else (
    echo [!] kenshi_x64.exe not found at: !KENSHI_PATH!
    echo [?] Try again or press Ctrl+C to exit
    echo.
    goto askpath
)

:found
echo.
echo ============================================
echo   Installing files...
echo ============================================

echo [*] Copying KenshiMP.Core.dll...
copy /Y "dist\KenshiMP.Core.dll" "!KENSHI_PATH!\" >nul 2>&1
if errorlevel 1 (
    echo [!] Error copying DLL. Close Kenshi and try again.
    pause
    exit /b 1
)
echo [OK] KenshiMP.Core.dll installed

echo [*] Copying KenshiMP.Injector.exe...
copy /Y "dist\KenshiMP.Injector.exe" "!KENSHI_PATH!\" >nul 2>&1
echo [OK] KenshiMP.Injector.exe installed

echo [*] Copying KenshiMP.Server.exe...
copy /Y "dist\KenshiMP.Server.exe" "!KENSHI_PATH!\" >nul 2>&1
echo [OK] KenshiMP.Server.exe installed

echo [*] Copying server.json...
copy /Y "dist\server.json" "!KENSHI_PATH!\" >nul 2>&1
echo [OK] server.json installed

echo [*] Copying kenshi-online.mod...
copy /Y "dist\kenshi-online.mod" "!KENSHI_PATH!\" >nul 2>&1
echo [OK] kenshi-online.mod installed

echo [*] Configuring Plugins_x64.cfg...
set "PLUGINS_CFG=!KENSHI_PATH!\Plugins_x64.cfg"

if not exist "!PLUGINS_CFG!" (
    echo [!] Plugins_x64.cfg not found!
    pause
    exit /b 1
)

findstr /C:"Plugin=KenshiMP.Core" "!PLUGINS_CFG!" >nul 2>&1
if errorlevel 1 (
    echo Plugin=KenshiMP.Core>> "!PLUGINS_CFG!"
    echo [OK] Added entry to Plugins_x64.cfg
) else (
    echo [OK] Plugins_x64.cfg already configured
)

echo [*] Copying GUI files...
if not exist "!KENSHI_PATH!\data\gui\layout" mkdir "!KENSHI_PATH!\data\gui\layout"
copy /Y "dist\Kenshi_MultiplayerPanel.layout" "!KENSHI_PATH!\data\gui\layout\" >nul 2>&1
copy /Y "dist\Kenshi_MultiplayerHUD.layout" "!KENSHI_PATH!\data\gui\layout\" >nul 2>&1
copy /Y "dist\Kenshi_MainMenu.layout" "!KENSHI_PATH!\data\gui\layout\" >nul 2>&1
echo [OK] GUI files installed

echo [*] Creating desktop shortcut...
set "DESKTOP=%USERPROFILE%\Desktop"
set "SHORTCUT=!DESKTOP!\Kenshi Online.lnk"

powershell -Command "$WS = New-Object -ComObject WScript.Shell; $SC = $WS.CreateShortcut('!SHORTCUT!'); $SC.TargetPath = '!KENSHI_PATH!\KenshiMP.Injector.exe'; $SC.WorkingDirectory = '!KENSHI_PATH!'; $SC.Save()" >nul 2>&1
if not errorlevel 1 (
    echo [OK] Desktop shortcut created
)

echo.
echo ============================================
echo   Installation complete!
echo ============================================
echo.
echo Launch the game via:
echo   - "Kenshi Online" shortcut on desktop
echo   - Or: !KENSHI_PATH!\KenshiMP.Injector.exe
echo.
echo To run server:
echo   - !KENSHI_PATH!\KenshiMP.Server.exe
echo.
pause
