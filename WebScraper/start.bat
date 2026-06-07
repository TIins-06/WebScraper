@echo off
chcp 936 >nul
title WebScraper - Universal Web Scraping Tool
color 0B

echo.
echo  ========================================
echo        WebScraper - Starting...
echo  ========================================
echo.

where python >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python not found. Please install Python 3.8+
    echo Download: https://www.python.org/downloads/
    pause
    exit /b 1
)

echo [1/3] Installing dependencies...
cd /d "%~dp0"
python -m pip install -r requirements.txt --quiet --disable-pip-version-check

echo [2/3] Installing Playwright (optional)...
python -m pip install playwright --quiet --disable-pip-version-check 2>nul
if %errorlevel% equ 0 (
    python -m playwright install chromium --quiet 2>nul
)

echo [3/3] Starting server...
echo.
echo  ========================================
echo   Server: http://localhost:8765
echo   Press Ctrl+C to stop
echo  ========================================
echo.

start "" /b cmd /c "timeout /t 2 /nobreak >nul && start http://localhost:8765"

python server.py
pause