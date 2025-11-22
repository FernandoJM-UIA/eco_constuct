import '../../domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.fromUserId,
    required super.toUserId,
    required super.materialId,
    required super.text,
    required super.timestamp,
    super.isRead,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      fromUserId: json['fromUserId'],
      toUserId: json['toUserId'],
      materialId: json['materialId'],
      text: json['text'],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'materialId': materialId,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
    };
  }

  factory MessageModel.fromEntity(Message message) {
    return MessageModel(
      id: message.id,
      fromUserId: message.fromUserId,
      toUserId: message.toUserId,
      materialId: message.materialId,
      text: message.text,
      timestamp: message.timestamp,
      isRead: message.isRead,
    );
  }
}
