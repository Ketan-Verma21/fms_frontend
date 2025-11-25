class Shelf {
  final String shelfId;
  final String description;
  final List<ShelfFile> files;

  Shelf({
    required this.shelfId,
    required this.description,
    required this.files,
  });

  factory Shelf.fromJson(Map<String, dynamic> json) {
    return Shelf(
      shelfId: json['shelf_id'] ?? '',
      description: json['description'] ?? '',
      files: (json['files'] as List<dynamic>? ?? [])
          .map((e) => ShelfFile.fromJson(e))
          .toList(),
    );
  }
}

class ShelfFile {
  final String fileId;
  final String description;

  ShelfFile({
    required this.fileId,
    required this.description,
  });

  factory ShelfFile.fromJson(Map<String, dynamic> json) {
    return ShelfFile(
      fileId: json['file_id'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
