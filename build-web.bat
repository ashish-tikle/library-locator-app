@echo off
echo ========================================
echo  Library Locator - Web Build Script
echo ========================================
echo.

cd /d "%~dp0"

echo [1/4] Cleaning previous build...
C:\Library-App\flutter\bin\flutter clean

echo.
echo [2/4] Getting dependencies...
C:\Library-App\flutter\bin\flutter pub get

echo.
echo [3/4] Building for web (release mode)...
C:\Library-App\flutter\bin\flutter build web --release

echo.
echo [4/4] Build complete!
echo.
echo Output location: build\web\
echo.
echo Next steps:
echo - Upload build\web folder to your hosting provider
echo - Or run: firebase deploy (if using Firebase)
echo.
pause
