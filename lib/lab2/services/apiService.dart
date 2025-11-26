import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/category.dart';
import '../models/meal.dart';
import '../models/recipe.dart';

class CategoryService {
  static const String baseUrl = "https://www.themealdb.com/api/json/v1/1/";


  static Future<List<Category>> fetchCategories() async {
    final url = Uri.parse("${baseUrl}categories.php");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List categoriesJson = data["categories"];

      return categoriesJson.map((data) => Category.fromJson(data)).toList();
    } else {
      throw Exception("Failed to load categories");
    }
  }
}

class MealService {
  static Future<List<Meal>> fetchMealsByCategory(String category) async {
    final response = await http.get(Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/filter.php?c=$category'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Meal>.from(data['meals'].map((json) => Meal.fromJson(json)));
    } else {
      throw Exception('Failed to load meals');
    }
  }
}

class RecipeService {
  static Future<Recipe> fetchRecipeById(String id) async {
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Recipe.fromJson(data['meals'][0]);
    } else {
      throw Exception('Failed to load recipe');
    }
  }

  static Future<Recipe> fetchRandomRecipe() async {
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/random.php'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Recipe.fromJson(data['meals'][0]);
    } else {
      throw Exception('Failed to fetch random recipe');
    }
  }
}
