import 'dart:math';

import 'package:camera/camera.dart';
import 'package:cook_books_course/class_credentials.dart';
import 'package:cook_books_course/class_recipes.dart';
import 'package:cook_books_course/database_recipes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateRecipesPage extends StatefulWidget {
  @override
  State<CreateRecipesPage> createState() => _CreateRecipesPageState();
}

class _CreateRecipesPageState extends State<CreateRecipesPage> {
  final List<String> listOfIngredients = [];
  final List<String> listRecipeSteps = [];
  XFile? photo;
  String imgPath = "";
  DBHelper dbHelper = DBHelper();
  late String user;
  final nameRecipeController = TextEditingController();
  final timeToCreateController = TextEditingController();
  final ingredientsController = TextEditingController();
  final stepsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserCredentials credentials = context.watch<UserCredentials>();
    user = credentials.user;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: (){
                    _initializeCamera();
                    _photoRecipe(context);
                  },
                  icon: Icon(Icons.camera_alt_outlined, size: 100,)
              ),
              Text(
                "CREATE YOUR RECIPE",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24, // Tamaño del texto
                  color: Colors.black, // Color del texto
                ),
              ),
              TextField(
                controller: nameRecipeController,
                decoration: InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: timeToCreateController,
                decoration: InputDecoration(labelText: "Time"),
                keyboardType: TextInputType.number,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: ingredientsController,
                      decoration: InputDecoration(labelText: "Ingredients"),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      String ingredient = ingredientsController.text.toString();
                      if (ingredient.isNotEmpty) {
                        _addIngredient(ingredient, listOfIngredients);
                        ingredientsController.clear();
                        setState(() {});
                      }
                    },
                  ),
                ],
              ),
              if (listOfIngredients.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: listOfIngredients.length,
                  itemBuilder: (content, index) {
                    return ListTile(
                        title: Text(listOfIngredients[index].toString()),
                        trailing: IconButton(
                          icon: Icon(Icons.remove_circle),
                          onPressed: () {
                            _removeIngredient(index, listOfIngredients);
                            setState(() {});
                          },
                        ));
                  },
                )
              else
                Container(
                  child: Text('0 items added'),
                ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: stepsController,
                      decoration: InputDecoration(labelText: "Recipe to steps"),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      String step = stepsController.text.toString();
                      if (step.isNotEmpty) {
                        _addStep(step, listRecipeSteps);
                        stepsController.clear();
                        setState(() {});
                      }
                    },
                  ),
                ],
              ),
              if (listRecipeSteps.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: listRecipeSteps.length,
                  itemBuilder: (content, index) {
                    return ListTile(
                        title: Text(listRecipeSteps[index].toString()),
                        trailing: IconButton(
                          icon: Icon(Icons.remove_circle),
                          onPressed: () {
                            _removeStep(index, listRecipeSteps);
                            setState(() {});
                          },
                        ));
                  },
                )
              else
                Container(
                  child: Text('0 steps added'),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: IconButton(
        icon: Icon(Icons.next_plan_rounded, size: 50,),
        onPressed: (){
          if (photo == null){
            imgPath = "assets/defecto_receta.jpeg";
            setState(() {});
          }
          _validationRecipe(context,user,nameRecipeController,timeToCreateController, listOfIngredients, listRecipeSteps);
        },
      ),
    );
  }

  _addIngredient(String ingredient, List<String> listOfIngredients) {
      listOfIngredients.add(ingredient);
  }

  void _removeIngredient(int index, List<String> listOfIngredients) {
    listOfIngredients.removeAt(index);
  }

   _addStep(String step, List<String> listRecipeSteps) {
    listRecipeSteps.add(step);
  }

  void _removeStep(int index, List<String> listRecipeSteps) {
    listRecipeSteps.removeAt(index);
  }

  void _photoRecipe(BuildContext context) async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    final controller = CameraController(firstCamera, ResolutionPreset.medium);

    await controller.initialize();

    final XFile? image = await controller.takePicture();

    if (image != null) {
      setState(() {
        photo = image; // Asigna la foto a la variable
      });

      // Aquí puedes hacer algo con la foto, como mostrarla en tu interfaz de usuario o guardar la ruta de la imagen.
    }
    await controller.dispose();
  }

  Future<void> _validationRecipe(BuildContext context, String user, TextEditingController nameRecipeController, TextEditingController timeToCreateController, List<String> listOfIngredients, List<String> listRecipeSteps) async {
    String name = nameRecipeController.text.toString();
    final int time = int.parse(timeToCreateController.text);
    Recipes newRecipe;
    if (name.isNotEmpty && time!=null && listOfIngredients.isNotEmpty && listRecipeSteps.isNotEmpty){
      int numRandom = Random().nextInt(100000);
      if (imgPath.isNotEmpty){
        newRecipe = Recipes(user,numRandom, name, time as int, listOfIngredients, listRecipeSteps, imgPath);
        dbHelper.insertRecipe(newRecipe);
      }else if (photo!=null){
        newRecipe = Recipes(user,numRandom, name, time as int, listOfIngredients, listRecipeSteps, photo!.path);
        dbHelper.insertRecipe(newRecipe);
      }
      showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: Text("Correct"),
              content: Text("Your recipe is complete"),
              actions: <Widget>[
                TextButton(
                    onPressed: (){
                      Navigator.of(context).pushNamed("pagePrincipal");
                    },
                    child: Text("OK"))
              ],
            );
          }
      );
    }
  }
  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      final firstCamera = cameras.first;
      final controller = CameraController(firstCamera, ResolutionPreset.medium);
      await controller.initialize();
    }
  }
}
