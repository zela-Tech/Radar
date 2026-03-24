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
  }
  //seed data--------------------
  Future _seedInterests(Database db) async {
    final interests = ['Tech', 'Music', 'Sports', 'Arts', 'Career', 'Wellness', 'Food', 'Social'];
    for (final name in interests) {
      await db.insert('interests', {'name': name});
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