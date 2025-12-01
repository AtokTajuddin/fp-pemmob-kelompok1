@echo off
echo ===================================
echo Building FinanceFlow Android App
echo ===================================
echo.

echo Step 1: Cleaning project...
call gradlew.bat clean
if errorlevel 1 (
    echo ERROR: Clean failed!
    pause
    exit /b 1
)

echo.
echo Step 2: Building project...
call gradlew.bat assembleDebug
if errorlevel 1 (
    echo ERROR: Build failed!
    pause
    exit /b 1
)

echo.
echo ===================================
echo BUILD SUCCESSFUL!
echo ===================================
echo.
echo Your APK is located at:
echo app\build\outputs\apk\debug\app-debug.apk
echo.
echo To install on device, run:
echo gradlew.bat installDebug
echo.
pause

