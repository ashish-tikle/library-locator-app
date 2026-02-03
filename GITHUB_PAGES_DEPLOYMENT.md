# GitHub Pages Deployment Guide

## Prerequisites
- GitHub account (free at https://github.com)
- Git installed on your machine

## Step 1: Create GitHub Repository

1. Go to https://github.com/new
2. Repository name: `library-locator-app` (or your choice)
3. Set to **Public** (required for free GitHub Pages)
4. Do NOT initialize with README (we have existing code)
5. Click "Create repository"

## Step 2: Build Your App

```powershell
cd C:\Library-App\library_locator_app
C:\Library-App\flutter\bin\flutter build web --release
```

Or double-click: `build-web.bat`

## Step 3: Initialize Git (if not already done)

```powershell
cd C:\Library-App\library_locator_app
git init
git add .
git commit -m "Initial commit - Library Locator App"
```

## Step 4: Push to GitHub

Replace `YOUR_USERNAME` with your GitHub username:

```powershell
git remote add origin https://github.com/YOUR_USERNAME/library-locator-app.git
git branch -M main
git push -u origin main
```

## Step 5: Deploy to GitHub Pages

### Method A: Using gh-pages branch (Recommended)

```powershell
# Install git if not present
# Then create gh-pages branch with just the build
git checkout --orphan gh-pages
git rm -rf .
Copy-Item -Path build\web\* -Destination . -Recurse
git add .
git commit -m "Deploy to GitHub Pages"
git push origin gh-pages
git checkout main
```

### Method B: Manual Upload (Simpler)

1. Go to your repository on GitHub
2. Click "Add file" → "Upload files"
3. Drag all files from `build/web` folder
4. Select branch: Create new branch named `gh-pages`
5. Commit changes

## Step 6: Enable GitHub Pages

1. Go to your repository on GitHub
2. Click **Settings** tab
3. Click **Pages** in left sidebar
4. Under "Build and deployment":
   - Source: "Deploy from a branch"
   - Branch: Select `gh-pages` and `/` (root)
5. Click **Save**

## Step 7: Access Your Site

After 1-2 minutes, your site will be live at:
```
https://YOUR_USERNAME.github.io/library-locator-app/
```

## Optional: Add Custom Domain

1. Buy a domain (e.g., from Namecheap, Google Domains)
2. In GitHub repository settings → Pages:
   - Enter your custom domain
   - Enable "Enforce HTTPS"
3. Update your domain's DNS settings:
   - Add CNAME record pointing to `YOUR_USERNAME.github.io`

## Automatic Deployment with GitHub Actions

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [ main ]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.5'
          
      - name: Install dependencies
        run: flutter pub get
        
      - name: Build web
        run: flutter build web --release --base-href /library-locator-app/
        
      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./build/web
```

With this workflow, every push to main automatically rebuilds and deploys!

## Updating Your Site

After making changes:

```powershell
# Build new version
C:\Library-App\flutter\bin\flutter build web --release

# If using gh-pages branch manually:
git checkout gh-pages
Copy-Item -Path build\web\* -Destination . -Recurse -Force
git add .
git commit -m "Update site"
git push origin gh-pages
git checkout main
```

Or if using GitHub Actions, just:
```powershell
git add .
git commit -m "Your changes"
git push
```

## Troubleshooting

**404 Error:**
- Wait 2-3 minutes after enabling Pages
- Check branch is set to `gh-pages`
- Verify `index.html` exists in root of gh-pages branch

**Assets not loading:**
- Update base href in build command:
  ```powershell
  C:\Library-App\flutter\bin\flutter build web --release --base-href /library-locator-app/
  ```

**Custom domain not working:**
- Verify DNS propagation (24-48 hours)
- Check CNAME file exists in gh-pages root
- Enable "Enforce HTTPS" in settings

## Quick Reference

Your site URL: `https://YOUR_USERNAME.github.io/library-locator-app/`

Update site:
1. Make changes
2. Build: `build-web.bat`
3. Push to gh-pages branch
4. Wait 1-2 minutes
