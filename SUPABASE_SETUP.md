# Supabase Integration for Library Locator App

## Setup Instructions

## If an old `books` table already exists

Use one of these two options.

### Option A (recommended): Drop and recreate (full overwrite)

This removes old data and creates the new schema cleanly.

```sql
-- 1) Drop old table completely
DROP TABLE IF EXISTS books;

-- 2) Create new table
CREATE TABLE books (
  id BIGSERIAL PRIMARY KEY,
  book_no TEXT NOT NULL UNIQUE,
  title TEXT NOT NULL,
  author_name TEXT NOT NULL,
  publish_year INT NOT NULL,
  price NUMERIC(10,2) NOT NULL,
  category TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3) Enable RLS
ALTER TABLE books ENABLE ROW LEVEL SECURITY;

-- 4) Recreate policy
CREATE POLICY "Allow all access to books" ON books
  FOR ALL
  USING (true)
  WITH CHECK (true);
```

### Option B: Migrate old table in-place (keep existing rows)

Use this only if you need to keep old data.

```sql
-- Add new columns (if missing)
ALTER TABLE books ADD COLUMN IF NOT EXISTS book_no TEXT;
ALTER TABLE books ADD COLUMN IF NOT EXISTS author_name TEXT;
ALTER TABLE books ADD COLUMN IF NOT EXISTS publish_year INT;
ALTER TABLE books ADD COLUMN IF NOT EXISTS price NUMERIC(10,2);
ALTER TABLE books ADD COLUMN IF NOT EXISTS category TEXT;

-- Copy legacy values where possible
UPDATE books
SET author_name = COALESCE(author_name, author, 'Unknown Author');

UPDATE books
SET book_no = COALESCE(book_no, 'B' || id::text);

UPDATE books
SET publish_year = COALESCE(publish_year, 0),
    price = COALESCE(price, 0),
    category = COALESCE(category, 'General');

-- Enforce constraints for new schema
ALTER TABLE books ALTER COLUMN book_no SET NOT NULL;
ALTER TABLE books ALTER COLUMN author_name SET NOT NULL;
ALTER TABLE books ALTER COLUMN publish_year SET NOT NULL;
ALTER TABLE books ALTER COLUMN price SET NOT NULL;
ALTER TABLE books ALTER COLUMN category SET NOT NULL;

-- Add uniqueness on book_no
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'books_book_no_key'
  ) THEN
    ALTER TABLE books ADD CONSTRAINT books_book_no_key UNIQUE (book_no);
  END IF;
END $$;

-- Optional: remove old legacy columns after verification
-- ALTER TABLE books DROP COLUMN IF EXISTS author;
-- ALTER TABLE books DROP COLUMN IF EXISTS rack;
-- ALTER TABLE books DROP COLUMN IF EXISTS shelf;
-- ALTER TABLE books DROP COLUMN IF EXISTS row;
-- ALTER TABLE books DROP COLUMN IF EXISTS position;
```

### 1. Create Supabase Project

1. Go to [https://supabase.com](https://supabase.com) and sign up/login
2. Create a new project
3. Wait for the database to initialize

### 2. Create Books Table

Run this SQL in your Supabase SQL Editor:

```sql
-- Create books table
CREATE TABLE books (
  id BIGSERIAL PRIMARY KEY,
  book_no TEXT NOT NULL UNIQUE,
  title TEXT NOT NULL,
  author_name TEXT NOT NULL,
  publish_year INT NOT NULL,
  price NUMERIC(10,2) NOT NULL,
  category TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE books ENABLE ROW LEVEL SECURITY;

-- Create policy to allow all operations (for development)
-- Adjust these policies based on your authentication requirements
CREATE POLICY "Allow all access to books" ON books
  FOR ALL
  USING (true)
  WITH CHECK (true);

-- Insert sample data (optional)
INSERT INTO books (book_no, title, author_name, publish_year, price, category) VALUES
  ('B001', 'The Great Gatsby', 'F. Scott Fitzgerald', 1925, 12.99, 'Katha'),
  ('B002', 'To Kill a Mockingbird', 'Harper Lee', 1960, 10.50, 'Sahitya'),
  ('B003', '1984', 'George Orwell', 1949, 9.99, 'Katha'),
  ('B004', 'Pride and Prejudice', 'Jane Austen', 1813, 8.75, 'Sahitya'),
  ('B005', 'The Catcher in the Rye', 'J.D. Salinger', 1951, 11.00, 'Katha'),
  ('B006', 'Harry Potter and the Philosopher''s Stone', 'J.K. Rowling', 1997, 14.25, 'Fantasy'),
  ('B007', 'The Hobbit', 'J.R.R. Tolkien', 1937, 13.40, 'Fantasy'),
  ('B008', 'Brave New World', 'Aldous Huxley', 1932, 10.20, 'Katha');
```

### 3. Configure App

1. In your Supabase project dashboard, go to **Settings** > **API**
2. Copy your **Project URL** and **anon/public key**
3. Open `lib/config/supabase_config.dart`
4. Replace the placeholder values:

```dart
static const String supabaseUrl = 'YOUR_SUPABASE_URL'; // e.g., https://xxxxx.supabase.co
static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY'; // Your anon key
```

### 4. Install Dependencies

```bash
flutter pub get
```

### 5. Run the App

```bash
# For Web
flutter run -d chrome

# For Android
flutter run -d android
```

## Features Implemented

### CRUD Operations

The app now supports full CRUD operations through Supabase:

✅ **getBooks()** - Fetches all books from the database
✅ **searchBooks(query)** - Searches books by book number, title, author, or category
✅ **addBook(book)** - Adds a new book to the database
✅ **updateBook(book)** - Updates an existing book
✅ **deleteBook(id)** - Deletes a book from the database

### UI Features

- **Search**: Real-time search by book number, title, author, or category
- **Add**: Floating action button to add new books
- **Edit**: Edit button on each book in the list
- **Delete**: Delete button with confirmation dialog
- **Refresh**: Refresh button in app bar to reload data

## Security Notes

The current RLS policy allows all operations for development. For production:

1. Implement proper authentication
2. Update RLS policies to restrict access based on user roles
3. Consider using environment variables for Supabase credentials

## Troubleshooting

### Connection Issues
- Verify your Supabase URL and anon key are correct
- Check your internet connection
- Ensure your Supabase project is active

### Database Errors
- Verify the `books` table exists in your Supabase database
- Check that RLS policies are configured correctly
- Review the SQL queries in Supabase SQL Editor for any errors
