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
  
  late final TextEditingController _bookNoController;
  late final TextEditingController _titleController;
  late final TextEditingController _authorNameController;
  late final TextEditingController _publishYearController;
  late final TextEditingController _priceController;
  late final TextEditingController _categoryController;
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _bookNoController = TextEditingController(text: widget.book?.bookNo ?? '');
    _titleController = TextEditingController(text: widget.book?.title ?? '');
    _authorNameController = TextEditingController(text: widget.book?.authorName ?? '');
    _publishYearController = TextEditingController(
      text: widget.book != null ? widget.book!.publishYear.toString() : '',
    );
    _priceController = TextEditingController(
      text: widget.book != null ? widget.book!.price.toString() : '',
    );
    _categoryController = TextEditingController(text: widget.book?.category ?? '');
  }

  @override
  void dispose() {
    _bookNoController.dispose();
    _titleController.dispose();
    _authorNameController.dispose();
    _publishYearController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
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
      final publishYear = int.tryParse(_publishYearController.text.trim());
      final price = double.tryParse(_priceController.text.trim());

      if (publishYear == null || price == null) {
        throw Exception('Publish year and price must be valid numbers');
      }

      final book = Book(
        id: widget.book?.id ?? '',
        bookNo: _bookNoController.text.trim(),
        title: _titleController.text.trim(),
        authorName: _authorNameController.text.trim(),
        publishYear: publishYear,
        price: price,
        category: _categoryController.text.trim(),
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
                      controller: _bookNoController,
                      decoration: const InputDecoration(
                        labelText: 'Book No.',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a book number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
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
                      controller: _authorNameController,
                      decoration: const InputDecoration(
                        labelText: 'Author Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter an author name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _publishYearController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Publish Year',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter publish year';
                        }
                        if (int.tryParse(value.trim()) == null) {
                          return 'Please enter a valid year';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _priceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter price';
                        }
                        if (double.tryParse(value.trim()) == null) {
                          return 'Please enter a valid price';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _categoryController,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter category';
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
