import 'package:cook_books_course/database_user.dart';
import 'package:cook_books_course/page_create_recipes.dart';
import 'package:cook_books_course/class_credentials.dart';
import 'package:cook_books_course/page_my_recipes.dart';
import 'package:cook_books_course/page_principal.dart';
import 'package:cook_books_course/page_register_user.dart';
import 'package:cook_books_course/page_settings.dart';
import 'package:cook_books_course/page_specif_recipe.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'page_login.dart';

 main() {
  runApp(
    ChangeNotifierProvider<UserCredentials>(
      create: (context) => UserCredentials(user: '', password: '', gender: ''),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: LoginPageApp(),
        initialRoute: "",
        routes: {
          "": (BuildContext context) => LoginPageApp(),
          "register": (BuildContext context) => RegisterPageApp(),
          "pagePrincipal": (BuildContext context) => PrincipalPage(),
          "createRecipe": (BuildContext context) => CreateRecipesPage(),
          "myRecipes": (BuildContext context) => MyRecipesPage(),
          "settings" : (BuildContext context) => SettingPage(),
          "specificRecipe": (BuildContext context) {
            return SpecificRecipe(recipeId: ModalRoute.of(context)!.settings.arguments as int);
          },

        },
      ),
    ),
  );
}
