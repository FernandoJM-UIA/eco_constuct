import 'package:equatable/equatable.dart';

class ImpactLog extends Equatable {
  final String id;
  final String userId;
  final String materialId;
  final double co2Saved;
  final double energySaved;
  final double waterSaved;
  final DateTime timestamp;

  const ImpactLog({
    required this.id,
    required this.userId,
    required this.materialId,
    required this.co2Saved,
    required this.energySaved,
    required this.waterSaved,
    required this.timestamp,
  });

  ImpactLog copyWith({
    String? id,
    String? userId,
    String? materialId,
    double? co2Saved,
    double? energySaved,
    double? waterSaved,
    DateTime? timestamp,
  }) {
    return ImpactLog(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      materialId: materialId ?? this.materialId,
      co2Saved: co2Saved ?? this.co2Saved,
      energySaved: energySaved ?? this.energySaved,
      waterSaved: waterSaved ?? this.waterSaved,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        materialId,
        co2Saved,
        energySaved,
        waterSaved,
        timestamp,
      ];
}
