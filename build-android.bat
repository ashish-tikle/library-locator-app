@echo off
echo ========================================
echo  Library Locator - Android Build Script
echo ========================================
echo.

cd /d "%~dp0"

echo [1/4] Cleaning previous build...
C:\Library-App\flutter\bin\flutter clean

echo.
echo [2/4] Getting dependencies...
C:\Library-App\flutter\bin\flutter pub get

echo.
echo [3/4] Building APK (release mode)...
C:\Library-App\flutter\bin\flutter build apk --release

echo.
echo [4/4] Build complete!
echo.
echo Output location: build\app\outputs\flutter-apk\app-release.apk
echo.
echo APK size: 
dir /b build\app\outputs\flutter-apk\app-release.apk
echo.
echo You can now install this APK on Android devices or upload to Play Store
echo.
pause
