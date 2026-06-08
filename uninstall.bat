@echo off
echo ???? WebScraper ?????...
del "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\WebScraper.vbs" 2>nul
if exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\WebScraper.vbs" (
    echo [ERROR] ????
) else (
    echo [OK] ????????
)
echo.
echo ??????...
taskkill /F /IM python.exe 2>nul
taskkill /F /IM pythonw.exe 2>nul
echo [OK] ???
pause