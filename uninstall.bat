@echo off
chcp 65001 >nul
title Удаление мода Cosmic Slider для Claude Desktop
color 0E

echo ===================================================================
echo     Удаление Cosmic Slider Mod из Claude Desktop
echo ===================================================================
echo.

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
    echo [ОШИБКА] Директория Claude Desktop не найдена.
    pause
    exit /b 1
)

echo [1/2] Восстановление index.html...
if exist "%ION_DIR%\index.html.cosmic.bak" (
    copy /y "%ION_DIR%\index.html.cosmic.bak" "%ION_DIR%\index.html" >nul
    del /f /q "%ION_DIR%\index.html.cosmic.bak" >nul
    echo       [OK] index.html успешно восстановлен из резервной копии.
) else (
    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
        "$html = '%ION_DIR%\index.html';" ^
        "if (Test-Path $html) {" ^
        "    $c = [System.IO.File]::ReadAllText($html, [System.Text.Encoding]::UTF8);" ^
        "    $c = $c -replace '<script src=\"/cosmic-slider\.js\"></script>', '';" ^
        "    [System.IO.File]::WriteAllText($html, $c, [System.Text.Encoding]::UTF8);" ^
        "    Write-Host '      [OK] Тег скрипта удален из index.html' -ForegroundColor Green;" ^
        "}"
)

echo.
echo [2/2] Удаление cosmic-slider.js...
if exist "%ION_DIR%\cosmic-slider.js" (
    del /f /q "%ION_DIR%\cosmic-slider.js" >nul
    echo       [OK] Файл cosmic-slider.js удален.
) else (
    echo       [i] Файл cosmic-slider.js уже отсутствовал.
)

color 0A
echo.
echo ===================================================================
echo     Мод успешно удален! Исходный интерфейс полностью возвращен.
echo ===================================================================
echo.
echo Перезапустите Claude Desktop (или нажмите Ctrl+R в его окне).
echo.
pause
