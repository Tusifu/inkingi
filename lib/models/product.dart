class Product {
  final String id;
  final String name;
  final double price;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'category': category,
      };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        name: json['name'],
        price: json['price'],
        category: json['category'],
      );
}
