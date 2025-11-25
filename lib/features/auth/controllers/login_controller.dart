import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/auth_storage.dart';
import '../data/auth_repository.dart';
import '../models/login_state.dart';

class LoginController extends StateNotifier<LoginState> {
  LoginController(this._repository, this._storage)
      : super(LoginState.initial()) {
    _hydrate();
  }

  final AuthRepository _repository;
  final AuthStorage _storage;

  void _hydrate() {
    final storedStaff = _storage.getStaff();
    if (storedStaff != null) {
      state = state.copyWith(staff: storedStaff);
    }
  }

  Future<void> signIn(String email, String password) async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final staff = await _repository.login(email: email, password: password);
      await _storage.saveStaff(staff);
      state = state.copyWith(isLoading: false, staff: staff, errorMessage: null);
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unable to sign in. Please check your details.',
      );
    }
  }

  void signOut() {
    _storage.clear();
    state = LoginState.initial();
  }
}

final loginControllerProvider =
    StateNotifierProvider<LoginController, LoginState>((ref) {
  return LoginController(
    ref.watch(authRepositoryProvider),
    ref.watch(authStorageProvider),
  );
});
