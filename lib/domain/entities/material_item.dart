import 'package:equatable/equatable.dart';

enum MaterialCategory {
  electrical,
  hydraulic,
  signalCommunication,
  wood,
  glass,
  metal,
  concreteMasonry,
  other,
}

enum MaterialCondition {
  newUnused,
  likeNew,
  usedGood,
  usedAcceptable,
  forParts,
  industrialSurplus,
}

enum MaterialStatus {
  available,
  reserved,
  sold,
}

class MaterialItem extends Equatable {
  final String id;
  final String name;
  final String description;
  final MaterialCategory category;
  final String? subCategory;
  final MaterialCondition condition;
  final double quantity;
  final String unit;
  final double price;
  final String locationDescription;
  final double latitude;
  final double longitude;
  final String sellerId;
  final DateTime createdAt;
  final MaterialStatus status;
  final List<String> imageUrls;

  const MaterialItem({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    this.subCategory,
    this.condition = MaterialCondition.newUnused,
    required this.quantity,
    required this.unit,
    required this.price,
    required this.locationDescription,
    required this.latitude,
    required this.longitude,
    required this.sellerId,
    required this.createdAt,
    this.status = MaterialStatus.available,
    this.imageUrls = const [],
  });

  MaterialItem copyWith({
    String? id,
    String? name,
    String? description,
    MaterialCategory? category,
    String? subCategory,
    MaterialCondition? condition,
    double? quantity,
    String? unit,
    double? price,
    String? locationDescription,
    double? latitude,
    double? longitude,
    String? sellerId,
    DateTime? createdAt,
    MaterialStatus? status,
    List<String>? imageUrls,
  }) {
    return MaterialItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      condition: condition ?? this.condition,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      price: price ?? this.price,
      locationDescription: locationDescription ?? this.locationDescription,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      sellerId: sellerId ?? this.sellerId,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      imageUrls: imageUrls ?? this.imageUrls,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        category,
        subCategory,
        condition,
        quantity,
        unit,
        price,
        locationDescription,
        latitude,
        longitude,
        sellerId,
        createdAt,
        status,
        imageUrls,
      ];
}
