import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/shelf.dart';
import '../repository/shelf_repository.dart';

// ------------ Load all shelves -------------
final shelvesProvider = FutureProvider<List<Shelf>>((ref) async {
  final repo = ref.watch(shelfRepositoryProvider);
  return repo.getAllShelves();
});

// ------------ Register shelf controller -------------
class RegisterShelfController extends StateNotifier<AsyncValue<bool>> {
  RegisterShelfController(this._repo) : super(const AsyncValue.data(false));

  final ShelfRepository _repo;

  Future<void> register(String shelfId, String description) async {
    state = const AsyncValue.loading();
    try {
      await _repo.registerShelf(shelfId: shelfId, description: description);
      state = const AsyncValue.data(true);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final registerShelfProvider =
StateNotifierProvider<RegisterShelfController, AsyncValue<bool>>((ref) {
  return RegisterShelfController(ref.watch(shelfRepositoryProvider));
});

// ------------ Shelf Details -------------
final shelfDetailsProvider =
FutureProvider.family<Shelf, String>((ref, shelfId) async {
  return ref.watch(shelfRepositoryProvider).getShelfDetails(shelfId);
});

// ------------ Shelf Files -------------
final shelfFilesProvider =
FutureProvider.family<List<Map<String, dynamic>>, String>(
        (ref, shelfId) async {
      return ref.watch(shelfRepositoryProvider).getShelfFiles(shelfId);
    });
