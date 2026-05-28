class Profile {
  final String id;
  final String fullName;
  final String? studentId;
  final String? avatarUrl;
  final String role;
  final String? phone;
  final DateTime createdAt;

  Profile({
    required this.id,
    required this.fullName,
    this.studentId,
    this.avatarUrl,
    required this.role,
    this.phone,
    required this.createdAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      fullName: json['full_name'] as String? ?? 'Unknown',
      studentId: json['student_id'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      role: json['role'] as String? ?? 'student',
      phone: json['phone'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'student_id': studentId,
      'avatar_url': avatarUrl,
      'role': role,
      'phone': phone,
    };
  }
}
