import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_client.dart';
import '../models/file_model.dart';

class FilesRepository {
  final ApiClient _client;

  FilesRepository(this._client);

  // GET all files
  Future<List<FileModel>> getAllFiles() async {
    final response = await _client.get<List<dynamic>>("/files/");
    final list = response.data ?? [];
    return list.map((e) => FileModel.fromJson(e)).toList();
  }

  // Register a new file
  Future<FileModel> registerFile(String fileNo, String desc, String placedBy) async {
    final response = await _client.post<Map<String, dynamic>>(
      "/files/",
      data: {
        "file_id": fileNo,
        "description": desc,
        "placed_by": placedBy,
      },
    );
    print("yes");
    print(response.data!['data']);
    return FileModel.fromJson(response.data!["data"]);
  }

  // Assign file to shelf
  Future<void> assignShelf(String fileNo, String shelfId, String placedBy) async {
    print("yes");
    var res=await _client.post(
      "/files/assign",
      data: {
        "file_id": fileNo,
        "shelf_id": shelfId,
        "placed_by": placedBy,
      },
    );
    print(res.statusCode);
  }

  // Update description
  Future<void> updateDescription(String fileNo, String desc) async {
    await _client.put(
      "/files/description",
      data: {
        "file_id": fileNo,
        "description": desc,
      },
    );
  }
}

final filesRepositoryProvider = Provider<FilesRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  return FilesRepository(client);
});
