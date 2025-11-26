class Meal {
  final String id;
  final String name;
  final String thumbnailLink;

  Meal({required this.id, required this.name, required this.thumbnailLink});

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['idMeal'],
      name: json['strMeal'],
      thumbnailLink: json['strMealThumb'],
    );
  }
}
