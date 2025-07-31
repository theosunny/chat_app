// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bottle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BottleModel _$BottleModelFromJson(Map<String, dynamic> json) => BottleModel(
      id: json['id'] as String,
      content: json['content'] as String,
      imageUrl: json['image_url'] as String?,
      author: UserModel.fromJson(json['author'] as Map<String, dynamic>),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      locationName: json['location_name'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      likesCount: (json['likes_count'] as num).toInt(),
      commentsCount: (json['comments_count'] as num).toInt(),
      picksCount: (json['picks_count'] as num).toInt(),
      isLiked: json['is_liked'] as bool,
      isFavorited: json['is_favorited'] as bool,
      isPicked: json['is_picked'] as bool,
      status: json['status'] as String,
      visibility: json['visibility'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
      pickedAt: json['picked_at'] == null
          ? null
          : DateTime.parse(json['picked_at'] as String),
      pickedBy: json['picked_by'] == null
          ? null
          : UserModel.fromJson(json['picked_by'] as Map<String, dynamic>),
      distance: (json['distance'] as num?)?.toDouble(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$BottleModelToJson(BottleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'image_url': instance.imageUrl,
      'author': instance.author,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'location_name': instance.locationName,
      'tags': instance.tags,
      'likes_count': instance.likesCount,
      'comments_count': instance.commentsCount,
      'picks_count': instance.picksCount,
      'is_liked': instance.isLiked,
      'is_favorited': instance.isFavorited,
      'is_picked': instance.isPicked,
      'status': instance.status,
      'visibility': instance.visibility,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'expires_at': instance.expiresAt?.toIso8601String(),
      'picked_at': instance.pickedAt?.toIso8601String(),
      'picked_by': instance.pickedBy,
      'distance': instance.distance,
      'metadata': instance.metadata,
    };

BottleListModel _$BottleListModelFromJson(Map<String, dynamic> json) =>
    BottleListModel(
      bottles: (json['bottles'] as List<dynamic>)
          .map((e) => BottleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['total_count'] as num).toInt(),
      hasMore: json['has_more'] as bool,
      nextCursor: json['next_cursor'] as String?,
      prevCursor: json['prev_cursor'] as String?,
    );

Map<String, dynamic> _$BottleListModelToJson(BottleListModel instance) =>
    <String, dynamic>{
      'bottles': instance.bottles,
      'total_count': instance.totalCount,
      'has_more': instance.hasMore,
      'next_cursor': instance.nextCursor,
      'prev_cursor': instance.prevCursor,
    };

BottleStatsModel _$BottleStatsModelFromJson(Map<String, dynamic> json) =>
    BottleStatsModel(
      totalSent: (json['total_sent'] as num).toInt(),
      totalPicked: (json['total_picked'] as num).toInt(),
      totalLiked: (json['total_liked'] as num).toInt(),
      totalFavorited: (json['total_favorited'] as num).toInt(),
      todaySent: (json['today_sent'] as num).toInt(),
      todayPicked: (json['today_picked'] as num).toInt(),
      thisWeekSent: (json['this_week_sent'] as num).toInt(),
      thisWeekPicked: (json['this_week_picked'] as num).toInt(),
      thisMonthSent: (json['this_month_sent'] as num).toInt(),
      thisMonthPicked: (json['this_month_picked'] as num).toInt(),
    );

Map<String, dynamic> _$BottleStatsModelToJson(BottleStatsModel instance) =>
    <String, dynamic>{
      'total_sent': instance.totalSent,
      'total_picked': instance.totalPicked,
      'total_liked': instance.totalLiked,
      'total_favorited': instance.totalFavorited,
      'today_sent': instance.todaySent,
      'today_picked': instance.todayPicked,
      'this_week_sent': instance.thisWeekSent,
      'this_week_picked': instance.thisWeekPicked,
      'this_month_sent': instance.thisMonthSent,
      'this_month_picked': instance.thisMonthPicked,
    };
