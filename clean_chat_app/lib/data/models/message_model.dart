import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/user.dart';
import 'user_model.dart';

part 'message_model.g.dart';

/// 消息数据模型
@JsonSerializable()
class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.conversationId,
    required super.senderId,
    required super.receiverId,
    required super.content,
    required super.messageType,
    super.isRead = false,
    required super.createdAt,
    required super.updatedAt,
    super.sender,
    super.receiver,
  });

  /// 从JSON创建MessageModel
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as int,
      conversationId: json['conversationId'] as int,
      senderId: json['senderId'] as int,
      receiverId: json['receiverId'] as int,
      content: json['content'] as String,
      messageType: MessageType.values.firstWhere(
        (e) => e.toString().split('.').last == json['messageType'],
        orElse: () => MessageType.text,
      ),
      isRead: json['isRead'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      sender: json['sender'] != null 
          ? UserModel.fromJson(json['sender'] as Map<String, dynamic>).toEntity()
          : null,
      receiver: json['receiver'] != null 
          ? UserModel.fromJson(json['receiver'] as Map<String, dynamic>).toEntity()
          : null,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversationId': conversationId,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'messageType': messageType.toString().split('.').last,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'sender': sender != null ? UserModel.fromEntity(sender!).toJson() : null,
      'receiver': receiver != null ? UserModel.fromEntity(receiver!).toJson() : null,
    };
  }

  /// 从Message实体创建MessageModel
  factory MessageModel.fromEntity(Message message) {
    return MessageModel(
      id: message.id,
      conversationId: message.conversationId,
      senderId: message.senderId,
      receiverId: message.receiverId,
      content: message.content,
      messageType: message.messageType,
      isRead: message.isRead,
      createdAt: message.createdAt,
      updatedAt: message.updatedAt,
      sender: message.sender,
      receiver: message.receiver,
    );
  }

  /// 转换为Message实体
  Message toEntity() {
    return Message(
      id: id,
      conversationId: conversationId,
      senderId: senderId,
      receiverId: receiverId,
      content: content,
      messageType: messageType,
      isRead: isRead,
      createdAt: createdAt,
      updatedAt: updatedAt,
      sender: sender,
      receiver: receiver,
    );
  }

  /// 复制并更新部分字段
  MessageModel copyWith({
    int? id,
    int? conversationId,
    int? senderId,
    int? receiverId,
    String? content,
    MessageType? messageType,
    bool? isRead,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? sender,
    User? receiver,
  }) {
    return MessageModel(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      content: content ?? this.content,
      messageType: messageType ?? this.messageType,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
    );
  }
}