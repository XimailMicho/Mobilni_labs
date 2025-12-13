import '../models/recipe.dart';

class FavoritesService {
  static final List<Recipe> _favorites = [];

  static List<Recipe> get favorites => _favorites;

  static bool isFavorite(String recipeId) {
    return _favorites.any((r) => r.id == recipeId);
  }

  static void toggleFavorite(Recipe recipe) {
    if (isFavorite(recipe.id)) {
      _favorites.removeWhere((r) => r.id == recipe.id);
    } else {
      _favorites.add(recipe);
    }
  }
}
