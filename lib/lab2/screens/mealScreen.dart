import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/meal.dart';
import '../services/apiService.dart';
import '../widgets/mealCard.dart';

class MealsScreen extends StatefulWidget {
  final Category category;

  const MealsScreen({super.key, required this.category});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  List<Meal> meals = [];
  List<Meal> filteredMeals = [];
  bool isLoading = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchMeals();
  }

  Future<void> fetchMeals() async {
    setState(() => isLoading = true);
    try {
      final data = await MealService.fetchMealsByCategory(widget.category.name);
      setState(() {
        meals = data;
        filteredMeals = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print('Failed to load meals: $e');
    }
  }

  void filterMeals(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredMeals = meals; // show all if empty
      } else {
        filteredMeals = meals
            .where((meal) => meal.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meals in ${widget.category.name}'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              onChanged: filterMeals,
              decoration: InputDecoration(
                hintText: 'Пребарај јадење',
                fillColor: Colors.white,
                filled: true,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.8,
        ),
        itemCount: filteredMeals.length,
        itemBuilder: (context, index) {
          final meal = filteredMeals[index];
          return MealCard(meal: meal);
        },
      ),
    );
  }
}
