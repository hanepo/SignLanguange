class User {
  final String? id;
  final String email;
  final String password;
  final String fullName;
  final String role; // 'admin' or 'user'
  final DateTime createdAt;
  final DateTime? updatedAt;

  User({
    this.id,
    required this.email,
    required this.password,
    required this.fullName,
    required this.role,
    DateTime? createdAt,
    this.updatedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    final map = {
      'email': email,
      'password': password,
      'fullName': fullName,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
    };

    if (updatedAt != null) {
      map['updatedAt'] = updatedAt!.toIso8601String();
    }

    return map;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String?,
      email: map['email'] as String,
      password: map['password'] as String,
      fullName: map['fullName'] as String,
      role: map['role'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
    );
  }

  User copyWith({
    String? id,
    String? email,
    String? password,
    String? fullName,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool isAdmin() => role == 'admin';
}
