import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/staff.dart';
import 'staff_api.dart';

class StaffRepository {
  StaffRepository(this._api);

  final StaffApi _api;

  Future<List<Staff>> searchByName(String name) {
    return _api.searchStaff(name: name);
  }

  Future<List<Staff>> searchByEmail(String email) {
    return _api.searchStaff(email: email);
  }
}

final staffRepositoryProvider = Provider<StaffRepository>((ref) {
  final api = ref.read(staffApiProvider);
  return StaffRepository(api);
});
