@echo off
setlocal enabledelayedexpansion

echo.
echo ============================================
echo   Kenshi Online - Установка
echo ============================================
echo.

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] Требуются права администратора!
    echo [!] Запустите от имени администратора.
    echo.
    pause
    exit /b 1
)

set "KENSHI_PATH="
echo [*] Поиск Kenshi...

set "PATHS[0]=C:\Program Files (x86)\Steam\steamapps\common\Kenshi"
set "PATHS[1]=C:\Program Files\Steam\steamapps\common\Kenshi"
set "PATHS[2]=D:\Steam\steamapps\common\Kenshi"
set "PATHS[3]=E:\Steam\steamapps\common\Kenshi"
set "PATHS[4]=C:\GOG Games\Kenshi"
set "PATHS[5]=D:\GOG Games\Kenshi"
set "PATHS[6]=C:\Games\Kenshi"
set "PATHS[7]=D:\Games\Kenshi"

for /L %%i in (0,1,7) do (
    if exist "!PATHS[%%i]!\kenshi_x64.exe" (
        set "KENSHI_PATH=!PATHS[%%i]!"
        echo [OK] Найден: !KENSHI_PATH!
        goto found
    )
)

:notfound
echo [!] Kenshi не найден!
echo.
echo Примеры:
echo   C:\Program Files (x86)\Steam\steamapps\common\Kenshi
echo   C:\GOG Games\Kenshi
echo.

:askpath
set /p "KENSHI_PATH=Введите путь к Kenshi: "
set "KENSHI_PATH=!KENSHI_PATH:"=!"

if exist "!KENSHI_PATH!\kenshi_x64.exe" (
    echo [OK] Путь подтвержден
    goto found
) else (
    echo [!] kenshi_x64.exe не найден
    echo.
    goto askpath
)

:found
echo.
echo ============================================
echo   Установка файлов...
echo ============================================

echo [*] KenshiMP.Core.dll...
copy /Y "dist\KenshiMP.Core.dll" "!KENSHI_PATH!\" >nul 2>&1
if errorlevel 1 (
    echo [!] Ошибка. Закройте Kenshi.
    pause
    exit /b 1
)
echo [OK] Установлен

echo [*] KenshiMP.Injector.exe...
copy /Y "dist\KenshiMP.Injector.exe" "!KENSHI_PATH!\" >nul 2>&1
echo [OK] Установлен

echo [*] KenshiMP.Server.exe...
copy /Y "dist\KenshiMP.Server.exe" "!KENSHI_PATH!\" >nul 2>&1
echo [OK] Установлен

echo [*] server.json...
copy /Y "dist\server.json" "!KENSHI_PATH!\" >nul 2>&1
echo [OK] Установлен

echo [*] kenshi-online.mod...
copy /Y "dist\kenshi-online.mod" "!KENSHI_PATH!\" >nul 2>&1
echo [OK] Установлен

echo [*] Настройка Plugins_x64.cfg...
set "PLUGINS_CFG=!KENSHI_PATH!\Plugins_x64.cfg"

if not exist "!PLUGINS_CFG!" (
    echo [!] Plugins_x64.cfg не найден!
    pause
    exit /b 1
)

findstr /C:"Plugin=KenshiMP.Core" "!PLUGINS_CFG!" >nul 2>&1
if errorlevel 1 (
    echo Plugin=KenshiMP.Core>> "!PLUGINS_CFG!"
    echo [OK] Добавлено в конфиг
) else (
    echo [OK] Уже настроен
)

echo [*] GUI файлы...
if not exist "!KENSHI_PATH!\data\gui\layout" mkdir "!KENSHI_PATH!\data\gui\layout"
copy /Y "dist\Kenshi_MultiplayerPanel.layout" "!KENSHI_PATH!\data\gui\layout\" >nul 2>&1
copy /Y "dist\Kenshi_MultiplayerHUD.layout" "!KENSHI_PATH!\data\gui\layout\" >nul 2>&1
copy /Y "dist\Kenshi_MainMenu.layout" "!KENSHI_PATH!\data\gui\layout\" >nul 2>&1
echo [OK] Установлены

echo [*] Создание ярлыка...
set "DESKTOP=%USERPROFILE%\Desktop"
set "SHORTCUT=!DESKTOP!\Kenshi Online.lnk"

powershell -Command "$WS = New-Object -ComObject WScript.Shell; $SC = $WS.CreateShortcut('!SHORTCUT!'); $SC.TargetPath = '!KENSHI_PATH!\KenshiMP.Injector.exe'; $SC.WorkingDirectory = '!KENSHI_PATH!'; $SC.Save()" >nul 2>&1
if not errorlevel 1 (
    echo [OK] Ярлык создан
)

echo.
echo ============================================
echo   Установка завершена!
echo ============================================
echo.
echo Запуск:
echo   - Ярлык "Kenshi Online" на рабочем столе
echo   - Или: !KENSHI_PATH!\KenshiMP.Injector.exe
echo.
echo Сервер:
echo   - !KENSHI_PATH!\KenshiMP.Server.exe
echo.
pause
