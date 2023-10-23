import 'package:flutter/material.dart';

class Recipes {
  final String username;
  final int id;
  final String name;
  final int time;
  final List<String> ingredients;
  final List<String> steps;
  final String image;

  Recipes(this.username, this.id,this.name, this.time, this.ingredients, this.steps, this.image);

  factory Recipes.fromJson(Map<String, dynamic> json) {
    return Recipes(
      json['username'] as String,
      json['id'] as int,
      json['name'] as String,
      json['time'] as int,
      (json['ingredients'] as String).split(';'), // Divide la cadena en una lista de ingredientes
      (json['steps'] as String).split(';'), // Divide la cadena en una lista de pasos
      json['image'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username':username,
      'id': id,
      'name': name,
      'time': time,
      'ingredients': ingredients.join(';'), // Convertimos la lista de ingredientes en una cadena
      'steps': steps.join(';'), // Convertimos la lista de pasos en una cadena
      'image': image,
    };
  }

}

class ListRecipes{
  final List<Recipes> listRecipes;

  ListRecipes(this.listRecipes);

  factory ListRecipes.fromJson(Map<String, dynamic> json) {
    return ListRecipes(
      json['listRecipes'] as List<Recipes>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'listRecipes': listRecipes,
    };
  }
}
