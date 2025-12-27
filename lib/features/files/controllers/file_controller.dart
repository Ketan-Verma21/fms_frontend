import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/file_model.dart';
import '../repository/supabase_file_repository.dart';

class FilesController extends StateNotifier<AsyncValue<List<FileModel>>> {
  final SupabaseFileRepository repo;

  FilesController(this.repo) : super(const AsyncValue.loading()) {
    loadFiles();
  }

  Future<void> loadFiles() async {
    try {
      final files = await repo.listFiles();
      state = AsyncValue.data(files);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  Future<void> refresh() async {
    await loadFiles();
  }
}

final filesControllerProvider =
StateNotifierProvider<FilesController, AsyncValue<List<FileModel>>>((ref) {
  return FilesController(ref.watch(supabaseFileRepositoryProvider));
});
