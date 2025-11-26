class Category{
  final String id;
  final String name;
  final String thumbnailLink;
  final String description;

  Category({required this.id, required this.name, required this.thumbnailLink, required this.description});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['idCategory'] ?? '',
      name: json['strCategory'] ?? '',
      thumbnailLink: json['strCategoryThumb'] ?? '',
      description: json['strCategoryDescription'] ?? '',
    );
  }
}