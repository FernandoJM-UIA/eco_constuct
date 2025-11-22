import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String id;
  final String fromUserId;
  final String toUserId;
  final String materialId;
  final String text;
  final DateTime timestamp;
  final bool isRead;

  const Message({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.materialId,
    required this.text,
    required this.timestamp,
    this.isRead = false,
  });

  Message copyWith({
    String? id,
    String? fromUserId,
    String? toUserId,
    String? materialId,
    String? text,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return Message(
      id: id ?? this.id,
      fromUserId: fromUserId ?? this.fromUserId,
      toUserId: toUserId ?? this.toUserId,
      materialId: materialId ?? this.materialId,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  List<Object?> get props => [
        id,
        fromUserId,
        toUserId,
        materialId,
        text,
        timestamp,
        isRead,
      ];
}
