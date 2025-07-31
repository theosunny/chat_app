import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/moment.dart';
import 'user_model.dart';

part 'moment_model.g.dart';

/// 动态模型
@JsonSerializable()
class MomentModel {
  @JsonKey(name: 'id')
  final String id;
  
  @JsonKey(name: 'author')
  final UserModel author;
  
  @JsonKey(name: 'content')
  final String content;
  
  @JsonKey(name: 'image_urls')
  final List<String> imageUrls;
  
  @JsonKey(name: 'video_url')
  final String? videoUrl;
  
  @JsonKey(name: 'location')
  final String? location;
  
  @JsonKey(name: 'latitude')
  final double? latitude;
  
  @JsonKey(name: 'longitude')
  final double? longitude;
  
  @JsonKey(name: 'like_count')
  final int likeCount;
  
  @JsonKey(name: 'comment_count')
  final int commentCount;
  
  @JsonKey(name: 'share_count')
  final int shareCount;
  
  @JsonKey(name: 'is_liked')
  final bool isLiked;
  
  @JsonKey(name: 'is_bookmarked')
  final bool isBookmarked;
  
  @JsonKey(name: 'visibility')
  final String visibility;
  
  @JsonKey(name: 'tags')
  final List<String> tags;
  
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  
  @JsonKey(name: 'metadata')
  final Map<String, dynamic>? metadata;
  
  const MomentModel({
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
    this.metadata,
  });
  
  /// 从JSON创建模型
  factory MomentModel.fromJson(Map<String, dynamic> json) => _$MomentModelFromJson(json);
  
  /// 转换为JSON
  Map<String, dynamic> toJson() => _$MomentModelToJson(this);
  
  /// 转换为实体
  Moment toEntity() {
    return Moment(
      id: id,
      author: author.toEntity(),
      content: content,
      imageUrls: imageUrls,
      videoUrl: videoUrl,
      location: location,
      latitude: latitude,
      longitude: longitude,
      likeCount: likeCount,
      commentCount: commentCount,
      shareCount: shareCount,
      isLiked: isLiked,
      isBookmarked: isBookmarked,
      visibility: visibility,
      tags: tags,
      createdAt: createdAt,
      updatedAt: updatedAt,
      metadata: metadata ?? {},
    );
  }
  
  /// 从实体创建模型
  factory MomentModel.fromEntity(Moment moment) {
    return MomentModel(
      id: moment.id,
      author: UserModel.fromEntity(moment.author),
      content: moment.content,
      imageUrls: moment.imageUrls,
      videoUrl: moment.videoUrl,
      location: moment.location,
      latitude: moment.latitude,
      longitude: moment.longitude,
      likeCount: moment.likeCount,
      commentCount: moment.commentCount,
      shareCount: moment.shareCount,
      isLiked: moment.isLiked,
      isBookmarked: moment.isBookmarked,
      visibility: moment.visibility,
      tags: moment.tags,
      createdAt: moment.createdAt,
      updatedAt: moment.updatedAt,
      metadata: moment.metadata,
    );
  }
  
  /// 复制并修改
  MomentModel copyWith({
    String? id,
    UserModel? author,
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
    return MomentModel(
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
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is MomentModel &&
        other.id == id &&
        other.author == author &&
        other.content == content &&
        other.imageUrls == imageUrls &&
        other.videoUrl == videoUrl &&
        other.location == location &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.likeCount == likeCount &&
        other.commentCount == commentCount &&
        other.shareCount == shareCount &&
        other.isLiked == isLiked &&
        other.isBookmarked == isBookmarked &&
        other.visibility == visibility &&
        other.tags == tags &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }
  
  @override
  int get hashCode {
    return id.hashCode ^
        author.hashCode ^
        content.hashCode ^
        imageUrls.hashCode ^
        videoUrl.hashCode ^
        location.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        likeCount.hashCode ^
        commentCount.hashCode ^
        shareCount.hashCode ^
        isLiked.hashCode ^
        isBookmarked.hashCode ^
        visibility.hashCode ^
        tags.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
  
  @override
  String toString() {
    return 'MomentModel(id: $id, author: ${author.nickname}, content: $content, likeCount: $likeCount)';
  }
}

/// 动态列表模型
@JsonSerializable()
class MomentListModel {
  @JsonKey(name: 'moments')
  final List<MomentModel> moments;
  
  @JsonKey(name: 'total_count')
  final int totalCount;
  
  @JsonKey(name: 'has_more')
  final bool hasMore;
  
  @JsonKey(name: 'next_cursor')
  final String? nextCursor;
  
  @JsonKey(name: 'prev_cursor')
  final String? prevCursor;
  
  const MomentListModel({
    required this.moments,
    required this.totalCount,
    required this.hasMore,
    this.nextCursor,
    this.prevCursor,
  });
  
  /// 从JSON创建模型
  factory MomentListModel.fromJson(Map<String, dynamic> json) => _$MomentListModelFromJson(json);
  
  /// 转换为JSON
  Map<String, dynamic> toJson() => _$MomentListModelToJson(this);
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is MomentListModel &&
        other.moments == moments &&
        other.totalCount == totalCount &&
        other.hasMore == hasMore &&
        other.nextCursor == nextCursor &&
        other.prevCursor == prevCursor;
  }
  
  @override
  int get hashCode {
    return moments.hashCode ^
        totalCount.hashCode ^
        hasMore.hashCode ^
        nextCursor.hashCode ^
        prevCursor.hashCode;
  }
  
  @override
  String toString() {
    return 'MomentListModel(moments: ${moments.length}, totalCount: $totalCount, hasMore: $hasMore)';
  }
}

/// 动态统计模型
@JsonSerializable()
class MomentStatsModel {
  @JsonKey(name: 'total_moments')
  final int totalMoments;
  
  @JsonKey(name: 'total_likes')
  final int totalLikes;
  
  @JsonKey(name: 'total_comments')
  final int totalComments;
  
  @JsonKey(name: 'total_shares')
  final int totalShares;
  
  @JsonKey(name: 'today_moments')
  final int todayMoments;
  
  @JsonKey(name: 'this_week_moments')
  final int thisWeekMoments;
  
  @JsonKey(name: 'this_month_moments')
  final int thisMonthMoments;
  
  @JsonKey(name: 'visibility_stats')
  final Map<String, int> visibilityStats;
  
  const MomentStatsModel({
    required this.totalMoments,
    required this.totalLikes,
    required this.totalComments,
    required this.totalShares,
    required this.todayMoments,
    required this.thisWeekMoments,
    required this.thisMonthMoments,
    required this.visibilityStats,
  });
  
  /// 从JSON创建模型
  factory MomentStatsModel.fromJson(Map<String, dynamic> json) => _$MomentStatsModelFromJson(json);
  
  /// 转换为JSON
  Map<String, dynamic> toJson() => _$MomentStatsModelToJson(this);
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is MomentStatsModel &&
        other.totalMoments == totalMoments &&
        other.totalLikes == totalLikes &&
        other.totalComments == totalComments &&
        other.totalShares == totalShares &&
        other.todayMoments == todayMoments &&
        other.thisWeekMoments == thisWeekMoments &&
        other.thisMonthMoments == thisMonthMoments;
  }
  
  @override
  int get hashCode {
    return totalMoments.hashCode ^
        totalLikes.hashCode ^
        totalComments.hashCode ^
        totalShares.hashCode ^
        todayMoments.hashCode ^
        thisWeekMoments.hashCode ^
        thisMonthMoments.hashCode ^
        visibilityStats.hashCode;
  }
  
  @override
  String toString() {
    return 'MomentStatsModel(totalMoments: $totalMoments, totalLikes: $totalLikes, totalComments: $totalComments)';
  }
}