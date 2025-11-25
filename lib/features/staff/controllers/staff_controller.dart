import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/staff_repository.dart';
import 'staff_state.dart';

class StaffController extends StateNotifier<StaffState> {
  StaffController(this._repository) : super(StaffState.initial());

  final StaffRepository _repository;

  Future<void> searchByName(String name) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final list = await _repository.searchByName(name);
      state = state.copyWith(isLoading: false, results: list);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to fetch staff',
      );
    }
  }

  Future<void> searchByEmail(String email) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final list = await _repository.searchByEmail(email);
      state = state.copyWith(isLoading: false, results: list);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to fetch staff',
      );
    }
  }
}

final staffControllerProvider =
StateNotifierProvider<StaffController, StaffState>((ref) {
  final repo = ref.read(staffRepositoryProvider);
  return StaffController(repo);
});
