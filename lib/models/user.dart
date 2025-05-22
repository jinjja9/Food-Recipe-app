class User {
  final String id;
  final String avatarImage;
  final String email;
  final String password;
  final String role;
  final String? displayName;
  final String name;
  final DateTime? createdAt;

  User({
    required this.id,
    required this.avatarImage,
    required this.email,
    required this.password,
    required this.role,
    this.displayName,
    required this.name,
    this.createdAt,
  });

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
    );
  }
}