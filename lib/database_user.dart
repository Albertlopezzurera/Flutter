import 'package:cook_books_course/class_users.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'class_recipes.dart';

class DBHelperUser {
  static final DBHelperUser _instance = DBHelperUser._internal();

  factory DBHelperUser() => _instance;

  DBHelperUser._internal();

  Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'users.db');
    try {
      final db = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) {
          db.execute('''
          CREATE TABLE users (
            username TEXT PRIMARY KEY,
            password TEXT,
            email TEXT,
            age TEXT,
            gender TEXT
          )
        ''');
        },
      );
      return db;
    } catch (e) {
      print('Error initializing database: $e');
      throw e;
    }
  }
  Future<bool> isTableExists(String tableName) async {
    final database = await this.database;
    final result = Sqflite.firstIntValue(await database!.rawQuery(
      "SELECT COUNT(*) FROM sqlite_master WHERE type = 'table' AND name = ?",
      [tableName],
    ));
    return result! > 0;
  }

  Future<void> createTable() async {
    final database = await this.database;
    await database?.execute('''
    CREATE TABLE users (
      username TEXT PRIMARY KEY,
      password TEXT,
      email TEXT,
      age TEXT,
      gender TEXT
    )
  ''');
  }

  Future<void> insertUser(User user) async {
    final database = await this.database;
    await database?.insert('users', user.toMap());
  }

  Future<void> printUsersFromDatabase() async {
    final dbHelper =
        DBHelperUser();
    final database = await dbHelper.database;
    final List<Map<String, dynamic>> users = await database!.query('users');
    for (final user in users) {
      print('Username: ${user['username']}');
      print('Password: ${user['password']}');
      print('Email: ${user['email']}');
      print('Age: ${user['age']}');
      print('Gender: ${user['gender']}');
      print('-------------------');
    }
  }

  Future<List<User>> getUsername(String username) async {
    final database = await this.database;
    final List<Map<String, dynamic>> userMaps = await database!.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return userMaps.map((userMap) {
      return User.fromJson(userMap);
    }).toList();
  }

  Future<List<User>> getAllUsers() async {
    final database = await this.database;
    final List<Map<String, dynamic>> usersMap = await database!.query('users');
    return usersMap.map((userMap) {
      return User.fromJson(userMap);
    }).toList();
  }

  Future<int> getUsernameExists(String username) async {
    final database = await this.database;
    final List<Map<String, dynamic>> usersMap = await database!.query('users');
    for (final user in usersMap) {
      if (user['username'] == username) {
        return 1; // Usuario encontrado
      }
    }
    return 0;
  }
}
