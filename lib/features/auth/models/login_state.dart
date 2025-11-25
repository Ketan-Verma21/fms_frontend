import '../../staff/models/staff.dart';

class LoginState {
  const LoginState({
    required this.isLoading,
    required this.errorMessage,
    required this.staff,
  });

  factory LoginState.initial() => const LoginState(
        isLoading: false,
        errorMessage: null,
        staff: null,
      );

  final bool isLoading;
  final String? errorMessage;
  final Staff? staff;

  bool get isAuthenticated => staff != null;

  LoginState copyWith({
    bool? isLoading,
    String? errorMessage,
    Staff? staff,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      staff: staff ?? this.staff,
    );
  }
}

