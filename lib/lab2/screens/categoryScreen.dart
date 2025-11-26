import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/apiService.dart';
import '../widgets/categoryCard.dart';
import '../screens/recipeScreen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Category> categories = [];
  List<Category> filteredCategories = [];
  bool isLoading = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final data = await CategoryService.fetchCategories();
    setState(() {
      categories = data;
      filteredCategories = data;
      isLoading = false;
    });
  }

  void filterCategories(String query) {
    setState(() {
      searchQuery = query;
      filteredCategories = query.isEmpty
          ? categories
          : categories
          .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> showRandomRecipe() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final recipe = await RecipeService.fetchRandomRecipe();
      Navigator.pop(context); // Remove loading dialog
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RecipeDetailScreen(mealId: recipe.id),
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch recipe: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Категории на јадења'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle),
            tooltip: 'Random Recipe',
            onPressed: showRandomRecipe,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: filterCategories,
              decoration: InputDecoration(
                hintText: 'Пребарај категории',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SizedBox(
        height: 500,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: filteredCategories.length,
          itemBuilder: (context, index) {
            final category = filteredCategories[index];
            return CategoryCard(category: category);
          },
        ),
      ),
    );
  }
}
