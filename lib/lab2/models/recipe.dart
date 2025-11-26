class Recipe {
  final String id;
  final String name;
  final String? instructions;
  final String thumbnail;
  final String? youtubeLink;
  final List<String> ingredients;

  Recipe({
    required this.id,
    required this.name,
    this.instructions,
    required this.thumbnail,
    this.youtubeLink,
    required this.ingredients,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {

    List<String> ingredients = [];
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];
      if (ingredient != null &&
          ingredient.toString().isNotEmpty &&
          ingredient.toString() != 'null') {
        ingredients.add('$ingredient - ${measure ?? ''}');
      }
    }

    return Recipe(
      id: json['idMeal'],
      name: json['strMeal'],
      instructions: json['strInstructions'],
      thumbnail: json['strMealThumb'],
      youtubeLink: json['strYoutube'],
      ingredients: ingredients,
    );
  }
}
