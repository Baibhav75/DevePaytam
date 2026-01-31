class Product {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  final String description;
  final double rating;
  final String category;
  final String type; // 🔥 "best", "citizen", "category"

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.rating,
    required this.category,
    required this.type,
  });
}
