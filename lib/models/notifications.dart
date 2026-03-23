class AppNotification {
  final int? id;
  final int userId;
  final String title;
  final String message;
  final int isRead; 
  final String createdAt;

  AppNotification({
    this.id,
    required this.userId,
    required this.title,
    required this.message,
    this.isRead = 0,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'user_id': userId,
    'title': title,
    'message': message,
    'is_read': isRead,
    'created_at': createdAt,
  };

  factory AppNotification.fromMap(Map<String, dynamic> map) => AppNotification(
    id: map['id'],
    userId: map['user_id'] ?? 0,
    title: map['title'] ?? '',
    message: map['message'] ?? '',
    isRead: map['is_read'] ?? 0,
    createdAt: map['created_at'] ?? '',
  );
}