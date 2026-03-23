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
  
  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'username': username, 
    'email': email,
    'password': password,
    'bio':bio,
    'created_at': createdAt,
  };
}