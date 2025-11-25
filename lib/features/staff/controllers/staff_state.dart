import '../models/staff.dart';

class StaffState {
  const StaffState({
    required this.isLoading,
    required this.error,
    required this.results,
  });

  factory StaffState.initial() =>
      const StaffState(isLoading: false, error: null, results: []);

  final bool isLoading;
  final String? error;
  final List<Staff> results;

  StaffState copyWith({
    bool? isLoading,
    String? error,
    List<Staff>? results,
  }) {
    return StaffState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      results: results ?? this.results,
    );
  }
}
