import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive/hive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/book.dart';
import '../config/app_config.dart';
import '../data/sample_books.dart';

class SupabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;
  static const String tableName = 'books';
  final Box<Book> _bookBox = Hive.box<Book>('books');

  // Initialize demo data
  Future<void> _initDemoData() async {
    if (_bookBox.isEmpty) {
      for (var book in sampleBooks) {
        await _bookBox.put(book.id, book);
      }
    }
  }

  // Check if device is online
  Future<bool> _isOnline() async {
    if (AppConfig.simulateOffline) return false;
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult.contains(ConnectivityResult.mobile) ||
           connectivityResult.contains(ConnectivityResult.wifi) ||
           connectivityResult.contains(ConnectivityResult.ethernet);
  }

  // Get all books (with offline support)
  Future<List<Book>> getBooks() async {
    try {
      // Use demo mode for local testing
      if (AppConfig.useDemoMode) {
        await _initDemoData();
        return _bookBox.values.toList()
          ..sort((a, b) => a.title.compareTo(b.title));
      }

      final isOnline = await _isOnline();
      
      if (isOnline) {
        // Fetch from Supabase
        final response = await _supabase
            .from(tableName)
            .select()
            .order('title', ascending: true);
        
        final books = (response as List)
            .map((json) => Book.fromJson(json))
            .toList();
        
        // Cache in Hive
        await _bookBox.clear();
        for (var book in books) {
          await _bookBox.put(book.id, book);
        }
        
        return books;
      } else {
        // Return cached books
        return _bookBox.values.toList()
          ..sort((a, b) => a.title.compareTo(b.title));
      }
    } catch (e) {
      // If online fetch fails, return cached data
      return _bookBox.values.toList()
        ..sort((a, b) => a.title.compareTo(b.title));
    }
  }

  // Search books by title or author (with offline support)
  Future<List<Book>> searchBooks(String query) async {
    try {
      if (query.isEmpty) {
        return await getBooks();
      }

      // Use demo mode for local testing
      if (AppConfig.useDemoMode) {
        await _initDemoData();
        final allBooks = _bookBox.values.toList();
        return allBooks.where((book) {
          return book.title.toLowerCase().contains(query.toLowerCase()) ||
                 book.author.toLowerCase().contains(query.toLowerCase());
        }).toList()
          ..sort((a, b) => a.title.compareTo(b.title));
      }

      final isOnline = await _isOnline();
      
      if (isOnline) {
        // Search on Supabase
        final response = await _supabase
            .from(tableName)
            .select()
            .or('title.ilike.%$query%,author.ilike.%$query%')
            .order('title', ascending: true);

        final books = (response as List)
            .map((json) => Book.fromJson(json))
            .toList();
        
        return books;
      } else {
        // Search locally in cache
        final allBooks = _bookBox.values.toList();
        return allBooks.where((book) {
          return book.title.toLowerCase().contains(query.toLowerCase()) ||
                 book.author.toLowerCase().contains(query.toLowerCase());
        }).toList()
          ..sort((a, b) => a.title.compareTo(b.title));
      }
    } catch (e) {
      // Fallback to local search
      final allBooks = _bookBox.values.toList();
      return allBooks.where((book) {
        return book.title.toLowerCase().contains(query.toLowerCase()) ||
               book.author.toLowerCase().contains(query.toLowerCase());
      }).toList()
        ..sort((a, b) => a.title.compareTo(b.title));
    }
  }

  // Add a new book
  Future<Book> addBook(Book book) async {
    // In demo mode, just add to local storage
    if (AppConfig.useDemoMode) {
      final newBook = Book(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: book.title,
        author: book.author,
        rack: book.rack,
        shelf: book.shelf,
        row: book.row,
        position: book.position,
      );
      await _bookBox.put(newBook.id, newBook);
      return newBook;
    }

    try {
      final response = await _supabase
          .from(tableName)
          .insert({
            'title': book.title,
            'author': book.author,
            'rack': book.rack,
            'shelf': book.shelf,
            'row': book.row,
            'position': book.position,
          })
          .select()
          .single();

      final newBook = Book.fromJson(response);
      
      // Cache the new book
      await _bookBox.put(newBook.id, newBook);
      
      return newBook;
    } catch (e) {
      throw Exception('Failed to add book: $e');
    }
  }

  // Update an existing book
  Future<Book> updateBook(Book book) async {
    // In demo mode, just update local storage
    if (AppConfig.useDemoMode) {
      await _bookBox.put(book.id, book);
      return book;
    }

    try {
      final response = await _supabase
          .from(tableName)
          .update({
            'title': book.title,
            'author': book.author,
            'rack': book.rack,
            'shelf': book.shelf,
            'row': book.row,
            'position': book.position,
          })
          .eq('id', book.id)
          .select()
          .single();

      final updatedBook = Book.fromJson(response);
      
      // Update cache
      await _bookBox.put(updatedBook.id, updatedBook);
      
      return updatedBook;
    } catch (e) {
      throw Exception('Failed to update book: $e');
    }
  }

  // Delete a book
  Future<void> deleteBook(String id) async {
    // In demo mode, just remove from local storage
    if (AppConfig.useDemoMode) {
      await _bookBox.delete(id);
      return;
    }

    try {
      await _supabase
          .from(tableName)
          .delete()
          .eq('id', id);
      
      // Remove from cache
      await _bookBox.delete(id);
    } catch (e) {
      throw Exception('Failed to delete book: $e');
    }
  }

  // Get cached books count
  int getCachedBooksCount() {
    return _bookBox.length;
  }

  // Clear cache
  Future<void> clearCache() async {
    await _bookBox.clear();
  }
}
