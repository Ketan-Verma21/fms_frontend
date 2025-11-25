class FileModel {
  final String fileNo;
  final String description;
  final String shelfId;
  final String placedBy;
  final String updatedAt;

  FileModel({
    required this.fileNo,
    required this.description,
    required this.shelfId, required this.placedBy, required this.updatedAt,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      fileNo: json['file_id'],
      description: json['description'],
      shelfId: json['shelf_id'] ?? 'Unassigned',
      placedBy: json['placed_by'] ?? 'Unknown',
      updatedAt: json['updated_at'] ?? 'No Data',

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'file_id': fileNo,
      'description': description,
      'shelf_id': shelfId,
      'placed_by':placedBy,
      'updated_at':updatedAt
    };
  }
}
