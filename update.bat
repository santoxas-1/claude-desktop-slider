@echo off
chcp 65001 >nul
title Обновление мода Cosmic Slider для Claude Desktop
color 0B

echo ===================================================================
echo     Обновление Cosmic Slider Mod для Claude Desktop
echo ===================================================================
echo.

set "SCRIPT_DIR=%~dp0"
set "REPO_RAW_URL=https://raw.githubusercontent.com/santoxas-1/claude-desktop-cosmic-slider/main/cosmic-slider.js"

:: 1. Поиск папки ресурсов Claude Desktop
echo [1/3] Поиск директории Claude Desktop...
set "ION_DIR="

if exist "%LOCALAPPDATA%\Programs\Claude\resources\ion-dist" (
    set "ION_DIR=%LOCALAPPDATA%\Programs\Claude\resources\ion-dist"
) else if exist "%LOCALAPPDATA%\Claude\resources\ion-dist" (
    set "ION_DIR=%LOCALAPPDATA%\Claude\resources\ion-dist"
) else if exist "%PROGRAMFILES%\Claude\resources\ion-dist" (
    set "ION_DIR=%PROGRAMFILES%\Claude\resources\ion-dist"
) else (
    for /f "delims=" %%I in ('powershell -NoProfile -Command "(Get-Item '%LOCALAPPDATA%\Claude\app-*\resources\ion-dist' -ErrorAction SilentlyContinue | Select-Object -Last 1).FullName"') do set "ION_DIR=%%I"
)

if not defined ION_DIR (
    color 0C
    echo [ОШИБКА] Директория Claude Desktop не найдена!
    pause
    exit /b 1
)
echo       Найдено: %ION_DIR%

:: 2. Проверка онлайн-обновления с GitHub (если доступно)
echo.
echo [2/3] Проверка новой версии cosmic-slider.js...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$onlineUrl = '%REPO_RAW_URL%';" ^
    "$localFile = Join-Path '%SCRIPT_DIR%' 'cosmic-slider.js';" ^
    "try {" ^
    "    $web = New-Object System.Net.WebClient;" ^
    "    $web.Encoding = [System.Text.Encoding]::UTF8;" ^
    "    $content = $web.DownloadString($onlineUrl);" ^
    "    if ($content -and $content.Length -gt 500) {" ^
    "        [System.IO.File]::WriteAllText($localFile, $content, [System.Text.Encoding]::UTF8);" ^
    "        Write-Host '      [OK] Загружена самая свежая версия мода из репозитория!' -ForegroundColor Green;" ^
    "    }" ^
    "} catch {" ^
    "    Write-Host '      [i] Онлайн-репозиторий недоступен, используем локальную версию файла.' -ForegroundColor Yellow;" ^
    "}"

:: 3. Обновление файлов и повторное подключение после обновлений Claude Desktop
echo.
echo [3/3] Установка обновления в Claude Desktop...
copy /y "%SCRIPT_DIR%cosmic-slider.js" "%ION_DIR%\cosmic-slider.js" >nul
if %errorlevel% neq 0 (
    color 0C
    echo [ОШИБКА] Не удалось скопировать cosmic-slider.js
    pause
    exit /b 1
)

:: Проверяем целостность подключения в index.html
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
    "    Write-Host '      [OK] Мод успешно переподключен к обновленной версии Claude Desktop!' -ForegroundColor Green;" ^
    "} else {" ^
    "    Write-Host '      [OK] Файлы обновлены, подключение к index.html активно.' -ForegroundColor Green;" ^
    "}"

color 0A
echo.
echo ===================================================================
echo     Обновление успешно завершено!
echo ===================================================================
echo.
echo Нажмите Ctrl+R в окне Claude Desktop для применения изменений.
echo.
pause
