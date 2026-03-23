class Mission {
  final int? id;
  final String title;
  final String description;
  final int progress;
  final int isCompleted; 
  //^^ 0 for false and 1 for trure

  Mission({
    this.id,
    required this.title,
    required this.description,
    this.progress = 0,
    this.isCompleted = 0,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'progress': progress,
    'is_completed': isCompleted,
  };

  factory Mission.fromMap(Map<String, dynamic> map) => Mission(
    id: map['id'],
    title: map['title'] ?? '',
    description: map['description'] ?? '',
    progress: map['progress'] ?? 0,
    isCompleted: map['is_completed'] ?? 0,
  );
}