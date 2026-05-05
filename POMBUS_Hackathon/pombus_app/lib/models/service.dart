class Service {
  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final String iconUrl;
  final bool available;
  final DateTime createdAt;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.iconUrl,
    required this.available,
    required this.createdAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      iconUrl: json['iconUrl'] as String? ?? '',
      available: json['available'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'iconUrl': iconUrl,
      'available': available,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
