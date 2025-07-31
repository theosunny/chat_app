import 'package:dartz/dartz.dart';
import '../entities/bottle.dart';
import '../entities/user.dart';
import '../../core/errors/failures.dart';

/// 漂流瓶仓库接口
abstract class BottleRepository {
  /// 发送漂流瓶
  Future<Either<Failure, Bottle>> sendBottle({
    required String content,
    required BottleContentType contentType,
    List<String>? mediaFiles,
    List<String>? tags,
    BottleType? type,
    BottlePriority? priority,
    int? validHours,
    double? maxDriftDistance,
    bool? isAnonymous,
    bool? isPrivate,
    BottleLocation? location,
  });
  
  /// 获取附近的漂流瓶
  Future<Either<Failure, List<Bottle>>> getNearbyBottles({
    required double latitude,
    required double longitude,
    double? radius,
    int? limit,
    int? offset,
    List<BottleType>? types,
    List<String>? tags,
    BottleContentType? contentType,
    String? sortBy, // 'distance', 'time', 'popularity'
  });
  
  /// 捡漂流瓶
  Future<Either<Failure, Bottle>> pickBottle({
    required String bottleId,
    required double latitude,
    required double longitude,
  });
  
  /// 获取漂流瓶详情
  Future<Either<Failure, Bottle>> getBottleDetail(String bottleId);
  
  /// 回复漂流瓶
  Future<Either<Failure, void>> replyToBottle({
    required String bottleId,
    required String content,
    BottleContentType? contentType,
    List<String>? mediaFiles,
  });
  
  /// 点赞漂流瓶
  Future<Either<Failure, void>> likeBottle(String bottleId);
  
  /// 取消点赞漂流瓶
  Future<Either<Failure, void>> unlikeBottle(String bottleId);
  
  /// 收藏漂流瓶
  Future<Either<Failure, void>> favoriteBottle(String bottleId);
  
  /// 取消收藏漂流瓶
  Future<Either<Failure, void>> unfavoriteBottle(String bottleId);
  
  /// 举报漂流瓶
  Future<Either<Failure, void>> reportBottle({
    required String bottleId,
    required String reason,
    String? description,
  });
  
  /// 删除漂流瓶
  Future<Either<Failure, void>> deleteBottle(String bottleId);
  
  /// 获取我发送的漂流瓶
  Future<Either<Failure, List<Bottle>>> getMySentBottles({
    int? limit,
    int? offset,
    BottleStatus? status,
    String? sortBy,
  });
  
  /// 获取我捡到的漂流瓶
  Future<Either<Failure, List<Bottle>>> getMyPickedBottles({
    int? limit,
    int? offset,
    String? sortBy,
  });
  
  /// 获取我收藏的漂流瓶
  Future<Either<Failure, List<Bottle>>> getMyFavoriteBottles({
    int? limit,
    int? offset,
    String? sortBy,
  });
  
  /// 获取漂流瓶回复列表
  Future<Either<Failure, List<BottleReply>>> getBottleReplies({
    required String bottleId,
    int? limit,
    int? offset,
    String? sortBy,
  });
  
  /// 获取漂流瓶统计信息
  Future<Either<Failure, BottleStats>> getBottleStats(String bottleId);
  
  /// 获取用户漂流瓶统计
  Future<Either<Failure, UserBottleStats>> getUserBottleStats(String userId);
  
  /// 搜索漂流瓶
  Future<Either<Failure, List<Bottle>>> searchBottles({
    required String keyword,
    List<BottleType>? types,
    List<String>? tags,
    BottleContentType? contentType,
    double? latitude,
    double? longitude,
    double? radius,
    int? limit,
    int? offset,
    String? sortBy,
  });
  
  /// 获取热门漂流瓶
  Future<Either<Failure, List<Bottle>>> getTrendingBottles({
    int? limit,
    int? offset,
    String? timeRange, // 'day', 'week', 'month'
  });
  
  /// 获取推荐漂流瓶
  Future<Either<Failure, List<Bottle>>> getRecommendedBottles({
    int? limit,
    int? offset,
    double? latitude,
    double? longitude,
  });
  
  /// 获取漂流瓶标签
  Future<Either<Failure, List<String>>> getBottleTags({
    String? category,
    int? limit,
  });
  
  /// 获取热门标签
  Future<Either<Failure, List<String>>> getTrendingTags({
    int? limit,
    String? timeRange,
  });
  
  /// 上传媒体文件
  Future<Either<Failure, String>> uploadMedia({
    required String filePath,
    required MediaType mediaType,
  });
  
  /// 获取媒体文件信息
  Future<Either<Failure, BottleMedia>> getMediaInfo(String mediaId);
  
  /// 删除媒体文件
  Future<Either<Failure, void>> deleteMedia(String mediaId);
  
  /// 获取漂流瓶轨迹
  Future<Either<Failure, List<BottleTrack>>> getBottleTrack(String bottleId);
  
  /// 更新漂流瓶位置
  Future<Either<Failure, void>> updateBottleLocation({
    required String bottleId,
    required double latitude,
    required double longitude,
  });
  
  /// 检查漂流瓶是否可以被当前用户捡到
  Future<Either<Failure, bool>> canPickBottle({
    required String bottleId,
    required double latitude,
    required double longitude,
  });
  
  /// 获取用户今日发送/捡取限制
  Future<Either<Failure, DailyLimits>> getDailyLimits();
  
  /// 监听附近漂流瓶变化
  Stream<List<Bottle>> watchNearbyBottles({
    required double latitude,
    required double longitude,
    double? radius,
  });
  
  /// 监听漂流瓶状态变化
  Stream<Bottle> watchBottle(String bottleId);
  
  /// 获取漂流瓶列表
  Future<Either<Failure, List<Bottle>>> getBottles({
    int? limit,
    String? beforeBottleId,
    String? afterBottleId,
    String? type,
    double? latitude,
    double? longitude,
    int? radius,
    List<String>? tags,
  });
}



/// 漂流瓶统计信息
class BottleStats {
  final String bottleId;
  final int viewCount;
  final int likeCount;
  final int favoriteCount;
  final int replyCount;
  final int shareCount;
  final double driftedDistance;
  final List<String> viewerIds;
  final List<String> likerIds;
  final List<String> favoriterIds;
  
  const BottleStats({
    required this.bottleId,
    required this.viewCount,
    required this.likeCount,
    required this.favoriteCount,
    required this.replyCount,
    required this.shareCount,
    required this.driftedDistance,
    required this.viewerIds,
    required this.likerIds,
    required this.favoriterIds,
  });
}

/// 用户漂流瓶统计
class UserBottleStats {
  final String userId;
  final int totalSentCount;
  final int totalPickedCount;
  final int totalLikeCount;
  final int totalFavoriteCount;
  final int totalReplyCount;
  final double totalDriftDistance;
  final int todaySentCount;
  final int todayPickedCount;
  final DateTime lastSentAt;
  final DateTime lastPickedAt;
  
  const UserBottleStats({
    required this.userId,
    required this.totalSentCount,
    required this.totalPickedCount,
    required this.totalLikeCount,
    required this.totalFavoriteCount,
    required this.totalReplyCount,
    required this.totalDriftDistance,
    required this.todaySentCount,
    required this.todayPickedCount,
    required this.lastSentAt,
    required this.lastPickedAt,
  });
}

/// 每日限制
class DailyLimits {
  final int maxSendCount;
  final int maxPickCount;
  final int currentSendCount;
  final int currentPickCount;
  final int remainingSendCount;
  final int remainingPickCount;
  final DateTime resetTime;
  
  const DailyLimits({
    required this.maxSendCount,
    required this.maxPickCount,
    required this.currentSendCount,
    required this.currentPickCount,
    required this.remainingSendCount,
    required this.remainingPickCount,
    required this.resetTime,
  });
}