@echo off
title WebScraper Server
echo ====================================
echo   WebScraper - ???...
echo ====================================
echo.

:: Check if already running
curl -s http://localhost:8765/api/health >nul 2>&1
if %errorlevel%==0 (
    echo [OK] ??????
    start http://localhost:8765
    exit /b
)

:: Check Python
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] ???? Python????? Python 3.8+
    pause
    exit /b 1
)

echo [1/3] ????...
pip install -q -r requirements.txt 2>nul

echo [2/3] ????...
cd /d "%~dp0"
start /b python server.py >nul 2>&1

echo [3/3] ??????...
:wait
timeout /t 1 /nobreak >nul
curl -s http://localhost:8765/api/health >nul 2>&1
if %errorlevel% neq 0 goto wait

echo.
echo [OK] ??????!
start http://localhost:8765