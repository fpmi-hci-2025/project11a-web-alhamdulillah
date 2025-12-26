class MenuItemModel {
  final String id;
  final String name;
  final String description;
  final String price; // keep as string like backend
  final String imageUrl;
  final bool isAvailable;
  final String categoryId;
  final String? oldPrice; // для скидок

  MenuItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.isAvailable,
    required this.categoryId,
    this.oldPrice,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) => MenuItemModel(
    id: json['id']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
    description: json['description']?.toString() ?? '',
    price: json['price']?.toString() ?? '0',
    imageUrl: json['image_url']?.toString() ?? '',
    isAvailable: json['is_available'] ?? true,
    categoryId: json['category_id']?.toString() ?? '',
    oldPrice: json['old_price']?.toString(),
  );
}

