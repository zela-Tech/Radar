class User {
  final int? id;
  final String name;
  final String username;
  final String email;
  final String password;
  final String? bio;
  final String createdAt;

  User({
    this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.password,
    this.bio,
    required this.createdAt,
  });

}