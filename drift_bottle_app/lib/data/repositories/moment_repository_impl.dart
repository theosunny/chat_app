import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/moment.dart';
import '../../domain/repositories/moment_repository.dart';
import '../datasources/moment_remote_datasource.dart';
import '../models/moment_model.dart';

/// 动态仓库实现
@LazySingleton(as: MomentRepository)
class MomentRepositoryImpl implements MomentRepository {
  final MomentRemoteDataSource _remoteDataSource;
  
  MomentRepositoryImpl(this._remoteDataSource);
  
  @override
  Future<Either<Failure, Moment>> publishMoment({
    required String content,
    List<String>? imagePaths,
    String? videoPath,
    String? location,
    double? latitude,
    double? longitude,
    String visibility = 'public',
    List<String>? tags,
  }) async {
    try {
      final momentModel = await _remoteDataSource.publishMoment(
        content: content,
        imagePaths: imagePaths,
        videoPath: videoPath,
        location: location,
        latitude: latitude,
        longitude: longitude,
        visibility: visibility,
        tags: tags,
      );
      return Right(momentModel.toEntity());
    } catch (e) {
      return Left(Failure.server(message: '发布动态失败: $e'));
    }
  }
  
  @override
  Future<Result<List<Moment>>> getMoments({
    int page = 1,
    int limit = 20,
    String? userId,
    String? visibility,
    List<String>? tags,
  }) async {
    try {
      final momentListModel = await _remoteDataSource.getMoments(
        page: page,
        limit: limit,
        userId: userId,
        visibility: visibility,
        tags: tags,
      );
      final moments = momentListModel.moments.map((model) => model.toEntity()).toList();
      return Result.success(moments);
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message));
    } catch (e) {
      return Result.failure(UnknownFailure('获取动态列表失败: $e'));
    }
  }
  
  @override
  Future<Result<Moment>> getMomentById(String momentId) async {
    try {
      final momentModel = await _remoteDataSource.getMomentById(momentId);
      return Result.success(momentModel.toEntity());
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message));
    } catch (e) {
      return Result.failure(UnknownFailure('获取动态详情失败: $e'));
    }
  }
  
  @override
  Future<Result<List<Moment>>> getMyMoments({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final momentListModel = await _remoteDataSource.getMyMoments(
        page: page,
        limit: limit,
      );
      final moments = momentListModel.moments.map((model) => model.toEntity()).toList();
      return Result.success(moments);
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message));
    } catch (e) {
      return Result.failure(UnknownFailure('获取我的动态失败: $e'));
    }
  }
  
  @override
  Future<Result<List<Moment>>> getFollowingMoments({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final momentListModel = await _remoteDataSource.getFollowingMoments(
        page: page,
        limit: limit,
      );
      final moments = momentListModel.moments.map((model) => model.toEntity()).toList();
      return Result.success(moments);
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message));
    } catch (e) {
      return Result.failure(UnknownFailure('获取关注动态失败: $e'));
    }
  }
  
  @override
  Future<Result<List<Moment>>> getNearbyMoments({
    required double latitude,
    required double longitude,
    double radius = 5.0,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final momentListModel = await _remoteDataSource.getNearbyMoments(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        page: page,
        limit: limit,
      );
      final moments = momentListModel.moments.map((model) => model.toEntity()).toList();
      return Result.success(moments);
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message));
    } catch (e) {
      return Result.failure(UnknownFailure('获取附近动态失败: $e'));
    }
  }
  
  @override
  Future<Result<List<Moment>>> searchMoments({
    required String query,
    int page = 1,
    int limit = 20,
    List<String>? tags,
  }) async {
    try {
      final momentListModel = await _remoteDataSource.searchMoments(
        query: query,
        page: page,
        limit: limit,
        tags: tags,
      );
      final moments = momentListModel.moments.map((model) => model.toEntity()).toList();
      return Result.success(moments);
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message));
    } catch (e) {
      return Result.failure(UnknownFailure('搜索动态失败: $e'));
    }
  }
  
  @override
  Future<Result<void>> likeMoment(String momentId) async {
    try {
      await _remoteDataSource.likeMoment(momentId);
      return Result.success(null);
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message));
    } catch (e) {
      return Result.failure(UnknownFailure('点赞失败: $e'));
    }
  }
  
  @override
  Future<Result<void>> unlikeMoment(String momentId) async {
    try {
      await _remoteDataSource.unlikeMoment(momentId);
      return Result.success(null);
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message));
    } catch (e) {
      return Result.failure(UnknownFailure('取消点赞失败: $e'));
    }
  }
  
  @override
  Future<Result<void>> bookmarkMoment(String momentId) async {
    try {
      await _remoteDataSource.bookmarkMoment(momentId);
      return Result.success(null);
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message));
    } catch (e) {
      return Result.failure(UnknownFailure('收藏失败: $e'));
    }
  }
  
  @override
  Future<Result<void>> unbookmarkMoment(String momentId) async {
    try {
      await _remoteDataSource.unbookmarkMoment(momentId);
      return Result.success(null);
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message));
    } catch (e) {
      return Result.failure(UnknownFailure('取消收藏失败: $e'));
    }
  }
  
  @override
  Future<Result<List<Moment>>> getBookmarkedMoments({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final momentListModel = await _remoteDataSource.getBookmarkedMoments(
        page: page,
        limit: limit,
      );
      final moments = momentListModel.moments.map((model) => model.toEntity()).toList();
      return Result.success(moments);
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message));
    } catch (e) {
      return Result.failure(UnknownFailure('获取收藏动态失败: $e'));
    }
  }
  
  @override
  Future<Result<void>> shareMoment(String momentId) async {
    try {
      await _remoteDataSource.shareMoment(momentId);
      return Result.success(null);
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message));
    } catch (e) {
      return Result.failure(UnknownFailure('分享失败: $e'));
    }
  }
  
  @override
  Future<Result<void>> deleteMoment(String momentId) async {
    try {
      await _remoteDataSource.deleteMoment(momentId);
      return Result.success(null);
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message));
    } catch (e) {
      return Result.failure(UnknownFailure('删除动态失败: $e'));
    }
  }
  
  @override
  Future<Result<void>> reportMoment({
    required String momentId,
    required String reason,
    String? description,
  }) async {
    try {
      await _remoteDataSource.reportMoment(
        momentId: momentId,
        reason: reason,
        description: description,
      );
      return Result.success(null);
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message));
    } catch (e) {
      return Result.failure(UnknownFailure('举报失败: $e'));
    }
  }
  
  @override
  Future<Result<Moment>> updateMoment({
    required String momentId,
    String? content,
    String? visibility,
    List<String>? tags,
  }) async {
    try {
      final momentModel = await _remoteDataSource.updateMoment(
        momentId: momentId,
        content: content,
        visibility: visibility,
        tags: tags,
      );
      return Result.success(momentModel.toEntity());
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message));
    } catch (e) {
      return Result.failure(UnknownFailure('更新动态失败: $e'));
    }
  }
  
  @override
  Future<Result<Map<String, dynamic>>> getMomentStats(String momentId) async {
    try {
      final statsModel = await _remoteDataSource.getMomentStats(momentId);
      return Result.success(statsModel.toJson());
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message));
    } catch (e) {
      return Result.failure(UnknownFailure('获取动态统计失败: $e'));
    }
  }
  
  @override
  Future<Result<List<Moment>>> getTrendingMoments({
    int page = 1,
    int limit = 20,
    String period = 'day',
  }) async {
    try {
      final momentListModel = await _remoteDataSource.getTrendingMoments(
        page: page,
        limit: limit,
        period: period,
      );
      final moments = momentListModel.moments.map((model) => model.toEntity()).toList();
      return Result.success(moments);
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message));
    } catch (e) {
      return Result.failure(UnknownFailure('获取热门动态失败: $e'));
    }
  }
  
  @override
  Future<Result<List<Moment>>> getRecommendedMoments({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final momentListModel = await _remoteDataSource.getRecommendedMoments(
        page: page,
        limit: limit,
      );
      final moments = momentListModel.moments.map((model) => model.toEntity()).toList();
      return Right(moments);
    } catch (e) {
      return Left(Failure.server(message: '获取推荐动态失败: $e'));
    }
  }
  
  @override
  Future<Either<Failure, Moment>> getMomentDetail(String momentId) async {
    try {
      final momentModel = await _remoteDataSource.getMomentById(momentId);
      return Right(momentModel.toEntity());
    } catch (e) {
      return Left(Failure.server(message: '获取动态详情失败: $e'));
    }
  }
  
  @override
  Future<Either<Failure, void>> commentMoment({
    required String momentId,
    required String content,
    String? replyToId,
  }) async {
    try {
      await _remoteDataSource.commentMoment(
        momentId: momentId,
        content: content,
        replyToId: replyToId,
      );
      return const Right(null);
    } catch (e) {
      return Left(Failure.server(message: '评论动态失败: $e'));
    }
  }
}