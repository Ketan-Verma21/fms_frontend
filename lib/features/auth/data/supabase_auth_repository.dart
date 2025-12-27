import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';
import '../../staff/models/staff.dart';

/// Supabase-based auth repository that mirrors the Python backend login functionality
/// NOTE: Passwords are stored in plain text right now; for production you should
/// hash them and use Supabase Auth. This is just to mirror the current backend behavior.
class SupabaseAuthRepository {
  SupabaseAuthRepository(this._supabase);

  final SupabaseClient _supabase;

  /// Simple login that checks the staff table for matching email + password
  /// (matches POST /staff/login)
  Future<Staff> login({
    required String email,
    required String password,
  }) async {
    final response = await _supabase
        .from('staff')
        .select('*')
        .eq('Email', email)
        .maybeSingle();

    if (response == null) {
      throw Exception('Invalid email or password');
    }

    // Compare password (plain text comparison to match backend behavior)
    final storedPassword = response['Password'] as String?;
    if (storedPassword != password) {
      throw Exception('Invalid email or password');
    }

    // Remove password from response before returning
    final staffData = Map<String, dynamic>.from(response);
    staffData.remove('Password');
    staffData.remove('password');

    return Staff.fromJson(staffData);
  }
}

final supabaseAuthRepositoryProvider =
    Provider<SupabaseAuthRepository>((ref) {
  return SupabaseAuthRepository(ref.watch(supabaseClientProvider));
});

