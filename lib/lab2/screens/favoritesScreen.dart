import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/favoritesService.dart';
import '../screens/recipeScreen.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favorites = FavoritesService.favorites;

    return Scaffold(
      appBar: AppBar(title: const Text('Омилени рецепти')),
      body: favorites.isEmpty
          ? const Center(child: Text('Нема омилени рецепти'))
          : ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final recipe = favorites[index];
          return ListTile(
            leading: Image.network(recipe.thumbnail),
            title: Text(recipe.name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      RecipeDetailScreen(mealId: recipe.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
