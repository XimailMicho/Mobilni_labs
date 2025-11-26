import 'package:flutter/material.dart';
import '../screens/mealScreen.dart';
import '../models/category.dart';

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // Define fixed width and height for the card to avoid overflow
    final double cardWidth = 250;
    final double cardHeight = 400;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MealsScreen(category: category),
            ),
          );
        },
        child: Card(
          elevation: 4,
          child: SizedBox(
            width: cardWidth,
            height: cardHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image takes the top portion of the card
                SizedBox(
                  height: cardHeight * 0.5, // 50% of card height
                  width: cardWidth,
                  child: Image.network(
                    category.thumbnailLink,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),

                // Category name
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    category.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 4),

                // Description - truncated safely
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Expanded(
                    child: Text(
                      category.description,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 8,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
