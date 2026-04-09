@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: ============================================
::  Kenshi Online - Простая установка
:: ============================================

echo.
echo ╔════════════════════════════════════════╗
echo ║   Kenshi Online - Установка мода      ║
echo ╔════════════════════════════════════════╝
echo.

:: Проверка прав администратора
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] Требуются права администратора!
    echo [!] Запустите этот файл от имени администратора.
    echo.
    pause
    exit /b 1
)

:: Поиск Kenshi
set "KENSHI_PATH="
set "STEAM_PATH=C:\Program Files (x86)\Steam\steamapps\common\Kenshi"
set "GOG_PATH=C:\GOG Games\Kenshi"

if exist "%STEAM_PATH%\kenshi_x64.exe" (
    set "KENSHI_PATH=%STEAM_PATH%"
    echo [✓] Найден Kenshi (Steam): %STEAM_PATH%
) else if exist "%GOG_PATH%\kenshi_x64.exe" (
    set "KENSHI_PATH=%GOG_PATH%"
    echo [✓] Найден Kenshi (GOG): %GOG_PATH%
) else (
    echo [!] Kenshi не найден автоматически!
    echo.
    set /p "KENSHI_PATH=Введите путь к Kenshi (где находится kenshi_x64.exe): "
    if not exist "!KENSHI_PATH!\kenshi_x64.exe" (
        echo [!] Неверный путь! kenshi_x64.exe не найден.
        pause
        exit /b 1
    )
)

echo.
echo ════════════════════════════════════════
echo  Установка файлов...
echo ════════════════════════════════════════

:: Копирование основных файлов
echo [→] Копирование KenshiMP.Core.dll...
copy /Y "dist\KenshiMP.Core.dll" "%KENSHI_PATH%\" >nul 2>&1
if errorlevel 1 (
    echo [!] Ошибка копирования DLL. Закройте Kenshi и попробуйте снова.
    pause
    exit /b 1
)
echo [✓] KenshiMP.Core.dll установлен

echo [→] Копирование KenshiMP.Injector.exe...
copy /Y "dist\KenshiMP.Injector.exe" "%KENSHI_PATH%\" >nul 2>&1
echo [✓] KenshiMP.Injector.exe установлен

echo [→] Копирование KenshiMP.Server.exe...
copy /Y "dist\KenshiMP.Server.exe" "%KENSHI_PATH%\" >nul 2>&1
echo [✓] KenshiMP.Server.exe установлен

echo [→] Копирование server.json...
copy /Y "dist\server.json" "%KENSHI_PATH%\" >nul 2>&1
echo [✓] server.json установлен

echo [→] Копирование kenshi-online.mod...
copy /Y "dist\kenshi-online.mod" "%KENSHI_PATH%\" >nul 2>&1
echo [✓] kenshi-online.mod установлен

:: Настройка Plugins_x64.cfg
echo [→] Настройка Plugins_x64.cfg...
set "PLUGINS_CFG=%KENSHI_PATH%\Plugins_x64.cfg"

if not exist "%PLUGINS_CFG%" (
    echo [!] Plugins_x64.cfg не найден!
    pause
    exit /b 1
)

findstr /C:"Plugin=KenshiMP.Core" "%PLUGINS_CFG%" >nul 2>&1
if errorlevel 1 (
    echo Plugin=KenshiMP.Core>> "%PLUGINS_CFG%"
    echo [✓] Добавлена запись в Plugins_x64.cfg
) else (
    echo [✓] Plugins_x64.cfg уже настроен
)

:: Копирование GUI файлов
echo [→] Копирование GUI файлов...
if not exist "%KENSHI_PATH%\data\gui\layout" mkdir "%KENSHI_PATH%\data\gui\layout"
copy /Y "dist\Kenshi_MultiplayerPanel.layout" "%KENSHI_PATH%\data\gui\layout\" >nul 2>&1
copy /Y "dist\Kenshi_MultiplayerHUD.layout" "%KENSHI_PATH%\data\gui\layout\" >nul 2>&1
copy /Y "dist\Kenshi_MainMenu.layout" "%KENSHI_PATH%\data\gui\layout\" >nul 2>&1
echo [✓] GUI файлы установлены

:: Создание ярлыка
echo [→] Создание ярлыка на рабочем столе...
set "DESKTOP=%USERPROFILE%\Desktop"
set "SHORTCUT=%DESKTOP%\Kenshi Online.lnk"

powershell -Command "$WS = New-Object -ComObject WScript.Shell; $SC = $WS.CreateShortcut('%SHORTCUT%'); $SC.TargetPath = '%KENSHI_PATH%\KenshiMP.Injector.exe'; $SC.WorkingDirectory = '%KENSHI_PATH%'; $SC.Save()" >nul 2>&1
if errorlevel 0 (
    echo [✓] Ярлык создан на рабочем столе
)

echo.
echo ════════════════════════════════════════
echo  ✓ Установка завершена!
echo ════════════════════════════════════════
echo.
echo Запустите игру через:
echo   • Ярлык "Kenshi Online" на рабочем столе
echo   • Или: %KENSHI_PATH%\KenshiMP.Injector.exe
echo.
echo Для запуска сервера:
echo   • %KENSHI_PATH%\KenshiMP.Server.exe
echo.
pause
