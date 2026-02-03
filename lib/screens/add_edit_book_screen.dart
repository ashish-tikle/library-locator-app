import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/supabase_service.dart';

class AddEditBookScreen extends StatefulWidget {
  final Book? book;

  const AddEditBookScreen({super.key, this.book});

  @override
  State<AddEditBookScreen> createState() => _AddEditBookScreenState();
}

class _AddEditBookScreenState extends State<AddEditBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _supabaseService = SupabaseService();
  
  late final TextEditingController _titleController;
  late final TextEditingController _authorController;
  late final TextEditingController _rackController;
  late final TextEditingController _shelfController;
  late final TextEditingController _rowController;
  late final TextEditingController _positionController;
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book?.title ?? '');
    _authorController = TextEditingController(text: widget.book?.author ?? '');
    _rackController = TextEditingController(text: widget.book?.rack ?? '');
    _shelfController = TextEditingController(text: widget.book?.shelf ?? '');
    _rowController = TextEditingController(text: widget.book?.row ?? '');
    _positionController = TextEditingController(text: widget.book?.position ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _rackController.dispose();
    _shelfController.dispose();
    _rowController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  Future<void> _saveBook() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final book = Book(
        id: widget.book?.id ?? '',
        title: _titleController.text.trim(),
        author: _authorController.text.trim(),
        rack: _rackController.text.trim(),
        shelf: _shelfController.text.trim(),
        row: _rowController.text.trim(),
        position: _positionController.text.trim(),
      );

      if (widget.book == null) {
        // Add new book
        await _supabaseService.addBook(book);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Book added successfully')),
          );
        }
      } else {
        // Update existing book
        await _supabaseService.updateBook(book);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Book updated successfully')),
          );
        }
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save book: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.book != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Book' : 'Add Book'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _authorController,
                      decoration: const InputDecoration(
                        labelText: 'Author',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter an author';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Location',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _rackController,
                      decoration: const InputDecoration(
                        labelText: 'Rack',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a rack';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _shelfController,
                      decoration: const InputDecoration(
                        labelText: 'Shelf',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a shelf';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _rowController,
                      decoration: const InputDecoration(
                        labelText: 'Row',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a row';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _positionController,
                      decoration: const InputDecoration(
                        labelText: 'Position',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a position';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _saveBook,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        isEditing ? 'Update Book' : 'Add Book',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
