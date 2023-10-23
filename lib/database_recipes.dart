import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'class_recipes.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;

  DBHelper._internal();

  Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'recipes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE recipes (
            username TEXT,
            id INTEGER PRIMARY KEY,
            name TEXT,
            time INTEGER,
            ingredients TEXT,
            steps TEXT,
            image TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertRecipe(Recipes recipe) async {
    final database = await this.database;
    await database?.insert('recipes', recipe.toMap());
  }

  Future<void> printRecipesFromDatabase() async {
    final dbHelper = DBHelper(); // Reemplaza con tu propia instancia de DBHelper

    final database = await dbHelper.database;
    final List<Map<String, dynamic>> recipes = await database!.query('recipes');

    for (final recipe in recipes) {
      print('Recipe ID: ${recipe['id']}');
      print('Create for: ${recipe['username']}');
      print('Name: ${recipe['name']}');
      print('Time: ${recipe['time']}');
      print('Ingredients: ${recipe['ingredients']}');
      print('Steps: ${recipe['steps']}');
      print('Image: ${recipe['image']}');
      print('-------------------');
    }
  }

  Future<List<Recipes>> getRecipesForUsername(String username) async {
    final database = await this.database;
    final List<Map<String, dynamic>> recipeMaps = await database!.query(
      'recipes',
      where: 'username = ?',
      whereArgs: [username],
    );
    return recipeMaps.map((recipeMap) {
      return Recipes.fromJson(recipeMap);
    }).toList();
  }

  Future<List<Recipes>> getRecipeID(int id) async {
    final database = await this.database;
    final List<Map<String, dynamic>> recipeMaps = await database!.query(
      'recipes',
      where: 'id = ?',
      whereArgs: [id],
    );
    return recipeMaps.map((recipeMap) {
      return Recipes.fromJson(recipeMap);
    }).toList();
  }

  Future<List<Recipes>> getAllRecipes() async {
    final database = await this.database;
    final List<Map<String, dynamic>> recipeMaps = await database!.query('recipes');

    return recipeMaps.map((recipeMap) {
      return Recipes.fromJson(recipeMap);
    }).toList();
  }


}
