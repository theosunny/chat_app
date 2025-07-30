import 'user_model.dart';

class BottleModel {
  final String id;
  final String content;
  final String? imageUrl;
  final UserModel author;
  final int likeCount;
  final int replyCount;
  final bool isLiked;
  final bool isReplied;
  final DateTime createdAt;
  final DateTime? pickedAt;
  final List<BottleReply> replies;
  
  BottleModel({
    required this.id,
    required this.content,
    this.imageUrl,
    required this.author,
    this.likeCount = 0,
    this.replyCount = 0,
    this.isLiked = false,
    this.isReplied = false,
    required this.createdAt,
    this.pickedAt,
    this.replies = const [],
  });
  
  factory BottleModel.fromJson(Map<String, dynamic> json) {
    return BottleModel(
      id: json['id']?.toString() ?? '',
      content: json['content'] ?? '',
      imageUrl: json['image_url'],
      author: UserModel.fromJson(json['user'] ?? json['author'] ?? {}),
      likeCount: json['like_count'] ?? 0,
      replyCount: json['reply_count'] ?? 0,
      isLiked: json['is_liked'] ?? false,
      isReplied: json['is_replied'] ?? false,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      pickedAt: json['picked_at'] != null ? DateTime.parse(json['picked_at']) : null,
      replies: (json['replies'] as List<dynamic>? ?? [])
          .map((reply) => BottleReply.fromJson(reply))
          .toList(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'image_url': imageUrl,
      'author': author.toJson(),
      'like_count': likeCount,
      'reply_count': replyCount,
      'is_liked': isLiked,
      'is_replied': isReplied,
      'created_at': createdAt.toIso8601String(),
      'picked_at': pickedAt?.toIso8601String(),
      'replies': replies.map((reply) => reply.toJson()).toList(),
    };
  }
  
  BottleModel copyWith({
    String? id,
    String? content,
    String? imageUrl,
    UserModel? author,
    int? likeCount,
    int? replyCount,
    bool? isLiked,
    bool? isReplied,
    DateTime? createdAt,
    DateTime? pickedAt,
    List<BottleReply>? replies,
  }) {
    return BottleModel(
      id: id ?? this.id,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      author: author ?? this.author,
      likeCount: likeCount ?? this.likeCount,
      replyCount: replyCount ?? this.replyCount,
      isLiked: isLiked ?? this.isLiked,
      isReplied: isReplied ?? this.isReplied,
      createdAt: createdAt ?? this.createdAt,
      pickedAt: pickedAt ?? this.pickedAt,
      replies: replies ?? this.replies,
    );
  }
}

class BottleReply {
  final String id;
  final String content;
  final UserModel author;
  final DateTime createdAt;
  
  BottleReply({
    required this.id,
    required this.content,
    required this.author,
    required this.createdAt,
  });
  
  factory BottleReply.fromJson(Map<String, dynamic> json) {
    return BottleReply(
      id: json['id']?.toString() ?? '',
      content: json['content'] ?? '',
      author: UserModel.fromJson(json['author'] ?? {}),
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'author': author.toJson(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}