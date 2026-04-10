@echo off
setlocal enabledelayedexpansion

echo.
echo ============================================
echo   Kenshi Online - ���������
echo ============================================
echo.

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] ��������� ����� ��������������!
    echo [!] ��������� �� ����� ��������������.
    echo.
    pause
    exit /b 1
)

set "KENSHI_PATH="
echo [*] ����� Kenshi...

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
        echo [OK] ������: !KENSHI_PATH!
        goto found
    )
)

:notfound
echo [!] Kenshi �� ������!
echo.
echo �������:
echo   C:\Program Files (x86)\Steam\steamapps\common\Kenshi
echo   C:\GOG Games\Kenshi
echo.

:askpath
set /p "KENSHI_PATH=������� ���� � Kenshi: "
set "KENSHI_PATH=!KENSHI_PATH:"=!"

if exist "!KENSHI_PATH!\kenshi_x64.exe" (
    echo [OK] ���� �����������
    goto found
) else (
    echo [!] kenshi_x64.exe �� ������
    echo.
    goto askpath
)

:found
echo.
echo ============================================
echo   ��������� ������...
echo ============================================

echo [*] KenshiMP.Core.dll...
copy /Y "dist\KenshiMP.Core.dll" "!KENSHI_PATH!\" >nul 2>&1
if errorlevel 1 (
    echo [!] ������. �������� Kenshi.
    pause
    exit /b 1
)
echo [OK] ����������

echo [*] KenshiMP.Injector.exe...
copy /Y "dist\KenshiMP.Injector.exe" "!KENSHI_PATH!\" >nul 2>&1
echo [OK] ����������

echo [*] KenshiMP.Server.exe...
copy /Y "dist\KenshiMP.Server.exe" "!KENSHI_PATH!\" >nul 2>&1
echo [OK] ����������

echo [*] server.json...
copy /Y "dist\server.json" "!KENSHI_PATH!\" >nul 2>&1
echo [OK] ����������

echo [*] kenshi-online.mod...
copy /Y "dist\kenshi-online.mod" "!KENSHI_PATH!\" >nul 2>&1
echo [OK] ����������

echo [*] ��������� Plugins_x64.cfg...
set "PLUGINS_CFG=!KENSHI_PATH!\Plugins_x64.cfg"

if not exist "!PLUGINS_CFG!" (
    echo [!] Plugins_x64.cfg �� ������!
    pause
    exit /b 1
)

findstr /C:"Plugin=KenshiMP.Core" "!PLUGINS_CFG!" >nul 2>&1
if errorlevel 1 (
    echo Plugin=KenshiMP.Core>> "!PLUGINS_CFG!"
    echo [OK] ��������� � ������
) else (
    echo [OK] ��� ��������
)

echo [*] GUI �����...
if not exist "!KENSHI_PATH!\data\gui\layout" mkdir "!KENSHI_PATH!\data\gui\layout"
copy /Y "dist\Kenshi_MultiplayerPanel.layout" "!KENSHI_PATH!\data\gui\layout\" >nul 2>&1
copy /Y "dist\Kenshi_MultiplayerHUD.layout" "!KENSHI_PATH!\data\gui\layout\" >nul 2>&1
copy /Y "dist\Kenshi_MainMenu.layout" "!KENSHI_PATH!\data\gui\layout\" >nul 2>&1
echo [OK] �����������

echo [*] �������� ������...
set "DESKTOP=%USERPROFILE%\Desktop"
set "SHORTCUT=!DESKTOP!\Kenshi Online.lnk"

powershell -Command "$WS = New-Object -ComObject WScript.Shell; $SC = $WS.CreateShortcut('!SHORTCUT!'); $SC.TargetPath = '!KENSHI_PATH!\KenshiMP.Injector.exe'; $SC.WorkingDirectory = '!KENSHI_PATH!'; $SC.Save()" >nul 2>&1
if not errorlevel 1 (
    echo [OK] ����� ������
)

echo.
echo ============================================
echo   ��������� ���������!
echo ============================================
echo.
echo ������:
echo   - ����� "Kenshi Online" �� ������� �����
echo   - ���: !KENSHI_PATH!\KenshiMP.Injector.exe
echo.
echo ������:
echo   - !KENSHI_PATH!\KenshiMP.Server.exe
echo.
pause
