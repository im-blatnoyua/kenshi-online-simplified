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
echo [→] Поиск установки Kenshi...

:: Список возможных путей
set "PATHS[0]=C:\Program Files (x86)\Steam\steamapps\common\Kenshi"
set "PATHS[1]=C:\Program Files\Steam\steamapps\common\Kenshi"
set "PATHS[2]=D:\Steam\steamapps\common\Kenshi"
set "PATHS[3]=E:\Steam\steamapps\common\Kenshi"
set "PATHS[4]=C:\GOG Games\Kenshi"
set "PATHS[5]=D:\GOG Games\Kenshi"
set "PATHS[6]=C:\Games\Kenshi"
set "PATHS[7]=D:\Games\Kenshi"

:: Проверка всех путей
for /L %%i in (0,1,7) do (
    if exist "!PATHS[%%i]!\kenshi_x64.exe" (
        set "KENSHI_PATH=!PATHS[%%i]!"
        echo [✓] Найден Kenshi: !KENSHI_PATH!
        goto :found
    )
)

:: Если не найден, запросить у пользователя
:notfound
echo [!] Kenshi не найден автоматически!
echo.
echo Примеры путей:
echo   C:\Program Files (x86)\Steam\steamapps\common\Kenshi
echo   C:\GOG Games\Kenshi
echo   D:\Steam\steamapps\common\Kenshi
echo.

:askpath
set /p "KENSHI_PATH=Введите полный путь к папке Kenshi: "

:: Убрать кавычки если есть
set "KENSHI_PATH=%KENSHI_PATH:"=%"

if exist "%KENSHI_PATH%\kenshi_x64.exe" (
    echo [✓] Путь подтвержден: %KENSHI_PATH%
    goto :found
) else (
    echo [!] Файл kenshi_x64.exe не найден по пути: %KENSHI_PATH%
    echo [?] Попробуйте ещё раз или нажмите Ctrl+C для выхода
    echo.
    goto :askpath
)

:found

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
