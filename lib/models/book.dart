import 'package:hive/hive.dart';

part 'book.g.dart';

@HiveType(typeId: 0)
class Book {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String bookNo;

  @HiveField(2)
  final String title;
  
  @HiveField(3)
  final String authorName;
  
  @HiveField(4)
  final int publishYear;
  
  @HiveField(5)
  final double price;
  
  @HiveField(6)
  final String category;

  Book({
    required this.id,
    required this.bookNo,
    required this.title,
    required this.authorName,
    required this.publishYear,
    required this.price,
    required this.category,
  });

  // Create Book from JSON (Supabase response)
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'].toString(),
      bookNo: json['book_no']?.toString() ?? '',
      title: json['title'] ?? '',
      authorName: json['author_name'] ?? json['author'] ?? '',
      publishYear: _parseInt(json['publish_year']),
      price: _parseDouble(json['price']),
      category: json['category'] ?? '',
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static double _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  // Convert Book to JSON (for Supabase insert/update)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'book_no': bookNo,
      'title': title,
      'author_name': authorName,
      'publish_year': publishYear,
      'price': price,
      'category': category,
    };
  }

  // Create a copy with modified fields
  Book copyWith({
    String? id,
    String? bookNo,
    String? title,
    String? authorName,
    int? publishYear,
    double? price,
    String? category,
  }) {
    return Book(
      id: id ?? this.id,
      bookNo: bookNo ?? this.bookNo,
      title: title ?? this.title,
      authorName: authorName ?? this.authorName,
      publishYear: publishYear ?? this.publishYear,
      price: price ?? this.price,
      category: category ?? this.category,
    );
  }
}
