class Staff {
  const Staff({
    required this.id,
    required this.name,
    required this.org,
    required this.role,
    required this.email,
  });

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      id: json['staff_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      org: json['org'] as String? ?? '',
      role: json['role'] as String? ?? '',
      email: json['Email'] as String? ?? json['email'] as String? ?? '',
    );
  }

  final String id;
  final String name;
  final String org;
  final String role;
  final String email;
}

