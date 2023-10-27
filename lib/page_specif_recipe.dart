import 'package:cook_books_course/class_recipes.dart';
import 'package:cook_books_course/database_recipes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SpecificRecipe extends StatefulWidget {
  int recipeId;
  SpecificRecipe({required this.recipeId});
  @override
  _SpecificRecipeState createState() => _SpecificRecipeState();
}

class _SpecificRecipeState extends State<SpecificRecipe> {
  DBHelperRecipes dbHelper = DBHelperRecipes();
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    Future<List<Recipes>> recipeID = dbHelper.getRecipeID(widget.recipeId);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(onPressed: (){
            addFavoriteRecipe();
            },
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null, // Cambia el color si es favorito
            ),
          )
        ],
      ),
      body: FutureBuilder<List<Recipes>>(
        future: recipeID,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            return Column(
              children: <Widget>[
                Text(
                  snapshot.data![0].name,
                  style: TextStyle(fontSize: 30.0, color: Colors.blueAccent),
                ),
                SizedBox(height: 10,),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Image.asset(snapshot.data![index].image),
                              SizedBox(height: 10),
                              Text('Made by: '+snapshot.data![index].username),
                            ],
                          ),
                          SizedBox(height: 50),
                          Divider(
                            color: Colors.grey,
                            thickness: 2.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text('Ingredients'),
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.grey,
                            thickness: 0.75,
                          ),
                          for (int i = 0; i < snapshot.data![index].ingredients.length; i++)
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                              children: [
                                  Text('$i. ${snapshot.data![index].ingredients[i]}'),
                              ],
                          ),
                            ),
                          Divider(
                            color: Colors.grey,
                            thickness: 2.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text('Steps'),
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.grey,
                            thickness: 0.75,
                          ),
                          for (int i = 0; i < snapshot.data![index].steps.length; i++)
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                  Text('$i. ${snapshot.data![index].steps[i]}'),
                              ],
                            ),
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

  void addFavoriteRecipe() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }
}
