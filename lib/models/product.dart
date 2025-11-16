class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final String category;
  final int stock;
  final double rating;
  final int reviews;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    required this.stock,
    required this.rating,
    required this.reviews,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      image: json['image'],
      category: json['category'],
      stock: json['stock'],
      rating: (json['rating'] as num).toDouble(),
      reviews: json['reviews'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'category': category,
      'stock': stock,
      'rating': rating,
      'reviews': reviews,
    };
  }
}
