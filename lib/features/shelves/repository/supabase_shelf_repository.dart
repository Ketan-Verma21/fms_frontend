import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';
import '../models/shelf.dart';

/// Supabase-based shelf repository that mirrors the Python backend functionality
class SupabaseShelfRepository {
  SupabaseShelfRepository(this._supabase);

  final SupabaseClient _supabase;

  /// Register a shelf (matches POST /shelves/)
  /// The shelf QR should contain this shelf_id
  Future<Map<String, dynamic>> createShelf({
    required String shelfId,
    required String description,
  }) async {
    // Check if shelf already exists
    final existingResponse = await _supabase
        .from('shelves')
        .select('shelf_id')
        .eq('shelf_id', shelfId)
        .maybeSingle();

    if (existingResponse != null) {
      throw Exception('Shelf with this ID already exists');
    }

    // Insert new shelf
    final data = {
      'shelf_id': shelfId,
      'description': description,
    };

    final response = await _supabase
        .from('shelves')
        .insert(data)
        .select()
        .single();

    return response;
  }

  /// List all shelves along with files currently placed on them (matches GET /shelves/)
  Future<List<Shelf>> listShelves() async {
    // Get all shelves
    final shelvesResponse = await _supabase.from('shelves').select('*');
    final shelves = (shelvesResponse as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();
    shelves.sort((a, b) => a['description'].compareTo(b['description']));
    // Get all files grouped by shelf_id
    final filesResponse = await _supabase
        .from('office_files')
        .select('file_id, description, shelf_id');

    final filesByShelf = <String, List<Map<String, dynamic>>>{};
    for (final record in filesResponse as List) {
      final fileMap = record as Map<String, dynamic>;
      final shelfId = fileMap['shelf_id'] as String?;
      if (shelfId == null) continue;

      filesByShelf.putIfAbsent(shelfId, () => []).add({
        'file_id': fileMap['file_id'],
        'description': fileMap['description'],
      });
    }

    // Combine shelves with their files
    final result = <Shelf>[];
    for (final shelf in shelves) {
      final shelfId = shelf['shelf_id'] as String;
      final files = filesByShelf[shelfId] ?? [];
      result.add(
        Shelf(
          shelfId: shelfId,
          description: shelf['description'] as String? ?? '',
          files: files
              .map((f) => ShelfFile(
                    fileId: f['file_id'] as String? ?? '',
                    description: f['description'] as String? ?? '',
                  ))
              .toList(),
        ),
      );
    }

    return result;
  }

  /// Get a specific shelf and the files on it (matches GET /shelves/{shelf_id})
  Future<Shelf> getShelf(String shelfId) async {
    final response = await _supabase
        .from('shelves')
        .select('*')
        .eq('shelf_id', shelfId)
        .maybeSingle();

    if (response == null) {
      throw Exception('Shelf not found');
    }

    // Get files on this shelf
    final filesResponse = await _supabase
        .from('office_files')
        .select('file_id, description')
        .eq('shelf_id', shelfId);

    final files = (filesResponse as List)
        .map((e) {
          final fileMap = e as Map<String, dynamic>;
          return ShelfFile(
            fileId: fileMap['file_id'] as String? ?? '',
            description: fileMap['description'] as String? ?? '',
          );
        })
        .toList();
    return Shelf(
      shelfId: response['shelf_id'] as String? ?? '',
      description: response['description'] as String? ?? '',
      files: files,
    );
  }

  /// Get all files currently on a given shelf (matches GET /shelves/{shelf_id}/files)
  Future<List<Map<String, dynamic>>> getFilesOnShelf(String shelfId) async {
    // Verify shelf exists
    final shelfResponse = await _supabase
        .from('shelves')
        .select('shelf_id')
        .eq('shelf_id', shelfId)
        .maybeSingle();

    if (shelfResponse == null) {
      throw Exception('Shelf not found');
    }

    // Get files on this shelf with audit metadata
    final filesResponse = await _supabase
        .from('office_files')
        .select('file_id, description, placed_by, updated_at')
        .eq('shelf_id', shelfId);
    
    return (filesResponse as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();
  }
}

final supabaseShelfRepositoryProvider =
    Provider<SupabaseShelfRepository>((ref) {
  return SupabaseShelfRepository(ref.watch(supabaseClientProvider));
});

