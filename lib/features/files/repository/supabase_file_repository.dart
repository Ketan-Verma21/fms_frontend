import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';
import '../models/file_model.dart';

/// Supabase-based file repository that mirrors the Python backend functionality
class SupabaseFileRepository {
  SupabaseFileRepository(this._supabase);

  final SupabaseClient _supabase;

  /// Register a file in the system (matches POST /files/)
  /// Rejects duplicate file_id, inserts row into office_files
  Future<FileModel> createFile({
    required String fileId,
    required String description,
    required String placedBy,
  }) async {
    // Check if file already exists
    final existingResponse = await _supabase
        .from('office_files')
        .select('file_id')
        .eq('file_id', fileId)
        .maybeSingle();

    if (existingResponse != null) {
      throw Exception('File with this ID already exists');
    }

    // Insert new file
    final data = {
      'file_id': fileId,
      'description': description,
      'shelf_id': 'Not Assigned',
      'placed_by': placedBy,
    };

    final response = await _supabase
        .from('office_files')
        .insert(data)
        .select()
        .single();

    return FileModel.fromJson(response);
  }

  /// Assign/move a file to a shelf after scanning both QRs (matches POST /files/assign)
  /// Verifies shelf + file exist, updates shelf_id/placed_by
  Future<FileModel> assignFileToShelf({
    required String fileId,
    required String shelfId,
    required String placedBy,
  }) async {
    // Verify shelf exists
    final shelfResponse = await _supabase
        .from('shelves')
        .select('shelf_id')
        .eq('shelf_id', shelfId)
        .maybeSingle();

    if (shelfResponse == null) {
      throw Exception('Shelf not found');
    }

    // Verify file exists
    final fileResponse = await _supabase
        .from('office_files')
        .select('file_id')
        .eq('file_id', fileId)
        .maybeSingle();

    if (fileResponse == null) {
      throw Exception('File not found');
    }

    // Update file location
    final updatePayload = {
      'shelf_id': shelfId,
      'placed_by': placedBy,
    };

    final updateResponse = await _supabase
        .from('office_files')
        .update(updatePayload)
        .eq('file_id', fileId)
        .select()
        .single();

    return FileModel.fromJson(updateResponse);
  }

  /// List all files with their current shelf (matches GET /files/)
  Future<List<FileModel>> listFiles() async {
    final response = await _supabase.from('office_files').select('*');

    return (response as List)
        .map((e) => FileModel.fromJson(e as Map<String, dynamic>))
        .toList()..sort((a, b) => a.description.compareTo(b.description));
  }

  /// Get a single file by its ID (matches GET /files/{file_id})
  Future<FileModel> getFile(String fileId) async {
    final response = await _supabase
        .from('office_files')
        .select('*')
        .eq('file_id', fileId)
        .maybeSingle();

    if (response == null) {
      throw Exception('File not found');
    }

    return FileModel.fromJson(response);
  }

  /// Update the description/notes for a file (matches PUT /files/description)
  Future<FileModel> updateFileDescription({
    required String fileId,
    required String description,
  }) async {
    // Verify file exists
    final fileResponse = await _supabase
        .from('office_files')
        .select('file_id')
        .eq('file_id', fileId)
        .maybeSingle();

    if (fileResponse == null) {
      throw Exception('File not found');
    }

    // Update description
    final updateResponse = await _supabase
        .from('office_files')
        .update({'description': description})
        .eq('file_id', fileId)
        .select()
        .single();

    return FileModel.fromJson(updateResponse);
  }
}

final supabaseFileRepositoryProvider =
    Provider<SupabaseFileRepository>((ref) {
  return SupabaseFileRepository(ref.watch(supabaseClientProvider));
});

