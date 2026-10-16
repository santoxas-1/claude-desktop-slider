@echo off
chcp 65001 >nul
title Установка мода Cosmic Slider для Claude Desktop
color 0B

echo ===================================================================
echo     Cosmic Slider Mod for Claude Desktop (Warp Speed Edition)
echo ===================================================================
echo.

set "SCRIPT_DIR=%~dp0"

:: 1. Поиск папки ресурсов Claude Desktop
echo [1/4] Поиск директории Claude Desktop...

set "ION_DIR="

if exist "%LOCALAPPDATA%\Programs\Claude\resources\ion-dist" (
    set "ION_DIR=%LOCALAPPDATA%\Programs\Claude\resources\ion-dist"
) else if exist "%LOCALAPPDATA%\Claude\resources\ion-dist" (
    set "ION_DIR=%LOCALAPPDATA%\Claude\resources\ion-dist"
) else if exist "%PROGRAMFILES%\Claude\resources\ion-dist" (
    set "ION_DIR=%PROGRAMFILES%\Claude\resources\ion-dist"
) else (
    :: Поиск версионных папок Squirrel (app-*)
    for /f "delims=" %%I in ('powershell -NoProfile -Command "(Get-Item '%LOCALAPPDATA%\Claude\app-*\resources\ion-dist' -ErrorAction SilentlyContinue | Select-Object -Last 1).FullName"') do set "ION_DIR=%%I"
)

if not defined ION_DIR (
    color 0C
    echo.
    echo [ОШИБКА] Директория Claude Desktop не найдена!
    echo Убедитесь, что приложение Claude Desktop установлено на компьютере.
    echo.
    pause
    exit /b 1
)

echo       Найдено: %ION_DIR%

:: 2. Создание резервной копии index.html
echo.
echo [2/4] Создание резервной копии index.html...
if not exist "%ION_DIR%\index.html.cosmic.bak" (
    copy /y "%ION_DIR%\index.html" "%ION_DIR%\index.html.cosmic.bak" >nul
    echo       Создан бэкап: index.html.cosmic.bak
) else (
    echo       Резервная копия уже существует, пропускаем.
)

:: 3. Копирование cosmic-slider.js
echo.
echo [3/4] Копирование файла cosmic-slider.js...
copy /y "%SCRIPT_DIR%cosmic-slider.js" "%ION_DIR%\cosmic-slider.js" >nul
if %errorlevel% neq 0 (
    color 0C
    echo [ОШИБКА] Не удалось скопировать cosmic-slider.js в %ION_DIR%!
    echo Попробуйте запустить скрипт от имени Администратора.
    pause
    exit /b 1
)
echo       Файл cosmic-slider.js успешно скопирован.

:: 4. Подключение скрипта в index.html
echo.
echo [4/4] Активация скрипта в index.html...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$html = '%ION_DIR%\index.html';" ^
    "$c = [System.IO.File]::ReadAllText($html, [System.Text.Encoding]::UTF8);" ^
    "if ($c -notmatch 'cosmic-slider\.js') {" ^
    "    if ($c -match '<script src=\"/i18n-ru\.js\"></script>') {" ^
    "        $c = $c -replace '<script src=\"/i18n-ru\.js\"></script>', '<script src=\"/i18n-ru.js\"></script><script src=\"/cosmic-slider.js\"></script>';" ^
    "    } else {" ^
    "        $c = $c -replace '<head>', '<head><script src=\"/cosmic-slider.js\"></script>';" ^
    "    }" ^
    "    [System.IO.File]::WriteAllText($html, $c, [System.Text.Encoding]::UTF8);" ^
    "    Write-Host '      [OK] Тег скрипта успешно добавлен в index.html' -ForegroundColor Green;" ^
    "} else {" ^
    "    Write-Host '      [i] Скрипт уже был подключен ранее' -ForegroundColor Yellow;" ^
    "}"

color 0A
echo.
echo ===================================================================
echo     Установка успешно завершена!
echo ===================================================================
echo.
echo 1. Перезапустите Claude Desktop (или нажмите Ctrl+R в его окне).
echo 2. В строке выбора модели нажмите на кнопку усилий рассуждений.
echo 3. Переключитесь на «Максимум» — и звёзды устремятся в гиперпрыжок!
echo.
echo Для удаления мода запустите uninstall.bat.
echo.
pause
