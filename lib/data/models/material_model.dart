import '../../domain/entities/material_item.dart';

class MaterialModel extends MaterialItem {
  const MaterialModel({
    required super.id,
    required super.name,
    required super.description,
    required super.category,
    required super.quantity,
    required super.unit,
    required super.price,
    required super.locationDescription,
    required super.latitude,
    required super.longitude,
    required super.sellerId,
    required super.createdAt,
    super.status,
    super.imageUrls,
  });

  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    return MaterialModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: MaterialCategory.values.firstWhere(
        (e) => e.toString() == json['category'],
        orElse: () => MaterialCategory.other,
      ),
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'],
      price: (json['price'] as num).toDouble(),
      locationDescription: json['locationDescription'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      sellerId: json['sellerId'],
      createdAt: DateTime.parse(json['createdAt']),
      status: MaterialStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => MaterialStatus.available,
      ),
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category.toString(),
      'quantity': quantity,
      'unit': unit,
      'price': price,
      'locationDescription': locationDescription,
      'latitude': latitude,
      'longitude': longitude,
      'sellerId': sellerId,
      'createdAt': createdAt.toIso8601String(),
      'status': status.toString(),
      'imageUrls': imageUrls,
    };
  }

  factory MaterialModel.fromEntity(MaterialItem item) {
    return MaterialModel(
      id: item.id,
      name: item.name,
      description: item.description,
      category: item.category,
      quantity: item.quantity,
      unit: item.unit,
      price: item.price,
      locationDescription: item.locationDescription,
      latitude: item.latitude,
      longitude: item.longitude,
      sellerId: item.sellerId,
      createdAt: item.createdAt,
      status: item.status,
      imageUrls: item.imageUrls,
    );
  }
}
