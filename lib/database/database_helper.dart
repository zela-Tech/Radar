// Import required packages
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';


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
  }
  
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
  
  // READ - Get single item by ID
  Future<Map<String, dynamic>?> getItem(int id) async {
    final db = await database;
    final results = await db.query(
      'items',
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }
  
  // UPDATE - Update existing item
  Future<int> updateItem(int id, Map<String, dynamic> item) async {
    final db = await database;
    return await db.update(
      'items',
      item,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  // DELETE - Remove item
  Future<int> deleteItem(int id) async {
    final db = await database;
    return await db.delete(
      'items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  // Close database connection
  Future close() async {
    final db = await database;
    db.close();
  }
}