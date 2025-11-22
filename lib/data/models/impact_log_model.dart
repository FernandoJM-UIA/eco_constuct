import '../../domain/entities/impact_log.dart';

class ImpactLogModel extends ImpactLog {
  const ImpactLogModel({
    required super.id,
    required super.userId,
    required super.materialId,
    required super.co2Saved,
    required super.energySaved,
    required super.waterSaved,
    required super.timestamp,
  });

  factory ImpactLogModel.fromJson(Map<String, dynamic> json) {
    return ImpactLogModel(
      id: json['id'],
      userId: json['userId'],
      materialId: json['materialId'],
      co2Saved: (json['co2Saved'] as num).toDouble(),
      energySaved: (json['energySaved'] as num).toDouble(),
      waterSaved: (json['waterSaved'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'materialId': materialId,
      'co2Saved': co2Saved,
      'energySaved': energySaved,
      'waterSaved': waterSaved,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ImpactLogModel.fromEntity(ImpactLog log) {
    return ImpactLogModel(
      id: log.id,
      userId: log.userId,
      materialId: log.materialId,
      co2Saved: log.co2Saved,
      energySaved: log.energySaved,
      waterSaved: log.waterSaved,
      timestamp: log.timestamp,
    );
  }
}
