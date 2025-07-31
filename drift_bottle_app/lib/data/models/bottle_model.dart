import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/bottle.dart';
import 'user_model.dart';

part 'bottle_model.g.dart';

/// 漂流瓶模型
@JsonSerializable()
class BottleModel {
  @JsonKey(name: 'id')
  final String id;
  
  @JsonKey(name: 'content')
  final String content;
  
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  
  @JsonKey(name: 'author')
  final UserModel author;
  
  @JsonKey(name: 'latitude')
  final double? latitude;
  
  @JsonKey(name: 'longitude')
  final double? longitude;
  
  @JsonKey(name: 'location_name')
  final String? locationName;
  
  @JsonKey(name: 'tags')
  final List<String>? tags;
  
  @JsonKey(name: 'likes_count')
  final int likesCount;
  
  @JsonKey(name: 'comments_count')
  final int commentsCount;
  
  @JsonKey(name: 'picks_count')
  final int picksCount;
  
  @JsonKey(name: 'is_liked')
  final bool isLiked;
  
  @JsonKey(name: 'is_favorited')
  final bool isFavorited;
  
  @JsonKey(name: 'is_picked')
  final bool isPicked;
  
  @JsonKey(name: 'status')
  final String status; // 'active', 'deleted', 'reported'
  
  @JsonKey(name: 'visibility')
  final String visibility; // 'public', 'private', 'friends'
  
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  
  @JsonKey(name: 'expires_at')
  final DateTime? expiresAt;
  
  @JsonKey(name: 'picked_at')
  final DateTime? pickedAt;
  
  @JsonKey(name: 'picked_by')
  final UserModel? pickedBy;
  
  @JsonKey(name: 'distance')
  final double? distance; // 距离用户的距离（米）
  
  @JsonKey(name: 'metadata')
  final Map<String, dynamic>? metadata;
  
  const BottleModel({
    required this.id,
    required this.content,
    this.imageUrl,
    required this.author,
    this.latitude,
    this.longitude,
    this.locationName,
    this.tags,
    required this.likesCount,
    required this.commentsCount,
    required this.picksCount,
    required this.isLiked,
    required this.isFavorited,
    required this.isPicked,
    required this.status,
    required this.visibility,
    required this.createdAt,
    required this.updatedAt,
    this.expiresAt,
    this.pickedAt,
    this.pickedBy,
    this.distance,
    this.metadata,
  });
  
  /// 从JSON创建模型
  factory BottleModel.fromJson(Map<String, dynamic> json) => _$BottleModelFromJson(json);
  
  /// 转换为JSON
  Map<String, dynamic> toJson() => _$BottleModelToJson(this);
  
  /// 转换为实体
  Bottle toEntity() {
    return Bottle(
      id: id,
      sender: author.toEntity(),
      content: content,
      contentType: BottleContentType.text, // 根据实际情况设置
      mediaList: imageUrl != null ? [BottleMedia(
         id: '',
         type: MediaType.image,
         url: imageUrl!,
         thumbnailUrl: imageUrl,
         createdAt: createdAt,
       )] : [],
      tags: tags ?? [],
      sendLocation: latitude != null && longitude != null ? BottleLocation(
         latitude: latitude!,
         longitude: longitude!,
         address: locationName,
         timestamp: createdAt,
       ) : null,
      status: _parseBottleStatus(status),
      likeCount: likesCount,
      favoriteCount: isFavorited ? 1 : 0,
      replyCount: commentsCount,
      viewCount: picksCount,
      createdAt: createdAt,
      updatedAt: updatedAt,
      expiredAt: expiresAt,
      pickedAt: pickedAt,
      picker: pickedBy?.toEntity(),
      extra: metadata,
    );
  }
  
  /// 解析瓶子状态
  BottleStatus _parseBottleStatus(String status) {
    switch (status.toLowerCase()) {
      case 'floating':
        return BottleStatus.floating;
      case 'picked':
        return BottleStatus.picked;
      case 'expired':
        return BottleStatus.expired;
      case 'deleted':
        return BottleStatus.deleted;
      default:
        return BottleStatus.floating;
    }
  }
  
  /// 从实体创建模型
  factory BottleModel.fromEntity(Bottle bottle) {
    return BottleModel(
      id: bottle.id,
      content: bottle.content,
      imageUrl: bottle.mediaList.isNotEmpty ? bottle.mediaList.first.url : null,
      author: UserModel.fromEntity(bottle.sender),
      latitude: bottle.sendLocation?.latitude,
      longitude: bottle.sendLocation?.longitude,
      locationName: bottle.sendLocation?.address,
      tags: bottle.tags,
      likesCount: 0, // 需要从其他地方获取
      commentsCount: 0, // 需要从其他地方获取
      picksCount: 0, // 需要从其他地方获取
      isLiked: false, // 需要从其他地方获取
      isFavorited: false, // 需要从其他地方获取
      isPicked: bottle.status == BottleStatus.picked,
      status: _bottleStatusToString(bottle.status),
      visibility: 'public', // 默认值
      createdAt: bottle.createdAt,
      updatedAt: bottle.updatedAt,
      expiresAt: bottle.expiredAt,
      pickedAt: bottle.pickedAt,
      pickedBy: bottle.picker != null ? UserModel.fromEntity(bottle.picker!) : null,
      distance: bottle.driftedDistance,
      metadata: {},
    );
  }
  
  /// 漂流瓶状态转换为字符串
  static String _bottleStatusToString(BottleStatus status) {
    switch (status) {
      case BottleStatus.floating:
        return 'floating';
      case BottleStatus.picked:
        return 'picked';
      case BottleStatus.expired:
        return 'expired';
      case BottleStatus.deleted:
        return 'deleted';
      default:
        return 'floating';
    }
  }
  
  /// 复制并修改
  BottleModel copyWith({
    String? id,
    String? content,
    String? imageUrl,
    UserModel? author,
    double? latitude,
    double? longitude,
    String? locationName,
    List<String>? tags,
    int? likesCount,
    int? commentsCount,
    int? picksCount,
    bool? isLiked,
    bool? isFavorited,
    bool? isPicked,
    String? status,
    String? visibility,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? expiresAt,
    DateTime? pickedAt,
    UserModel? pickedBy,
    double? distance,
    Map<String, dynamic>? metadata,
  }) {
    return BottleModel(
      id: id ?? this.id,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      author: author ?? this.author,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationName: locationName ?? this.locationName,
      tags: tags ?? this.tags,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      picksCount: picksCount ?? this.picksCount,
      isLiked: isLiked ?? this.isLiked,
      isFavorited: isFavorited ?? this.isFavorited,
      isPicked: isPicked ?? this.isPicked,
      status: status ?? this.status,
      visibility: visibility ?? this.visibility,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      pickedAt: pickedAt ?? this.pickedAt,
      pickedBy: pickedBy ?? this.pickedBy,
      distance: distance ?? this.distance,
      metadata: metadata ?? this.metadata,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is BottleModel &&
        other.id == id &&
        other.content == content &&
        other.imageUrl == imageUrl &&
        other.author == author &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.locationName == locationName &&
        other.likesCount == likesCount &&
        other.commentsCount == commentsCount &&
        other.picksCount == picksCount &&
        other.isLiked == isLiked &&
        other.isFavorited == isFavorited &&
        other.isPicked == isPicked &&
        other.status == status &&
        other.visibility == visibility &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.expiresAt == expiresAt &&
        other.pickedAt == pickedAt &&
        other.pickedBy == pickedBy &&
        other.distance == distance;
  }
  
  @override
  int get hashCode {
    return id.hashCode ^
        content.hashCode ^
        imageUrl.hashCode ^
        author.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        locationName.hashCode ^
        likesCount.hashCode ^
        commentsCount.hashCode ^
        picksCount.hashCode ^
        isLiked.hashCode ^
        isFavorited.hashCode ^
        isPicked.hashCode ^
        status.hashCode ^
        visibility.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        expiresAt.hashCode ^
        pickedAt.hashCode ^
        pickedBy.hashCode ^
        distance.hashCode;
  }
  
  @override
  String toString() {
    return 'BottleModel(id: $id, content: $content, author: ${author.nickname}, likesCount: $likesCount, createdAt: $createdAt)';
  }
}

/// 漂流瓶列表模型
@JsonSerializable()
class BottleListModel {
  @JsonKey(name: 'bottles')
  final List<BottleModel> bottles;
  
  @JsonKey(name: 'total_count')
  final int totalCount;
  
  @JsonKey(name: 'has_more')
  final bool hasMore;
  
  @JsonKey(name: 'next_cursor')
  final String? nextCursor;
  
  @JsonKey(name: 'prev_cursor')
  final String? prevCursor;
  
  const BottleListModel({
    required this.bottles,
    required this.totalCount,
    required this.hasMore,
    this.nextCursor,
    this.prevCursor,
  });
  
  /// 从JSON创建模型
  factory BottleListModel.fromJson(Map<String, dynamic> json) => _$BottleListModelFromJson(json);
  
  /// 转换为JSON
  Map<String, dynamic> toJson() => _$BottleListModelToJson(this);
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is BottleListModel &&
        other.bottles == bottles &&
        other.totalCount == totalCount &&
        other.hasMore == hasMore &&
        other.nextCursor == nextCursor &&
        other.prevCursor == prevCursor;
  }
  
  @override
  int get hashCode {
    return bottles.hashCode ^
        totalCount.hashCode ^
        hasMore.hashCode ^
        nextCursor.hashCode ^
        prevCursor.hashCode;
  }
  
  @override
  String toString() {
    return 'BottleListModel(bottles: ${bottles.length}, totalCount: $totalCount, hasMore: $hasMore)';
  }
}

/// 漂流瓶统计模型
@JsonSerializable()
class BottleStatsModel {
  @JsonKey(name: 'total_sent')
  final int totalSent;
  
  @JsonKey(name: 'total_picked')
  final int totalPicked;
  
  @JsonKey(name: 'total_liked')
  final int totalLiked;
  
  @JsonKey(name: 'total_favorited')
  final int totalFavorited;
  
  @JsonKey(name: 'today_sent')
  final int todaySent;
  
  @JsonKey(name: 'today_picked')
  final int todayPicked;
  
  @JsonKey(name: 'this_week_sent')
  final int thisWeekSent;
  
  @JsonKey(name: 'this_week_picked')
  final int thisWeekPicked;
  
  @JsonKey(name: 'this_month_sent')
  final int thisMonthSent;
  
  @JsonKey(name: 'this_month_picked')
  final int thisMonthPicked;
  
  const BottleStatsModel({
    required this.totalSent,
    required this.totalPicked,
    required this.totalLiked,
    required this.totalFavorited,
    required this.todaySent,
    required this.todayPicked,
    required this.thisWeekSent,
    required this.thisWeekPicked,
    required this.thisMonthSent,
    required this.thisMonthPicked,
  });
  
  /// 从JSON创建模型
  factory BottleStatsModel.fromJson(Map<String, dynamic> json) => _$BottleStatsModelFromJson(json);
  
  /// 转换为JSON
  Map<String, dynamic> toJson() => _$BottleStatsModelToJson(this);
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is BottleStatsModel &&
        other.totalSent == totalSent &&
        other.totalPicked == totalPicked &&
        other.totalLiked == totalLiked &&
        other.totalFavorited == totalFavorited &&
        other.todaySent == todaySent &&
        other.todayPicked == todayPicked &&
        other.thisWeekSent == thisWeekSent &&
        other.thisWeekPicked == thisWeekPicked &&
        other.thisMonthSent == thisMonthSent &&
        other.thisMonthPicked == thisMonthPicked;
  }
  
  @override
  int get hashCode {
    return totalSent.hashCode ^
        totalPicked.hashCode ^
        totalLiked.hashCode ^
        totalFavorited.hashCode ^
        todaySent.hashCode ^
        todayPicked.hashCode ^
        thisWeekSent.hashCode ^
        thisWeekPicked.hashCode ^
        thisMonthSent.hashCode ^
        thisMonthPicked.hashCode;
  }
  
  @override
  String toString() {
    return 'BottleStatsModel(totalSent: $totalSent, totalPicked: $totalPicked, totalLiked: $totalLiked)';
  }
}