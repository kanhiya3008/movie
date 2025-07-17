class User {
  final String id;
  final String email;
  final String name;
  final String? avatar;
  final String? phone;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isEmailVerified;
  final List<String> preferences;
  final Map<String, dynamic> settings;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
    this.phone,
    required this.createdAt,
    required this.updatedAt,
    required this.isEmailVerified,
    required this.preferences,
    required this.settings,
  });

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? avatar,
    String? phone,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isEmailVerified,
    List<String>? preferences,
    Map<String, dynamic>? settings,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      preferences: preferences ?? this.preferences,
      settings: settings ?? this.settings,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar': avatar,
      'phone': phone,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isEmailVerified': isEmailVerified,
      'preferences': preferences,
      'settings': settings,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String?,
      phone: json['phone'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isEmailVerified: json['isEmailVerified'] as bool,
      preferences: List<String>.from(json['preferences'] as List),
      settings: Map<String, dynamic>.from(json['settings'] as Map),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $name)';
  }
}
