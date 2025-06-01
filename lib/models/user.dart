class User {
  final String id;
  final String avatarImage;
  final String email;
  final String password;
  final String role;
  final String? displayName;
  final String name;
  final DateTime? createdAt;
  final List<String> followers;

  User({
    required this.id,
    required this.avatarImage,
    required this.email,
    required this.password,
    required this.role,
    this.displayName,
    required this.name,
    this.createdAt,
    this.followers = const [],
  });

  bool get isAdmin => role == 'admin';
  bool get isUser => role == 'user';

  factory User.fromFirestore(String id, Map<String, dynamic> data) {
    return User(
      id: id,
      avatarImage: data['avatarImage'] ?? '',
      email: data['email'] ?? '',
      password: data['password'] ?? '',
      role: data['role'] ?? '',
      displayName: data['displayName'],
      name: data['name'] ?? '',
      createdAt: data['createdAt'] != null
          ? DateTime.tryParse(data['createdAt'].toString())
          : null,
      followers: List<String>.from(data['followers'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'avatarImage': avatarImage,
      'email': email,
      'password': password,
      'role': role,
      'displayName': displayName,
      'name': name,
      'createdAt': createdAt?.toIso8601String(),
      'followers': followers,
    };
  }
}