import 'package:equatable/equatable.dart';
import 'user.dart';

/// 动态实体
class Moment extends Equatable {
  final String id;
  final User author;
  final String content;
  final List<String> imageUrls;
  final String? videoUrl;
  final String? location;
  final double? latitude;
  final double? longitude;
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final bool isLiked;
  final bool isBookmarked;
  final String visibility; // 'public', 'friends', 'private'
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic> metadata;
  
  const Moment({
    required this.id,
    required this.author,
    required this.content,
    required this.imageUrls,
    this.videoUrl,
    this.location,
    this.latitude,
    this.longitude,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    required this.isLiked,
    required this.isBookmarked,
    required this.visibility,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
    required this.metadata,
  });
  
  /// 复制并修改
  Moment copyWith({
    String? id,
    User? author,
    String? content,
    List<String>? imageUrls,
    String? videoUrl,
    String? location,
    double? latitude,
    double? longitude,
    int? likeCount,
    int? commentCount,
    int? shareCount,
    bool? isLiked,
    bool? isBookmarked,
    String? visibility,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return Moment(
      id: id ?? this.id,
      author: author ?? this.author,
      content: content ?? this.content,
      imageUrls: imageUrls ?? this.imageUrls,
      videoUrl: videoUrl ?? this.videoUrl,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      shareCount: shareCount ?? this.shareCount,
      isLiked: isLiked ?? this.isLiked,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      visibility: visibility ?? this.visibility,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }
  
  /// 检查是否有图片
  bool get hasImages => imageUrls.isNotEmpty;
  
  /// 检查是否有视频
  bool get hasVideo => videoUrl != null && videoUrl!.isNotEmpty;
  
  /// 检查是否有位置信息
  bool get hasLocation => location != null && location!.isNotEmpty;
  
  /// 检查是否有地理坐标
  bool get hasCoordinates => latitude != null && longitude != null;
  
  /// 检查是否为公开动态
  bool get isPublic => visibility == 'public';
  
  /// 检查是否为朋友可见
  bool get isFriendsOnly => visibility == 'friends';
  
  /// 检查是否为私密动态
  bool get isPrivate => visibility == 'private';
  
  @override
  List<Object?> get props => [
        id,
        author,
        content,
        imageUrls,
        videoUrl,
        location,
        latitude,
        longitude,
        likeCount,
        commentCount,
        shareCount,
        isLiked,
        isBookmarked,
        visibility,
        tags,
        createdAt,
        updatedAt,
        metadata,
      ];
  
  @override
  String toString() {
    return 'Moment(id: $id, author: ${author.nickname}, content: $content, likeCount: $likeCount)';
  }
}