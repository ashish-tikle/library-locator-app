# Quick Start Scripts

## Local Development (Demo Mode)
```powershell
C:\Library-App\flutter\bin\flutter run -d chrome
```

## Production Build (Web Only)

Double-click: `build-web.bat`

Or run manually:
```powershell
C:\Library-App\flutter\bin\flutter build web --release
```

Output will be in: `build/web/`

## Configuration

Before building for production:

1. **Set Production Mode**
   - Edit `lib/config/app_config.dart`
   - Set `useDemoMode = false`

2. **Add Supabase Credentials**
   - Edit `lib/config/supabase_config.dart`
   - Add your Supabase URL and anon key

3. **Test Locally**
   ```powershell
   C:\Library-App\flutter\bin\flutter run -d chrome
   ```

4. **Build & Deploy**
   - Run build script for your platform
   - Upload to hosting service

See `PRODUCTION.md` for detailed deployment instructions.
