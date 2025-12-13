import 'package:flutter/material.dart';
import 'package:lab1/lab2/services/favoritesService.dart';
import '../models/recipe.dart';
import '../services/apiService.dart';



class RecipeDetailScreen extends StatefulWidget {
  final String? mealId;
  final bool isRandom;

  const RecipeDetailScreen({super.key, this.mealId, this.isRandom = false});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  Recipe? recipe;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRecipe();
  }

  Future<void> fetchRecipe() async {
    setState(() => isLoading = true);
    try {
      Recipe fetchedRecipe;
      if (widget.isRandom) {
        fetchedRecipe = await RecipeService.fetchRandomRecipe();
      } else if (widget.mealId != null) {
        fetchedRecipe = await RecipeService.fetchRecipeById(widget.mealId!);
      } else {
        throw Exception('No mealId or random flag provided');
      }

      setState(() {
        recipe = fetchedRecipe;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print('Failed to load recipe: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe?.name ?? 'Детали за рецептот')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : recipe == null
          ? const Center(child: Text('Не пронајдовме рецепт!'))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(recipe!.thumbnail, height: 250, fit: BoxFit.cover),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: Text(recipe!.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
                IconButton(
                    icon: Icon(
                        FavoritesService.isFavorite(recipe!.id)
                            ? Icons.favorite
                            : Icons.favorite_border,
                      color: Colors.red,
                    ),
                    onPressed: (){
                      FavoritesService.toggleFavorite(recipe!);
                      setState(() {

                      });
                    },
                )
              ],
            ),
            const SizedBox(height: 12),
            const Text('Ingredients:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            ...recipe!.ingredients.map((i) => Text(i)).toList(),
            const SizedBox(height: 12),
            const Text('Instructions:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(recipe!.instructions ?? "Нема достапни инструкции"),
            const SizedBox(height: 12),
            if (recipe!.youtubeLink != "")
              ElevatedButton(
                onPressed: () {
                  // TODO Use url_launcher to open recipe.youtubeLink
                },
                child: const Text('Watch on YouTube'),
              ),
          ],
        ),
      ),
    );
  }
}
