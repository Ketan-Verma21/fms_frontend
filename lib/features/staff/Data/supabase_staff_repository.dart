import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';
import '../models/staff.dart';

/// Supabase-based staff repository that mirrors the Python backend search functionality
class SupabaseStaffRepository {
  SupabaseStaffRepository(this._supabase);

  final SupabaseClient _supabase;

  /// Find staff members filtered by name or email (matches GET /staff/search)
  /// Requires at least one of name or email to search
  Future<List<Staff>> searchStaff({
    String? name,
    String? email,
  }) async {
    if (name == null && email == null) {
      throw Exception('Provide at least one of name or email to search');
    }

    var query = _supabase
        .from('staff')
        .select('staff_id, name, org, role, Email');

    // Apply filters
    if (name != null) {
      // Use ilike for case-insensitive partial match
      query = query.ilike('name', '%$name%');
    }

    if (email != null) {
      query = query.eq('Email', email);
    }

    final response = await query;

    return (response as List)
        .map((e) => Staff.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

final supabaseStaffRepositoryProvider =
    Provider<SupabaseStaffRepository>((ref) {
  return SupabaseStaffRepository(ref.watch(supabaseClientProvider));
});

