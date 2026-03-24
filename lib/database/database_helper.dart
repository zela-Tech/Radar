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
    final db = await instance.database;
    return await db.insert('users', user.toMap());
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
  
  // Close database connection
  Future close() async {
    final db = await database;
    db.close();
  }
}