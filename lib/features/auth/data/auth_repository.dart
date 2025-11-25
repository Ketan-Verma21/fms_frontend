import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../staff/models/staff.dart';

class AuthRepository {
  AuthRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<Staff> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/staff/login',
      data: {
        'email': email,
        'password': password,
      },
    );
    final data = response.data ?? {};
    final staff = data['staff'] as Map<String, dynamic>? ?? {};
    return Staff.fromJson(staff);
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(apiClientProvider));
});

