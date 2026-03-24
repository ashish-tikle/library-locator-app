// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookAdapter extends TypeAdapter<Book> {
  @override
  final int typeId = 0;

  @override
  Book read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    final isLegacyFormat = fields[4] is! int;

    if (isLegacyFormat) {
      return Book(
        id: (fields[0] ?? '').toString(),
        bookNo: (fields[0] ?? '').toString(),
        title: (fields[1] ?? '').toString(),
        authorName: (fields[2] ?? '').toString(),
        publishYear: 0,
        price: 0,
        category: '',
      );
    }

    return Book(
      id: fields[0] as String,
      bookNo: fields[1] as String,
      title: fields[2] as String,
      authorName: fields[3] as String,
      publishYear: fields[4] as int,
      price: _toDouble(fields[5]),
      category: fields[6] as String,
    );
  }

  double _toDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  @override
  void write(BinaryWriter writer, Book obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
        ..write(obj.bookNo)
        ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
        ..write(obj.authorName)
      ..writeByte(4)
        ..write(obj.publishYear)
      ..writeByte(5)
        ..write(obj.price)
      ..writeByte(6)
        ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
