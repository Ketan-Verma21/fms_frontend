import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_client.dart';
import '../models/shelf.dart';

class ShelfRepository {
  final ApiClient _client;

  ShelfRepository(this._client);

  Future<Map<String, dynamic>> registerShelf({
    required String shelfId,
    required String description,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/shelves/',
      data: {
        "shelf_id": shelfId,
        "description": description,
      },
    );

    return response.data!;
  }

  Future<List<Shelf>> getAllShelves() async {
    final response = await _client.get<List<dynamic>>('/shelves/');
    final list = response.data ?? [];
    return list.map((e) => Shelf.fromJson(e)).toList();
  }

  Future<Shelf> getShelfDetails(String shelfId) async {
    final response = await _client.get<Map<String, dynamic>>('/shelves/$shelfId');
    return Shelf.fromJson(response.data!);
  }

  Future<List<Map<String, dynamic>>> getShelfFiles(String shelfId) async {
    final response = await _client.get<List<dynamic>>('/shelves/$shelfId/files');
    final list = response.data ?? [];
    return list.cast<Map<String, dynamic>>();
  }
}

final shelfRepositoryProvider = Provider<ShelfRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  return ShelfRepository(client);
});
