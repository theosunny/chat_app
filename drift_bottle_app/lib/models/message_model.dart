import 'user_model.dart';

class MessageModel {
  final String id;
  final String content;
  final MessageType type;
  final UserModel sender;
  final UserModel? receiver;
  final String? relatedId; // 关联的瓶子或动态ID
  final bool isRead;
  final DateTime createdAt;
  
  MessageModel({
    required this.id,
    required this.content,
    required this.type,
    required this.sender,
    this.receiver,
    this.relatedId,
    this.isRead = false,
    required this.createdAt,
  });
  
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      type: MessageType.values[json['type'] ?? 0],
      sender: UserModel.fromJson(json['sender'] ?? {}),
      receiver: json['receiver'] != null 
          ? UserModel.fromJson(json['receiver']) 
          : null,
      relatedId: json['related_id'],
      isRead: json['is_read'] ?? false,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'type': type.index,
      'sender': sender.toJson(),
      'receiver': receiver?.toJson(),
      'related_id': relatedId,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
    };
  }
  
  MessageModel copyWith({
    String? id,
    String? content,
    MessageType? type,
    UserModel? sender,
    UserModel? receiver,
    String? relatedId,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return MessageModel(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
      relatedId: relatedId ?? this.relatedId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
  
  String get displayText {
    switch (type) {
      case MessageType.bottleReply:
        return '回复了你的漂流瓶';
      case MessageType.momentComment:
        return '评论了你的动态';
      case MessageType.momentLike:
        return '点赞了你的动态';
      case MessageType.follow:
        return '关注了你';
      case MessageType.privateMessage:
        return content;
      case MessageType.system:
        return content;
      case MessageType.text:
        return content;
      case MessageType.image:
        return '[图片]';
      default:
        return content;
    }
  }
}

enum MessageType {
  text,           // 文本消息
  image,          // 图片消息
  bottleReply,    // 瓶子回复
  momentComment,  // 动态评论
  momentLike,     // 动态点赞
  follow,         // 关注
  privateMessage, // 私信
  system,         // 系统消息
}

class ConversationModel {
  final String id;
  final UserModel otherUser;
  final MessageModel? lastMessage;
  final int unreadCount;
  final DateTime updatedAt;
  
  ConversationModel({
    required this.id,
    required this.otherUser,
    this.lastMessage,
    this.unreadCount = 0,
    required this.updatedAt,
  });
  
  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] ?? '',
      otherUser: UserModel.fromJson(json['other_user'] ?? {}),
      lastMessage: json['last_message'] != null 
          ? MessageModel.fromJson(json['last_message']) 
          : null,
      unreadCount: json['unread_count'] ?? 0,
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'other_user': otherUser.toJson(),
      'last_message': lastMessage?.toJson(),
      'unread_count': unreadCount,
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}