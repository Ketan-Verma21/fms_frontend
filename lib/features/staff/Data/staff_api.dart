import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_client.dart';
import '../models/staff.dart';

class StaffApi {
  StaffApi(this._client);

  final ApiClient _client;

  Future<List<Staff>> searchStaff({String? name, String? email}) async {
    final response = await _client.get(
      '/staff/search',
      queryParameters: {
        if (name != null) 'name': name,
        if (email != null) 'email': email,
      },
    );

    final List data = response.data as List;
    return data.map((e) => Staff.fromJson(e)).toList();
  }
}

final staffApiProvider = Provider<StaffApi>((ref) {
  final client = ref.read(apiClientProvider);
  return StaffApi(client);
});
