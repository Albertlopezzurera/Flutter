import 'package:cook_books_course/class_credentials.dart';
import 'package:cook_books_course/class_recipes.dart';
import 'package:cook_books_course/database_recipes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PrincipalPage extends StatelessWidget {
  PrincipalPage({Key? key}) : super(key: key);
  late String user;
  late String gender;

  @override
  Widget build(BuildContext context) {
    UserCredentials credentials = context.read<UserCredentials>();
    user = credentials.user;
    gender = credentials.gender;
    _createDatabase();
    DBHelper dbHelper = DBHelper();
    //METODO DE LA BASE DE DATOS PARA RECIBIR TODAS LAS RECETAS
    Future<List<Recipes>> listAllRecipes = dbHelper.getAllRecipes();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        actions: [
          IconButton(icon: Icon(Icons.favorite_border), onPressed: (){}),
          IconButton(icon: Icon(Icons.settings), onPressed: () {
            Navigator.of(context).pushNamed("settings");
          }),
        ],
      ),
      body: FutureBuilder<List<Recipes>>(
        future: listAllRecipes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            return Column(
              children: <Widget>[
                Text(
                  'ALL COOKING RECIPES',
                  style: TextStyle(fontSize: 30.0, color: Colors.blueAccent),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed("specificRecipe", arguments: snapshot.data![index].id);
                            },
                            child: Container(
                              padding: EdgeInsets.all(1.0), // RELLENO
                              margin: EdgeInsets.all(20.0), // MARGENES
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black, // BORDE
                                  width: 2.0,
                                ),
                              ),
                              child: Column(
                                children: <Widget>[
                                  Image.asset(snapshot.data![index].image),
                                  SizedBox(height: 1),
                                  Text(
                                    "" +
                                        snapshot.data![index].name +
                                        " | " +
                                        snapshot.data![index].time.toString() +
                                        "min",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (snapshot.data!.length != index)
                            Divider(
                              color: Colors.grey,
                              thickness: 1.5,
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return Text('No se encontraron recetas.');
          }
        },
      ),
      drawer: getDrawer(context, user, gender),
    );
  }

  getDrawer(BuildContext context, user, gender) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blueAccent),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('assets/female.jpg'),
                Text(
                  user,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50, // Tamaño del texto
                    color: Colors.white, // Color del texto
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text("Settings account"),
            leading: Icon(
              Icons.account_circle_rounded,
              size: 50,
            ),
            onTap: () {},
          ),
          ListTile(
            title: Text("Create recipe"),
            leading: Icon(
              Icons.add_box_outlined,
              size: 50,
            ),
            onTap: () {
              Navigator.of(context).pushNamed("createRecipe");
            },
          ),
          ListTile(
            title: Text("My recipes"),
            leading: Icon(
              Icons.list,
              size: 50,
            ),
            onTap: () {
              Navigator.of(context).pushNamed("myRecipes");
            },
          ),
          ListTile(
            title: Text("Sign off"),
            leading: Icon(
              Icons.highlight_off,
              size: 50,
            ),
            onTap: () {
              _closeSession(context);
            },
          ),
        ],
      ),
    );
  }

  void _closeSession(BuildContext context) {
    Navigator.of(context).pushNamed("");
  }

  Future<void> _createDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    final dbHelper = DBHelper();
    await dbHelper.initDatabase();
  }
}

class Credentials {
  String user;
  String password;

  Credentials({required this.user, required this.password});
}
