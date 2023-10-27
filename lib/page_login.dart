import 'package:cook_books_course/class_credentials.dart';
import 'package:cook_books_course/class_users.dart';
import 'package:cook_books_course/database_recipes.dart';
import 'package:cook_books_course/database_user.dart';
import 'package:cook_books_course/page_principal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPageApp extends StatefulWidget {
  @override
  State<LoginPageApp> createState() => _LoginPageAppState();
}

class _LoginPageAppState extends State<LoginPageApp> {
  String user = "";
  String password = "";
  String gender = "";
  DBHelperRecipes dbHelperRecipes = DBHelperRecipes();
  DBHelperUser dbHelperUser = DBHelperUser();
  final userController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    await dbHelperUser.initDatabase();
    final isTableExists = await dbHelperUser.isTableExists('users');
    if (!isTableExists) {
      await dbHelperUser.createTable();
    }
  }

  @override
  Widget build(BuildContext context) {
    dbHelperUser.initDatabase();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
                "https://www.helpguide.org/wp-content/uploads/2023/02/Cooking-at-Home.jpeg",
                scale: 4),
            Text(
              "COOKING DO IT",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24, // Tamaño del texto
                color: Colors.blue, // Color del texto
              ),
            ),
            TextField(
              controller: userController,
              decoration: InputDecoration(labelText: "User"),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Password"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("You have not yet registered?"),
                TextButton(
                  onPressed: () {
                    _Register(context);
                  },
                  child: Text("Register"),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.next_plan,
          size: 60,
        ),
        onPressed: () {
          _validationCredentials(context);
        },
      ),
    );
  }

  void _Register(BuildContext context) {
    Navigator.of(context).pushNamed("register");
  }

  void _validationCredentials(BuildContext context) async {
    user = userController.text;
    password = passwordController.text;
    int result = 0;
    if (user.isNotEmpty && password.isNotEmpty) {
      List<User> listAllUsers = await dbHelperUser.getAllUsers();

      for (User userDB in listAllUsers) {
         if (userDB.username == user && userDB.password == password) {
          result = 1;
        }
      }
      if (result == 1) {
        UserCredentials credentials = context.read<UserCredentials>();
        credentials.user = user;
        credentials.password = password;
        credentials.gender = gender;

        Navigator.of(context).pushNamed("pagePrincipal");
      } else {
        _showDialog(context);
      }
    }
  }

  void _showDialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("ERROR"),
            content: Text("Please, correct user or password"),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"))
            ],
          );
        });
  }
}
