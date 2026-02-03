# Production Deployment Guide (Web)

## Prerequisites
- Supabase account (https://supabase.com)
- Flutter installed at C:\Library-App\flutter
- Chrome browser for testing

## Step 1: Configure Supabase

### Create Database Table
1. Go to your Supabase project dashboard
2. Navigate to SQL Editor
3. Run the following SQL:

```sql
-- Create books table
CREATE TABLE books (
  id BIGSERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  author TEXT NOT NULL,
  rack TEXT NOT NULL,
  shelf TEXT NOT NULL,
  row TEXT NOT NULL,
  position TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE books ENABLE ROW LEVEL SECURITY;

-- Create policy (adjust for your auth requirements)
CREATE POLICY "Allow all access to books" ON books
  FOR ALL
  USING (true)
  WITH CHECK (true);

-- Optional: Insert sample data
INSERT INTO books (title, author, rack, shelf, row, position) VALUES
  ('The Great Gatsby', 'F. Scott Fitzgerald', 'A', '2', '3', '5'),
  ('To Kill a Mockingbird', 'Harper Lee', 'B', '1', '2', '8'),
  ('1984', 'George Orwell', 'A', '3', '1', '12'),
  ('Pride and Prejudice', 'Jane Austen', 'C', '2', '4', '3'),
  ('The Catcher in the Rye', 'J.D. Salinger', 'B', '3', '2', '15'),
  ('Harry Potter and the Philosopher''s Stone', 'J.K. Rowling', 'D', '1', '1', '1'),
  ('The Hobbit', 'J.R.R. Tolkien', 'D', '1', '2', '4'),
  ('Brave New World', 'Aldous Huxley', 'A', '3', '1', '13');
```

### Get Credentials
1. Go to Settings → API
2. Copy your **Project URL** (e.g., `https://xxxxx.supabase.co`)
3. Copy your **anon/public key**

## Step 2: Update Configuration

### Disable Demo Mode
Edit `lib/config/app_config.dart`:
```dart
static const bool useDemoMode = false;  // Change to false
```

### Add Supabase Credentials
Edit `lib/config/supabase_config.dart`:
```dart
static const String supabaseUrl = 'YOUR_PROJECT_URL_HERE';
static const String supabaseAnonKey = 'YOUR_ANON_KEY_HERE';
```

## Step 3: Test Production Build

```powershell
# Test locally first
cd C:\Library-App\library_locator_app
C:\Library-App\flutter\bin\flutter pub get
C:\Library-App\flutter\bin\flutter run -d chrome
```

## Step 4: Build for Production (Web)

```powershell
cd C:\Library-App\library_locator_app
C:\Library-App\flutter\bin\flutter build web --release
```
Output: `build/web/` folder

**Or simply double-click:** `build-web.bat`

## Step 5: Deploy

### Web Hosting Options

#### Option A: Firebase Hosting
```powershell
npm install -g firebase-tools
firebase login
firebase init hosting
# Select build/web as public directory
firebase deploy
```

#### Option B: Netlify
1. Go to https://app.netlify.com
2. Drag and drop `build/web` folder
3. Done!

#### Option C: Vercel
```powershell
npm install -g vercel
cd build/web
vercel
```

#### Option D: GitHub Pages
1. Push `build/web` contents to gh-pages branch
2. Enable GitHub Pages in repository settings

#### Option E: Netlify Drop (Fastest)
1. Go to https://app.netlify.com/drop
2. Drag `build/web` folder
3. Get instant live URL (no signup needed)

## Production Checklist

- [ ] Supabase project created
- [ ] Database table created with SQL
- [ ] Credentials copied from Supabase
- [ ] `app_config.dart` updated (useDemoMode = false)
- [ ] `supabase_config.dart` updated with real credentials
- [ ] Tested locally with production settings (chrome)
- [ ] Built web version with `build-web.bat`
- [ ] Deployed `build/web` to hosting service
- [ ] Tested live deployment URL
- [ ] CSV upload feature tested
- [ ] Offline mode tested (disconnect internet)
- [ ] Mobile responsive design tested

## Security Notes

For production:
1. Update RLS policies based on your authentication requirements
2. Consider adding user authentication
3. Restrict API access if needed
4. Use environment variables for sensitive data (advanced)

## Troubleshooting

**Build fails:**
```powershell
C:\Library-App\flutter\bin\flutter clean
C:\Library-App\flutter\bin\flutter pub get
```

**Connection errors:**
- Verify Supabase credentials
- Check internet connection
- Verify RLS policies allow access

**CSV upload not working:**
- Only available on web platform
- Check file format: title,author,rack,shelf,row,position
