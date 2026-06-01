class FoodModel {
  final String id;
  final String name;
  final String category;
  final String description;
  final double price;
  final String imageUrl;
  final double rating;
  final int deliveryTime;

  FoodModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.deliveryTime,
  });

  factory FoodModel.fromMap(Map<String, dynamic> map, String id) {
    return FoodModel(
      id: id,
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      deliveryTime: map['deliveryTime'] ?? 30,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'rating': rating,
      'deliveryTime': deliveryTime,
    };
  }
}
