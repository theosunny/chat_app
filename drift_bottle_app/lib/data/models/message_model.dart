import 'package:json_annotation/json_annotation.dart';

import 'user_model.dart';

part 'message_model.g.dart';

/// 消息模型 - 与后端API保持一致
@JsonSerializable()
class MessageModel {
  @JsonKey(name: 'id')
  final int id;
  
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  
  @JsonKey(name: 'conversation_id')
  final int conversationId;
  
  @JsonKey(name: 'sender_id')
  final int senderId;
  
  @JsonKey(name: 'receiver_id')
  final int receiverId;
  
  @JsonKey(name: 'content')
  final String content;
  
  @JsonKey(name: 'message_type')
  final String messageType; // 'text', 'image', 'file'
  
  @JsonKey(name: 'is_read')
  final bool isRead;
  
  // 关联对象
  @JsonKey(name: 'sender')
  final UserModel? sender;
  
  @JsonKey(name: 'receiver')
  final UserModel? receiver;

  const MessageModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.conversationId,
    required this.senderId,
    required this.receiverId,
    required this.content,
    this.messageType = 'text',
    this.isRead = false,
    this.sender,
    this.receiver,
  });
  
  /// 从JSON创建模型
  factory MessageModel.fromJson(Map<String, dynamic> json) => _$MessageModelFromJson(json);
  
  /// 转换为JSON
  Map<String, dynamic> toJson() => _$MessageModelToJson(this);

  /// 复制并更新字段
  MessageModel copyWith({
    int? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? conversationId,
    int? senderId,
    int? receiverId,
    String? content,
    String? messageType,
    bool? isRead,
    UserModel? sender,
    UserModel? receiver,
  }) {
    return MessageModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      content: content ?? this.content,
      messageType: messageType ?? this.messageType,
      isRead: isRead ?? this.isRead,
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
    );
  }
}