import 'package:hive/hive.dart';

part 'book.g.dart';

@HiveType(typeId: 0)
class Book {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String author;
  
  @HiveField(3)
  final String rack;
  
  @HiveField(4)
  final String shelf;
  
  @HiveField(5)
  final String row;
  
  @HiveField(6)
  final String position;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.rack,
    required this.shelf,
    required this.row,
    required this.position,
  });

  // Create Book from JSON (Supabase response)
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      rack: json['rack'] ?? '',
      shelf: json['shelf'] ?? '',
      row: json['row'] ?? '',
      position: json['position'] ?? '',
    );
  }

  // Convert Book to JSON (for Supabase insert/update)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'rack': rack,
      'shelf': shelf,
      'row': row,
      'position': position,
    };
  }

  // Create a copy with modified fields
  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? rack,
    String? shelf,
    String? row,
    String? position,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      rack: rack ?? this.rack,
      shelf: shelf ?? this.shelf,
      row: row ?? this.row,
      position: position ?? this.position,
    );
  }
}
