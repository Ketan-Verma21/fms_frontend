import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/staff_repository.dart';
import 'staff_state.dart';

class StaffController extends StateNotifier<StaffState> {
  StaffController(this._repository) : super(StaffState.initial());

  final StaffRepository _repository;

  Future<void> searchByName(String name) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        error: 'Please enter a name to search',
        results: [],
      );
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final list = await _repository.searchByName(trimmedName);
      state = state.copyWith(isLoading: false, results: list);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> searchByEmail(String email) async {
    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        error: 'Please enter an email to search',
        results: [],
      );
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final list = await _repository.searchByEmail(trimmedEmail);
      state = state.copyWith(isLoading: false, results: list);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }
}

final staffControllerProvider =
StateNotifierProvider<StaffController, StaffState>((ref) {
  final repo = ref.read(staffRepositoryProvider);
  return StaffController(repo);
});
