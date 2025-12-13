import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/apiService.dart';
import '../widgets/categoryCard.dart';
import '../screens/recipeScreen.dart';
import '../screens/favoritesScreen.dart';

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
      Navigator.pop(context);
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
            icon: const Icon(Icons.favorite),
            tooltip: 'Favorites',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) =>  FavoritesScreen()),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: showRandomRecipe,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orangeAccent.withOpacity(0.2),
                ),
                child: const Icon(
                  Icons.shuffle,
                  size: 30,
                  color: Colors.orange,
                ),
              ),
            ),
          ),
        ],

      ),


      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              onChanged: filterCategories,
              decoration: InputDecoration(
                hintText: 'Пребарај категории',
                prefixIcon: const Icon(Icons.search),
                contentPadding:
                const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // SPACING BETWEEN SEARCH AND CATEGORIES
          const SizedBox(height: 10),

          // CATEGORY LIST
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filteredCategories.length,
              padding: const EdgeInsets.only(left: 12),
              itemBuilder: (context, index) {
                final category = filteredCategories[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: CategoryCard(category: category),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
