// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MomentModel _$MomentModelFromJson(Map<String, dynamic> json) => MomentModel(
      id: json['id'] as String,
      author: UserModel.fromJson(json['author'] as Map<String, dynamic>),
      content: json['content'] as String,
      imageUrls: (json['image_urls'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      videoUrl: json['video_url'] as String?,
      location: json['location'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      likeCount: (json['like_count'] as num).toInt(),
      commentCount: (json['comment_count'] as num).toInt(),
      shareCount: (json['share_count'] as num).toInt(),
      isLiked: json['is_liked'] as bool,
      isBookmarked: json['is_bookmarked'] as bool,
      visibility: json['visibility'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$MomentModelToJson(MomentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author': instance.author,
      'content': instance.content,
      'image_urls': instance.imageUrls,
      'video_url': instance.videoUrl,
      'location': instance.location,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'like_count': instance.likeCount,
      'comment_count': instance.commentCount,
      'share_count': instance.shareCount,
      'is_liked': instance.isLiked,
      'is_bookmarked': instance.isBookmarked,
      'visibility': instance.visibility,
      'tags': instance.tags,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'metadata': instance.metadata,
    };

MomentListModel _$MomentListModelFromJson(Map<String, dynamic> json) =>
    MomentListModel(
      moments: (json['moments'] as List<dynamic>)
          .map((e) => MomentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['total_count'] as num).toInt(),
      hasMore: json['has_more'] as bool,
      nextCursor: json['next_cursor'] as String?,
      prevCursor: json['prev_cursor'] as String?,
    );

Map<String, dynamic> _$MomentListModelToJson(MomentListModel instance) =>
    <String, dynamic>{
      'moments': instance.moments,
      'total_count': instance.totalCount,
      'has_more': instance.hasMore,
      'next_cursor': instance.nextCursor,
      'prev_cursor': instance.prevCursor,
    };

MomentStatsModel _$MomentStatsModelFromJson(Map<String, dynamic> json) =>
    MomentStatsModel(
      totalMoments: (json['total_moments'] as num).toInt(),
      totalLikes: (json['total_likes'] as num).toInt(),
      totalComments: (json['total_comments'] as num).toInt(),
      totalShares: (json['total_shares'] as num).toInt(),
      todayMoments: (json['today_moments'] as num).toInt(),
      thisWeekMoments: (json['this_week_moments'] as num).toInt(),
      thisMonthMoments: (json['this_month_moments'] as num).toInt(),
      visibilityStats: Map<String, int>.from(json['visibility_stats'] as Map),
    );

Map<String, dynamic> _$MomentStatsModelToJson(MomentStatsModel instance) =>
    <String, dynamic>{
      'total_moments': instance.totalMoments,
      'total_likes': instance.totalLikes,
      'total_comments': instance.totalComments,
      'total_shares': instance.totalShares,
      'today_moments': instance.todayMoments,
      'this_week_moments': instance.thisWeekMoments,
      'this_month_moments': instance.thisMonthMoments,
      'visibility_stats': instance.visibilityStats,
    };
