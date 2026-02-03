@echo off
echo ========================================
echo  Deploy to GitHub Pages
echo ========================================
echo.

cd /d "%~dp0"

echo [1/5] Building web version...
C:\Library-App\flutter\bin\flutter build web --release --base-href /library-locator-app/

echo.
echo [2/5] Switching to gh-pages branch...
git checkout gh-pages 2>nul || git checkout --orphan gh-pages

echo.
echo [3/5] Copying build files...
xcopy /E /Y /I build\web\* .

echo.
echo [4/5] Committing changes...
git add .
git commit -m "Deploy to GitHub Pages - %date% %time%"

echo.
echo [5/5] Pushing to GitHub...
git push origin gh-pages

echo.
echo Switching back to main branch...
git checkout main

echo.
echo ========================================
echo  Deployment Complete!
echo ========================================
echo.
echo Your site will be live in 1-2 minutes at:
echo https://YOUR_USERNAME.github.io/library-locator-app/
echo.
echo Remember to replace YOUR_USERNAME with your actual GitHub username
echo.
pause
