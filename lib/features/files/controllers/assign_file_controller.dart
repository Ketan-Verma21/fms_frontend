import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/file_repository.dart';

class AssignFileController extends StateNotifier<AsyncValue<bool>> {
  final FilesRepository repo;

  AssignFileController(this.repo) : super(const AsyncValue.data(false));

  String? scannedShelfId;
  String? scannedFileId;

  void setShelf(String shelf) {
    scannedShelfId = shelf;
  }

  void setFile(String file) {
    scannedFileId = file;
  }

  Future<void> assignFile(String placedBy) async {
    if (scannedShelfId == null || scannedFileId == null) {
      state = AsyncValue.error("Shelf or File not scanned", StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();
    try {
      await repo.assignShelf(scannedFileId!, scannedShelfId!, placedBy);

      /// Keep SHELF → clear only FILE
      scannedFileId = null;

      state = const AsyncValue.data(true);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void resetStatus() {
    state = const AsyncValue.data(false);
  }
}

final assignFileProvider =
StateNotifierProvider<AssignFileController, AsyncValue<bool>>((ref) {
  return AssignFileController(ref.watch(filesRepositoryProvider));
});
