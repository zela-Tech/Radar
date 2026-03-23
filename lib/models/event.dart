class Event {
  final int? id;
  final String title;
  final String? description;
  final String location;
  final String category;
  final String date;
  final String time;
  final int? createdBy;

  Event({
    this.id,
    required this.title,
    this.description,
    required this.location,
    required this.category,
    required this.date,
    required this.time,
    this.createdBy,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'location': location,
    'category': category,
    'date': date,
    'time': time,
    'created_by': createdBy,
  };

  factory Event.fromMap(Map<String, dynamic> map) => Event(
    id: map['id'],
    title: map['title'] ?? '',
    description: map['description'],
    location: map['location'] ?? '',
    category: map['category'] ?? '',
    date: map['date'] ?? '',
    time: map['time'] ?? '',
    createdBy: map['created_by'],
  );
}