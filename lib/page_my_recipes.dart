import 'package:cook_books_course/class_credentials.dart';
import 'package:cook_books_course/class_recipes.dart';
import 'package:cook_books_course/database_recipes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyRecipesPage extends StatefulWidget {
  @override
  State<MyRecipesPage> createState() => _MyRecipesPageState();
}

class _MyRecipesPageState extends State<MyRecipesPage> {
  @override
  Widget build(BuildContext context) {
    UserCredentials credentials = context.watch<UserCredentials>();
    String username = credentials.user;
    DBHelperRecipes dbHelper = DBHelperRecipes();
    //METODO DE LA BASE DE DATOS PARA RECIBIR LAS RECETAS SOBRE UN USUARIO CONCRETO
    Future<List<Recipes>> listRecipesUsername = dbHelper.getRecipesForUsername(username);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(icon: Icon(Icons.pages), onPressed: (){Navigator.of(context).pushNamed("pagePrincipal");},)
        ],
      ),
      body: FutureBuilder<List<Recipes>>(
        future: listRecipesUsername,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // BARRA DE CARGA MIENTRAS ESPERA
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            //INTERFAZ CUANDO YA SE HA COMPLETADO EL FUTURE
            return Column(
              children: <Widget>[
                Text('MY RECIPES',
                  style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.blueAccent
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
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
                                  Image.asset(
                                      snapshot.data![index].image
                                  ),
                                  SizedBox(height: 1),
                                  Text(
                                    ""+snapshot.data![index].name+ " | " + snapshot.data![index].time.toString() + "min",
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
    );
  }
}
