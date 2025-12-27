import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/file_model.dart';
import '../repository/supabase_file_repository.dart';

class RegisterFileController extends StateNotifier<AsyncValue<FileModel?>> {
  final SupabaseFileRepository repo;

  RegisterFileController(this.repo)
      : super(const AsyncValue.data(null));

  Future<void> register({
    required String fileNo,
    required String description,
    required String placedBy,
  }) async {
    state = const AsyncValue.loading();

    try {
      final file = await repo.createFile(
        fileId: fileNo,
        description: description,
        placedBy: placedBy,
      );
      state = AsyncValue.data(file);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final registerFileProvider =
StateNotifierProvider<RegisterFileController, AsyncValue<FileModel?>>((ref) {
  return RegisterFileController(ref.watch(supabaseFileRepositoryProvider));
});
