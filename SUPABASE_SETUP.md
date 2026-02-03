# Supabase Integration for Library Locator App

## Setup Instructions

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

-- Create policy to allow all operations (for development)
-- Adjust these policies based on your authentication requirements
CREATE POLICY "Allow all access to books" ON books
  FOR ALL
  USING (true)
  WITH CHECK (true);

-- Insert sample data (optional)
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
✅ **searchBooks(query)** - Searches books by title or author
✅ **addBook(book)** - Adds a new book to the database
✅ **updateBook(book)** - Updates an existing book
✅ **deleteBook(id)** - Deletes a book from the database

### UI Features

- **Search**: Real-time search by title or author
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
