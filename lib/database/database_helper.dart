// Import required packages
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/event.dart';
import '../models/missions.dart';
import '../models/notifications.dart';


// DatabaseHelper class - Singleton pattern
class DatabaseHelper {
  // Singleton instance
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  
  // Private constructor
  DatabaseHelper._init();
  
  // Get database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('myapp.db');
    return _database!;
  }
  
  // Initialize database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }
  
  // Create database tables
  Future _createDB(Database db, int version) async {
    //For Users
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        username TEXT UNIQUE NOT NULL,
        email TEXT NOT NULL,
        password TEXT NOT NULL,
        bio TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    // for intersts (tech, music, sports, Arts,career,wellness, food, social)
    await db.execute('''
      CREATE TABLE interests (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');

    //specfic users intrests
    await db.execute('''
      CREATE TABLE user_interests (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        interest_id INTEGER NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id),
        FOREIGN KEY (interest_id) REFERENCES interests(id)
      )
    ''');

    // Events
    await db.execute('''
      CREATE TABLE events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        location TEXT NOT NULL,
        category TEXT NOT NULL,
        date TEXT NOT NULL,
        time TEXT NOT NULL,
        created_by INTEGER,
        FOREIGN KEY (created_by) REFERENCES users(id)
      )
    ''');

    // RSVPs
    await db.execute('''
      CREATE TABLE rsvps (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        event_id INTEGER NOT NULL,
        status TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id),
        FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE
      )
    ''');

    // missions
    await db.execute('''
      CREATE TABLE missions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        progress INTEGER NOT NULL DEFAULT 0,
        is_completed INTEGER NOT NULL DEFAULT 0
      )
    ''');

    //user stats
    await db.execute('''
      CREATE TABLE user_stats (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        events_attended INTEGER NOT NULL DEFAULT 0,
        streak INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (user_id) REFERENCES users(id)
      )
    ''');

     // Notifications
    await db.execute('''
      CREATE TABLE notifications (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        message TEXT NOT NULL,
        is_read INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id)
      )
    ''');

  }
  //seed data--------------------
  Future _seedInterests(Database db) async {
    final interests = ['Tech', 'Music', 'Sports', 'Arts', 'Career', 'Wellness', 'Food', 'Social'];
    for (final name in interests) {
      await db.insert('interests', {'name': name});
    }
  }

  Future _seedMissions(Database db) async {
    final missions = [
      {'title': 'Tech Explorer', 'description': 'Attend 5 tech-related events this semester', 'progress': 0, 'is_completed': 0},
      {'title': 'Social Connector', 'description': 'RSVP to 3 social or networking events', 'progress': 0, 'is_completed': 0},
      {'title': 'Career Builder', 'description': 'Attend 4 career-focused events', 'progress': 0, 'is_completed': 0},
      {'title': 'First Event', 'description': 'RSVP to your very first event on Radar', 'progress': 0, 'is_completed': 0},
    ];
    for (final m in missions) {
      await db.insert('missions', m);
    }
  }



  //for user-----------------------
  // CREATE User/registration
  Future<int> createUser(User user) async {
    final db = await database;
    final id = await db.insert('users', user.toMap());
    await db.insert('user_stats', {'user_id': id, 'events_attended': 0, 'streak': 0}); //this creates an  empty stats  for new user
    return id;
  }

  
  // READ - get user by email(for login)
  Future<User?> getUserByEmail(String email) async {
    final db = await instance.database;

    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if(maps.isNotEmpty){
      return User.fromMap(maps.first);
    }else{
      return null;
    }
  }

  Future<User?> getUserById(int id) async {
    final db = await database;
    final maps = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update('users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }



  //intrests---------------------------
  // Get all interests for onboarding chip grid
  Future<List<Map<String, dynamic>>> getAllInterests() async {
    final db = await database;
    return await db.query('interests');
  }
  //save which interests a user selected on onboarding
  Future<void> saveUserInterests(int userId, List<int> interestIds) async {
    final db = await database;
    // Clear existing first (in case of re-edit)
    await db.delete('user_interests', where: 'user_id = ?', whereArgs: [userId]);
    for (final id in interestIds) {
      await db.insert('user_interests', {'user_id': userId, 'interest_id': id});
    }
  }

  // get interest names for a given user. can be used for profile and ai spark
  Future<List<String>> getUserInterestNames(int userId) async {
    final db = await database;
    final res = await db.rawQuery('''
      SELECT i.name FROM interests i
      JOIN user_interests ui ON i.id = ui.interest_id
      WHERE ui.user_id = ?
    ''', [userId]);
    return res.map((r) => r['name'] as String).toList();
  }

  //events------------------
  Future<int> createEvent(Event event) async {
    final db = await database;
    return await db.insert('events', event.toMap());
  }

  Future<List<Event>> getAllEvents() async {
    final db = await database;
    final res = await db.query('events', orderBy: 'date ASC');
    return res.map((r) => Event.fromMap(r)).toList();
  }

  Future<List<Event>> getEventsByCategory(String category) async {
    final db = await database;
    final res = await db.query('events', where: 'category = ?', whereArgs: [category], orderBy: 'date ASC');
    return res.map((r) => Event.fromMap(r)).toList();
  }

  Future<Event?> getEventById(int id) async {
    final db = await database;
    final res = await db.query('events', where: 'id = ?', whereArgs: [id]);
    if (res.isEmpty) return null;
    return Event.fromMap(res.first);
  }

  Future<int> updateEvent(Event event) async {
    final db = await database;
    return await db.update('events', event.toMap(), where: 'id = ?', whereArgs: [event.id]);
  }

  Future<int> deleteEvent(int id) async {
    final db = await database;
    return await db.delete('events', where: 'id = ?', whereArgs: [id]);
  }
  //ai spark----------------------events matching user's interest categories not yet RSVP'd
  Future<List<Event>> getSuggestedEvents(int userId) async {
    final db = await database;
    final interests = await getUserInterestNames(userId);
    if (interests.isEmpty) return getAllEvents();
    final placeholders = interests.map((_) => '?').join(', ');
    final res = await db.rawQuery('''
      SELECT e.* FROM events e
      WHERE e.category IN ($placeholders)
      AND e.id NOT IN (
        SELECT event_id FROM rsvps WHERE user_id = ?
      )
      ORDER BY e.date ASC
      LIMIT 10
    ''', [...interests, userId]);
    return res.map((r) => Event.fromMap(r)).toList();
  }
  //rsvp-----------------------
   Future<int> createRsvp(int userId, int eventId, String status) async {
    final db = await database;
    // this removes any  existing RSVPs if there are any
    await db.delete('rsvps', where: 'user_id = ? AND event_id = ?', whereArgs: [userId, eventId]);
    return await db.insert('rsvps', {'user_id': userId, 'event_id': eventId, 'status': status});
  }

  Future<String?> getRsvpStatus(int userId, int eventId) async {
    final db = await database;
    final res = await db.query('rsvps', where: 'user_id = ? AND event_id = ?', whereArgs: [userId, eventId]);
    if (res.isEmpty) return null;
    return res.first['status'] as String;
  }

  Future<List<Event>> getRsvpdEvents(int userId) async {
    final db = await database;
    final res = await db.rawQuery('''
      SELECT e.* FROM events e
      JOIN rsvps r ON e.id = r.event_id
      WHERE r.user_id = ? AND r.status = 'going'
      ORDER BY e.date ASC
    ''', [userId]);
    return res.map((r) => Event.fromMap(r)).toList();
  }

  Future<int> getRsvpCount(int eventId) async {
    final db = await database;
    final res = await db.rawQuery(
      "SELECT COUNT(*) as count FROM rsvps WHERE event_id = ? AND status = 'going'",
      [eventId],
    );
    return Sqflite.firstIntValue(res) ?? 0;
  }
  //missions-------------------
  //users progres/stats----------------
  //notifications--------------------
  Future<int> createNotification(AppNotification n) async {
    final db = await database;
    return await db.insert('notifications', n.toMap());
  }

  Future<List<AppNotification>> getNotificationsForUser(int userId) async {
    final db = await database;
    final res = await db.query(
      'notifications',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
    return res.map((r) => AppNotification.fromMap(r)).toList();
  }

  Future<void> markNotificationRead(int id) async {
    final db = await database;
    await db.update('notifications', {'is_read': 1}, where: 'id = ?', whereArgs: [id]);
  }

  // Close database connection
  Future close() async {
    final db = await database;
    db.close();
  }
}