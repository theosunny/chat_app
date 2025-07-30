import 'user_model.dart';

class MomentModel {
  final String id;
  final String content;
  final List<String> images;
  final UserModel author;
  final int likeCount;
  final int commentCount;
  final bool isLiked;
  final DateTime createdAt;
  final List<MomentComment> comments;
  
  MomentModel({
    required this.id,
    required this.content,
    this.images = const [],
    required this.author,
    this.likeCount = 0,
    this.commentCount = 0,
    this.isLiked = false,
    required this.createdAt,
    this.comments = const [],
  });
  
  factory MomentModel.fromJson(Map<String, dynamic> json) {
    return MomentModel(
      id: json['id']?.toString() ?? '',
      content: json['content'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      author: UserModel.fromJson(json['author'] ?? {}),
      likeCount: json['like_count'] ?? 0,
      commentCount: json['comment_count'] ?? 0,
      isLiked: json['is_liked'] ?? false,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      comments: (json['comments'] as List<dynamic>? ?? [])
          .map((comment) => MomentComment.fromJson(comment))
          .toList(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'images': images,
      'author': author.toJson(),
      'like_count': likeCount,
      'comment_count': commentCount,
      'is_liked': isLiked,
      'created_at': createdAt.toIso8601String(),
      'comments': comments.map((comment) => comment.toJson()).toList(),
    };
  }
  
  MomentModel copyWith({
    String? id,
    String? content,
    List<String>? images,
    UserModel? author,
    int? likeCount,
    int? commentCount,
    bool? isLiked,
    DateTime? createdAt,
    List<MomentComment>? comments,
  }) {
    return MomentModel(
      id: id ?? this.id,
      content: content ?? this.content,
      images: images ?? this.images,
      author: author ?? this.author,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt ?? this.createdAt,
      comments: comments ?? this.comments,
    );
  }
}

class MomentComment {
  final String id;
  final String content;
  final UserModel author;
  final DateTime createdAt;
  final String? replyToId;
  final UserModel? replyToUser;
  final List<MomentComment> replies;
  
  MomentComment({
    required this.id,
    required this.content,
    required this.author,
    required this.createdAt,
    this.replyToId,
    this.replyToUser,
    this.replies = const [],
  });
  
  factory MomentComment.fromJson(Map<String, dynamic> json) {
    return MomentComment(
      id: json['id']?.toString() ?? '',
      content: json['content'] ?? '',
      author: UserModel.fromJson(json['author'] ?? {}),
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      replyToId: json['reply_to_id'],
      replyToUser: json['reply_to_user'] != null 
          ? UserModel.fromJson(json['reply_to_user']) 
          : null,
      replies: (json['replies'] as List<dynamic>? ?? [])
          .map((reply) => MomentComment.fromJson(reply))
          .toList(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'author': author.toJson(),
      'created_at': createdAt.toIso8601String(),
      'reply_to_id': replyToId,
      'reply_to_user': replyToUser?.toJson(),
      'replies': replies.map((reply) => reply.toJson()).toList(),
    };
  }
}