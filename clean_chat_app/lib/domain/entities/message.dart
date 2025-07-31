import 'package:equatable/equatable.dart';
import 'user.dart';

/// 消息类型枚举
enum MessageType {
  text,
  image,
  file,
  system,
}

/// 消息实体
class Message extends Equatable {
  final int id;
  final int conversationId;
  final int senderId;
  final int receiverId;
  final String content;
  final MessageType messageType;
  final bool isRead;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User? sender;
  final User? receiver;

  const Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.receiverId,
    required this.content,
    this.messageType = MessageType.text,
    this.isRead = false,
    required this.createdAt,
    required this.updatedAt,
    this.sender,
    this.receiver,
  });

  /// 是否为文本消息
  bool get isTextMessage => messageType == MessageType.text;

  /// 是否为图片消息
  bool get isImageMessage => messageType == MessageType.image;

  /// 是否为文件消息
  bool get isFileMessage => messageType == MessageType.file;

  /// 是否为系统消息
  bool get isSystemMessage => messageType == MessageType.system;

  /// 复制并更新字段
  Message copyWith({
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
    return Message(
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

  @override
  List<Object?> get props => [
        id,
        conversationId,
        senderId,
        receiverId,
        content,
        messageType,
        isRead,
        createdAt,
        updatedAt,
        sender,
        receiver,
      ];

  @override
  String toString() {
    return 'Message(id: $id, senderId: $senderId, content: $content, messageType: $messageType)';
  }
}