import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/staff/models/staff.dart';

class AuthStorage {
  AuthStorage(this._prefs);

  static const _staffKey = 'logged_in_staff';
  final SharedPreferences _prefs;

  Future<void> saveStaff(Staff staff) async {
    final jsonString = jsonEncode({
      'staff_id': staff.id,
      'name': staff.name,
      'org': staff.org,
      'role': staff.role,
      'email': staff.email,
    });
    await _prefs.setString(_staffKey, jsonString);
  }

  Staff? getStaff() {
    final jsonString = _prefs.getString(_staffKey);
    if (jsonString == null) return null;

    final map = jsonDecode(jsonString) as Map<String, dynamic>;
    return Staff.fromJson(map);
  }

  Future<void> clear() => _prefs.remove(_staffKey);
}

final authStorageProvider = Provider<AuthStorage>((ref) {
  throw UnimplementedError(
    'authStorageProvider must be overridden before runApp',
  );
});

