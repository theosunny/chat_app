import 'dart:math';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'user.dart';

part 'bottle.freezed.dart';

/// 漂流瓶实体
@freezed
class Bottle with _$Bottle {
  const factory Bottle({
    /// 漂流瓶ID
    required String id,
    
    /// 发送者信息
    required User sender,
    
    /// 内容
    required String content,
    
    /// 内容类型
    @Default(BottleContentType.text) BottleContentType contentType,
    
    /// 媒体文件列表 (图片、音频等)
    @Default([]) List<BottleMedia> mediaList,
    
    /// 标签列表
    @Default([]) List<String> tags,
    
    /// 发送位置
    BottleLocation? sendLocation,
    
    /// 当前位置 (漂流过程中的位置)
    BottleLocation? currentLocation,
    
    /// 漂流瓶状态
    @Default(BottleStatus.floating) BottleStatus status,
    
    /// 漂流瓶类型
    @Default(BottleType.normal) BottleType type,
    
    /// 优先级 (影响被捡到的概率)
    @Default(BottlePriority.normal) BottlePriority priority,
    
    /// 有效期 (小时)
    @Default(72) int validHours,
    
    /// 最大漂流距离 (公里)
    @Default(100.0) double maxDriftDistance,
    
    /// 已漂流距离 (公里)
    @Default(0.0) double driftedDistance,
    
    /// 被查看次数
    @Default(0) int viewCount,
    
    /// 被点赞次数
    @Default(0) int likeCount,
    
    /// 被收藏次数
    @Default(0) int favoriteCount,
    
    /// 回复数量
    @Default(0) int replyCount,
    
    /// 是否匿名
    @Default(false) bool isAnonymous,
    
    /// 是否私密 (只有特定用户可见)
    @Default(false) bool isPrivate,
    
    /// 是否置顶
    @Default(false) bool isPinned,
    
    /// 是否被举报
    @Default(false) bool isReported,
    
    /// 是否被删除
    @Default(false) bool isDeleted,
    
    /// 创建时间
    required DateTime createdAt,
    
    /// 更新时间
    required DateTime updatedAt,
    
    /// 过期时间
    DateTime? expiredAt,
    
    /// 被捡到时间
    DateTime? pickedAt,
    
    /// 捡到者信息
    User? picker,
    
    /// 漂流轨迹
    @Default([]) List<BottleTrack> driftTrack,
    
    /// 扩展数据
    Map<String, dynamic>? extra,
  }) = _Bottle;
  
  const Bottle._();
  
  /// 是否已过期
  bool get isExpired {
    if (expiredAt == null) return false;
    return DateTime.now().isAfter(expiredAt!);
  }
  
  /// 是否可以被捡到
  bool get canBePicked {
    return status == BottleStatus.floating && 
           !isExpired && 
           !isDeleted && 
           !isReported;
  }
  
  /// 是否可以回复
  bool get canReply {
    return status == BottleStatus.picked && 
           !isDeleted && 
           !isReported;
  }
  
  /// 剩余有效时间 (小时)
  double get remainingHours {
    if (expiredAt == null) return 0;
    final remaining = expiredAt!.difference(DateTime.now()).inMinutes;
    return remaining > 0 ? remaining / 60.0 : 0;
  }
  
  /// 漂流进度 (0.0 - 1.0)
  double get driftProgress {
    if (maxDriftDistance <= 0) return 0;
    return (driftedDistance / maxDriftDistance).clamp(0.0, 1.0);
  }
  
  /// 获取显示的发送者名称
  String get senderDisplayName {
    if (isAnonymous) return '匿名用户';
    return sender.displayName;
  }
  
  /// 获取显示的发送者头像
  String? get senderDisplayAvatar {
    if (isAnonymous) return null;
    return sender.avatar;
  }
  
  /// 获取内容预览 (限制长度)
  String getContentPreview([int maxLength = 100]) {
    if (content.length <= maxLength) return content;
    return '${content.substring(0, maxLength)}...';
  }
  
  /// 获取距离显示文本
  String getDistanceText(double userLatitude, double userLongitude) {
    if (currentLocation == null) return '未知位置';
    
    final distance = _calculateDistance(
      userLatitude, 
      userLongitude, 
      currentLocation!.latitude, 
      currentLocation!.longitude,
    );
    
    if (distance < 1) {
      return '${(distance * 1000).toInt()}m';
    } else if (distance < 10) {
      return '${distance.toStringAsFixed(1)}km';
    } else {
      return '${distance.toInt()}km';
    }
  }
  
  /// 计算两点间距离 (公里)
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // 地球半径 (公里)
    final double dLat = _toRadians(lat2 - lat1);
    final double dLon = _toRadians(lon2 - lon1);
    final double a = 
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
        sin(dLon / 2) * sin(dLon / 2);
    final double c = 2 * asin(sqrt(a));
    return earthRadius * c;
  }
  
  double _toRadians(double degree) {
    return degree * (3.141592653589793 / 180);
  }
}

/// 漂流瓶媒体文件
@freezed
class BottleMedia with _$BottleMedia {
  const factory BottleMedia({
    /// 媒体ID
    required String id,
    
    /// 媒体类型
    required MediaType type,
    
    /// 文件URL
    required String url,
    
    /// 缩略图URL
    String? thumbnailUrl,
    
    /// 文件大小 (字节)
    int? fileSize,
    
    /// 持续时间 (秒，用于音频/视频)
    int? duration,
    
    /// 宽度 (像素，用于图片/视频)
    int? width,
    
    /// 高度 (像素，用于图片/视频)
    int? height,
    
    /// 文件名
    String? fileName,
    
    /// MIME类型
    String? mimeType,
    
    /// 创建时间
    required DateTime createdAt,
  }) = _BottleMedia;
}

/// 漂流瓶位置信息
@freezed
class BottleLocation with _$BottleLocation {
  const factory BottleLocation({
    /// 纬度
    required double latitude,
    
    /// 经度
    required double longitude,
    
    /// 地址描述
    String? address,
    
    /// 城市
    String? city,
    
    /// 省份/州
    String? province,
    
    /// 国家
    String? country,
    
    /// 位置精度 (米)
    double? accuracy,
    
    /// 记录时间
    required DateTime timestamp,
  }) = _BottleLocation;
}

/// 漂流轨迹
@freezed
class BottleTrack with _$BottleTrack {
  const factory BottleTrack({
    /// 轨迹ID
    required String id,
    
    /// 位置信息
    required BottleLocation location,
    
    /// 轨迹类型
    required TrackType type,
    
    /// 描述
    String? description,
    
    /// 记录时间
    required DateTime timestamp,
  }) = _BottleTrack;
}

/// 内容类型枚举
enum BottleContentType {
  /// 纯文本
  text,
  
  /// 图片
  image,
  
  /// 音频
  audio,
  
  /// 视频
  video,
  
  /// 混合内容
  mixed,
}

/// 漂流瓶状态枚举
enum BottleStatus {
  /// 草稿
  draft,
  
  /// 漂流中
  floating,
  
  /// 已被捡到
  picked,
  
  /// 已过期
  expired,
  
  /// 已删除
  deleted,
  
  /// 被举报
  reported,
}

/// 漂流瓶类型枚举
enum BottleType {
  /// 普通漂流瓶
  normal,
  
  /// 心情漂流瓶
  mood,
  
  /// 求助漂流瓶
  help,
  
  /// 表白漂流瓶
  confession,
  
  /// 祝福漂流瓶
  blessing,
  
  /// 秘密漂流瓶
  secret,
  
  /// 交友漂流瓶
  friendship,
  
  /// 其他
  other,
}

/// 漂流瓶优先级枚举
enum BottlePriority {
  /// 低优先级
  low,
  
  /// 普通优先级
  normal,
  
  /// 高优先级
  high,
  
  /// 紧急优先级
  urgent,
}

/// 媒体类型枚举
enum MediaType {
  /// 图片
  image,
  
  /// 音频
  audio,
  
  /// 视频
  video,
  
  /// 文档
  document,
}

/// 轨迹类型枚举
enum TrackType {
  /// 发送
  sent,
  
  /// 漂流
  drift,
  
  /// 被捡到
  picked,
  
  /// 过期
  expired,
}

/// 内容类型扩展
extension BottleContentTypeExtension on BottleContentType {
  String get displayText {
    switch (this) {
      case BottleContentType.text:
        return '文字';
      case BottleContentType.image:
        return '图片';
      case BottleContentType.audio:
        return '语音';
      case BottleContentType.video:
        return '视频';
      case BottleContentType.mixed:
        return '混合';
    }
  }
}

/// 漂流瓶回复
@freezed
class BottleReply with _$BottleReply {
  const factory BottleReply({
    /// 回复ID
    required String id,
    
    /// 漂流瓶ID
    required String bottleId,
    
    /// 发送者信息
    required User sender,
    
    /// 回复内容
    required String content,
    
    /// 内容类型
    @Default(BottleContentType.text) BottleContentType contentType,
    
    /// 媒体文件列表
    @Default([]) List<BottleMedia> mediaList,
    
    /// 创建时间
    required DateTime createdAt,
    
    /// 是否已删除
    @Default(false) bool isDeleted,
  }) = _BottleReply;
}

/// 漂流瓶状态扩展
extension BottleStatusExtension on BottleStatus {
  String get displayText {
    switch (this) {
      case BottleStatus.draft:
        return '草稿';
      case BottleStatus.floating:
        return '漂流中';
      case BottleStatus.picked:
        return '已被捡到';
      case BottleStatus.expired:
        return '已过期';
      case BottleStatus.deleted:
        return '已删除';
      case BottleStatus.reported:
        return '被举报';
    }
  }
  
  String get colorHex {
    switch (this) {
      case BottleStatus.draft:
        return '#9E9E9E';
      case BottleStatus.floating:
        return '#2196F3';
      case BottleStatus.picked:
        return '#4CAF50';
      case BottleStatus.expired:
        return '#FF9800';
      case BottleStatus.deleted:
        return '#F44336';
      case BottleStatus.reported:
        return '#E91E63';
    }
  }
}

/// 漂流瓶类型扩展
extension BottleTypeExtension on BottleType {
  String get displayText {
    switch (this) {
      case BottleType.normal:
        return '普通';
      case BottleType.mood:
        return '心情';
      case BottleType.help:
        return '求助';
      case BottleType.confession:
        return '表白';
      case BottleType.blessing:
        return '祝福';
      case BottleType.secret:
        return '秘密';
      case BottleType.friendship:
        return '交友';
      case BottleType.other:
        return '其他';
    }
  }
  
  String get emoji {
    switch (this) {
      case BottleType.normal:
        return '💬';
      case BottleType.mood:
        return '😊';
      case BottleType.help:
        return '🆘';
      case BottleType.confession:
        return '💕';
      case BottleType.blessing:
        return '🙏';
      case BottleType.secret:
        return '🤫';
      case BottleType.friendship:
        return '👫';
      case BottleType.other:
        return '📝';
    }
  }
}

/// 优先级扩展
extension BottlePriorityExtension on BottlePriority {
  String get displayText {
    switch (this) {
      case BottlePriority.low:
        return '低';
      case BottlePriority.normal:
        return '普通';
      case BottlePriority.high:
        return '高';
      case BottlePriority.urgent:
        return '紧急';
    }
  }
  
  int get weight {
    switch (this) {
      case BottlePriority.low:
        return 1;
      case BottlePriority.normal:
        return 2;
      case BottlePriority.high:
        return 3;
      case BottlePriority.urgent:
        return 5;
    }
  }
}