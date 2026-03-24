import 'package:flutter/material.dart';
import '../models/book.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;

  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Book No.', book.bookNo),
            const SizedBox(height: 16),
            _buildDetailRow('Title', book.title),
            const SizedBox(height: 16),
            _buildDetailRow('Author Name', book.authorName),
            const SizedBox(height: 16),
            _buildDetailRow('Publish Year', book.publishYear.toString()),
            const SizedBox(height: 16),
            _buildDetailRow('Price', book.price.toStringAsFixed(2)),
            const SizedBox(height: 16),
            _buildDetailRow('Category', book.category),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
