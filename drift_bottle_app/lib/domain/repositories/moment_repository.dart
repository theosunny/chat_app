import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/moment.dart';

/// 动态仓库接口
abstract class MomentRepository {
  /// 发布动态
  Future<Either<Failure, Moment>> publishMoment({
    required String content,
    List<String>? imagePaths,
    String? videoPath,
    String? location,
    double? latitude,
    double? longitude,
    String visibility = 'public',
    List<String>? tags,
  });
  
  /// 获取动态列表
  Future<Either<Failure, List<Moment>>> getMoments({
    int page = 1,
    int limit = 20,
    String? userId,
    String? visibility,
    List<String>? tags,
  });
  
  /// 获取动态详情
  Future<Either<Failure, Moment>> getMomentById(String momentId);
  
  /// 获取动态详情（别名方法）
  Future<Either<Failure, Moment>> getMomentDetail(String momentId);
  
  /// 评论动态
  Future<Either<Failure, void>> commentMoment({
    required String momentId,
    required String content,
    String? replyToId,
  });
  
  /// 获取我的动态
  Future<Either<Failure, List<Moment>>> getMyMoments({
    int page = 1,
    int limit = 20,
  });
  
  /// 获取关注用户的动态
  Future<Either<Failure, List<Moment>>> getFollowingMoments({
    int page = 1,
    int limit = 20,
  });
  
  /// 获取附近的动态
  Future<Either<Failure, List<Moment>>> getNearbyMoments({
    required double latitude,
    required double longitude,
    double radius = 5.0,
    int page = 1,
    int limit = 20,
  });
  
  /// 搜索动态
  Future<Either<Failure, List<Moment>>> searchMoments({
    required String query,
    int page = 1,
    int limit = 20,
    List<String>? tags,
  });
  
  /// 点赞动态
  Future<Either<Failure, void>> likeMoment(String momentId);
  
  /// 取消点赞
  Future<Either<Failure, void>> unlikeMoment(String momentId);
  
  /// 收藏动态
  Future<Either<Failure, void>> bookmarkMoment(String momentId);
  
  /// 取消收藏
  Future<Either<Failure, void>> unbookmarkMoment(String momentId);
  
  /// 获取收藏的动态
  Future<Either<Failure, List<Moment>>> getBookmarkedMoments({
    int page = 1,
    int limit = 20,
  });
  
  /// 分享动态
  Future<Either<Failure, void>> shareMoment(String momentId);
  
  /// 删除动态
  Future<Either<Failure, void>> deleteMoment(String momentId);
  
  /// 举报动态
  Future<Either<Failure, void>> reportMoment({
    required String momentId,
    required String reason,
    String? description,
  });
  
  /// 更新动态
  Future<Either<Failure, Moment>> updateMoment({
    required String momentId,
    String? content,
    String? visibility,
    List<String>? tags,
  });
  
  /// 获取动态统计信息
  Future<Either<Failure, Map<String, dynamic>>> getMomentStats(String momentId);
  
  /// 获取热门动态
  Future<Either<Failure, List<Moment>>> getTrendingMoments({
    int page = 1,
    int limit = 20,
    String period = 'day', // 'hour', 'day', 'week', 'month'
  });
  
  /// 获取推荐动态
  Future<Either<Failure, List<Moment>>> getRecommendedMoments({
    int page = 1,
    int limit = 20,
  });
}