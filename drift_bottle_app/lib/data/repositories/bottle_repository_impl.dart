import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/bottle.dart';
import '../../domain/repositories/bottle_repository.dart';
import '../datasources/bottle_remote_datasource.dart';
import '../models/bottle_model.dart';

/// 漂流瓶仓库实现
@LazySingleton(as: BottleRepository)
class BottleRepositoryImpl implements BottleRepository {
  final BottleRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;
  
  const BottleRepositoryImpl(
    this._remoteDataSource,
    this._networkInfo,
  );
  
  @override
  Future<Either<Failure, Bottle>> sendBottle({
    required String content,
    String? imageUrl,
    double? latitude,
    double? longitude,
    String? locationName,
    List<String>? tags,
  }) async {
    try {
      // 检查网络连接
      if (!await _networkInfo.isConnected) {
        return const Left(Failure.network(
          message: '网络连接不可用，请检查网络设置',
        ));
      }
      
      // 验证参数
      if (content.trim().isEmpty) {
        return const Left(Failure.validation(
          message: '漂流瓶内容不能为空',
        ));
      }
      
      if (content.length > 500) {
        return const Left(Failure.validation(
          message: '漂流瓶内容不能超过500个字符',
        ));
      }
      
      final bottleModel = await _remoteDataSource.sendBottle(
        content: content,
        imageUrl: imageUrl,
        latitude: latitude,
        longitude: longitude,
        locationName: locationName,
        tags: tags,
      );
      
      return Right(bottleModel.toEntity());
    } catch (e) {
      return Left(_handleException(e));
    }
  }
  
  @override
  Future<Either<Failure, Bottle?>> pickBottle({
    double? latitude,
    double? longitude,
    int? radius,
  }) async {
    try {
      // 检查网络连接
      if (!await _networkInfo.isConnected) {
        return const Left(Failure.network(
          message: '网络连接不可用，请检查网络设置',
        ));
      }
      
      // 验证参数
      if (radius != null && radius <= 0) {
        return const Left(Failure.validation(
          message: '搜索半径必须大于0',
        ));
      }
      
      final bottleModel = await _remoteDataSource.pickBottle(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
      );
      
      return Right(bottleModel?.toEntity());
    } catch (e) {
      return Left(_handleException(e));
    }
  }
  
  @override
  Future<Either<Failure, List<Bottle>>> getBottles({
    int? limit,
    String? beforeBottleId,
    String? afterBottleId,
    String? type,
    double? latitude,
    double? longitude,
    int? radius,
    List<String>? tags,
  }) async {
    try {
      // 检查网络连接
      if (!await _networkInfo.isConnected) {
        return const Left(Failure.network(
          message: '网络连接不可用，请检查网络设置',
        ));
      }
      
      // 验证参数
      if (limit != null && limit <= 0) {
        return const Left(Failure.validation(
          message: '限制数量必须大于0',
        ));
      }
      
      if (radius != null && radius <= 0) {
        return const Left(Failure.validation(
          message: '搜索半径必须大于0',
        ));
      }
      
      final bottleListModel = await _remoteDataSource.getBottles(
        limit: limit,
        beforeBottleId: beforeBottleId,
        afterBottleId: afterBottleId,
        type: type,
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        tags: tags,
      );
      
      final bottles = bottleListModel.bottles
          .map((model) => model.toEntity())
          .toList();
      
      return Right(bottles);
    } catch (e) {
      return Left(_handleException(e));
    }
  }
  
  @override
  Future<Either<Failure, Bottle>> getBottleById(String bottleId) async {
    try {
      // 检查网络连接
      if (!await _networkInfo.isConnected) {
        return const Left(Failure.network(
          message: '网络连接不可用，请检查网络设置',
        ));
      }
      
      // 验证参数
      if (bottleId.trim().isEmpty) {
        return const Left(Failure.validation(
          message: '漂流瓶ID不能为空',
        ));
      }
      
      final bottleModel = await _remoteDataSource.getBottleById(bottleId);
      
      return Right(bottleModel.toEntity());
    } catch (e) {
      return Left(_handleException(e));
    }
  }
  
  @override
  Future<Either<Failure, void>> deleteBottle(String bottleId) async {
    try {
      // 检查网络连接
      if (!await _networkInfo.isConnected) {
        return const Left(Failure.network(
          message: '网络连接不可用，请检查网络设置',
        ));
      }
      
      // 验证参数
      if (bottleId.trim().isEmpty) {
        return const Left(Failure.validation(
          message: '漂流瓶ID不能为空',
        ));
      }
      
      await _remoteDataSource.deleteBottle(bottleId);
      
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }
  
  @override
  Future<Either<Failure, void>> reportBottle({
    required String bottleId,
    required String reason,
    String? description,
  }) async {
    try {
      // 检查网络连接
      if (!await _networkInfo.isConnected) {
        return const Left(Failure.network(
          message: '网络连接不可用，请检查网络设置',
        ));
      }
      
      // 验证参数
      if (bottleId.trim().isEmpty) {
        return const Left(Failure.validation(
          message: '漂流瓶ID不能为空',
        ));
      }
      
      if (reason.trim().isEmpty) {
        return const Left(Failure.validation(
          message: '举报原因不能为空',
        ));
      }
      
      await _remoteDataSource.reportBottle(
        bottleId: bottleId,
        reason: reason,
        description: description,
      );
      
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }
  
  @override
  Future<Either<Failure, void>> likeBottle(String bottleId) async {
    try {
      // 检查网络连接
      if (!await _networkInfo.isConnected) {
        return const Left(Failure.network(
          message: '网络连接不可用，请检查网络设置',
        ));
      }
      
      // 验证参数
      if (bottleId.trim().isEmpty) {
        return const Left(Failure.validation(
          message: '漂流瓶ID不能为空',
        ));
      }
      
      await _remoteDataSource.likeBottle(bottleId);
      
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }
  
  @override
  Future<Either<Failure, void>> unlikeBottle(String bottleId) async {
    try {
      // 检查网络连接
      if (!await _networkInfo.isConnected) {
        return const Left(Failure.network(
          message: '网络连接不可用，请检查网络设置',
        ));
      }
      
      // 验证参数
      if (bottleId.trim().isEmpty) {
        return const Left(Failure.validation(
          message: '漂流瓶ID不能为空',
        ));
      }
      
      await _remoteDataSource.unlikeBottle(bottleId);
      
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }
  
  @override
  Future<Either<Failure, void>> favoriteBottle(String bottleId) async {
    try {
      // 检查网络连接
      if (!await _networkInfo.isConnected) {
        return const Left(Failure.network(
          message: '网络连接不可用，请检查网络设置',
        ));
      }
      
      // 验证参数
      if (bottleId.trim().isEmpty) {
        return const Left(Failure.validation(
          message: '漂流瓶ID不能为空',
        ));
      }
      
      await _remoteDataSource.favoriteBottle(bottleId);
      
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }
  
  @override
  Future<Either<Failure, void>> unfavoriteBottle(String bottleId) async {
    try {
      // 检查网络连接
      if (!await _networkInfo.isConnected) {
        return const Left(Failure.network(
          message: '网络连接不可用，请检查网络设置',
        ));
      }
      
      // 验证参数
      if (bottleId.trim().isEmpty) {
        return const Left(Failure.validation(
          message: '漂流瓶ID不能为空',
        ));
      }
      
      await _remoteDataSource.unfavoriteBottle(bottleId);
      
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }
  
  @override
  Future<Either<Failure, List<Bottle>>> getFavoriteBottles({
    int? limit,
    String? beforeBottleId,
    String? afterBottleId,
  }) async {
    try {
      // 检查网络连接
      if (!await _networkInfo.isConnected) {
        return const Left(Failure.network(
          message: '网络连接不可用，请检查网络设置',
        ));
      }
      
      // 验证参数
      if (limit != null && limit <= 0) {
        return const Left(Failure.validation(
          message: '限制数量必须大于0',
        ));
      }
      
      final bottleListModel = await _remoteDataSource.getFavoriteBottles(
        limit: limit,
        beforeBottleId: beforeBottleId,
        afterBottleId: afterBottleId,
      );
      
      final bottles = bottleListModel.bottles
          .map((model) => model.toEntity())
          .toList();
      
      return Right(bottles);
    } catch (e) {
      return Left(_handleException(e));
    }
  }
  
  @override
  Future<Either<Failure, List<Bottle>>> searchBottles({
    required String query,
    int? limit,
    String? beforeBottleId,
    String? afterBottleId,
    double? latitude,
    double? longitude,
    int? radius,
    List<String>? tags,
  }) async {
    try {
      // 检查网络连接
      if (!await _networkInfo.isConnected) {
        return const Left(Failure.network(
          message: '网络连接不可用，请检查网络设置',
        ));
      }
      
      // 验证参数
      if (query.trim().isEmpty) {
        return const Left(Failure.validation(
          message: '搜索关键词不能为空',
        ));
      }
      
      if (limit != null && limit <= 0) {
        return const Left(Failure.validation(
          message: '限制数量必须大于0',
        ));
      }
      
      if (radius != null && radius <= 0) {
        return const Left(Failure.validation(
          message: '搜索半径必须大于0',
        ));
      }
      
      final bottleListModel = await _remoteDataSource.searchBottles(
        query: query,
        limit: limit,
        beforeBottleId: beforeBottleId,
        afterBottleId: afterBottleId,
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        tags: tags,
      );
      
      final bottles = bottleListModel.bottles
          .map((model) => model.toEntity())
          .toList();
      
      return Right(bottles);
    } catch (e) {
      return Left(_handleException(e));
    }
  }
  
  @override
  Future<Either<Failure, List<Bottle>>> getNearbyBottles({
    required double latitude,
    required double longitude,
    int? radius,
    int? limit,
    String? beforeBottleId,
    String? afterBottleId,
  }) async {
    try {
      // 检查网络连接
      if (!await _networkInfo.isConnected) {
        return const Left(Failure.network(
          message: '网络连接不可用，请检查网络设置',
        ));
      }
      
      // 验证参数
      if (limit != null && limit <= 0) {
        return const Left(Failure.validation(
          message: '限制数量必须大于0',
        ));
      }
      
      if (radius != null && radius <= 0) {
        return const Left(Failure.validation(
          message: '搜索半径必须大于0',
        ));
      }
      
      final bottleListModel = await _remoteDataSource.getNearbyBottles(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        limit: limit,
        beforeBottleId: beforeBottleId,
        afterBottleId: afterBottleId,
      );
      
      final bottles = bottleListModel.bottles
          .map((model) => model.toEntity())
          .toList();
      
      return Right(bottles);
    } catch (e) {
      return Left(_handleException(e));
    }
  }
  
  @override
  Future<Either<Failure, List<Bottle>>> getTrendingBottles({
    int? limit,
    String? beforeBottleId,
    String? afterBottleId,
    String? timeRange,
  }) async {
    try {
      // 检查网络连接
      if (!await _networkInfo.isConnected) {
        return const Left(Failure.network(
          message: '网络连接不可用，请检查网络设置',
        ));
      }
      
      // 验证参数
      if (limit != null && limit <= 0) {
        return const Left(Failure.validation(
          message: '限制数量必须大于0',
        ));
      }
      
      final bottleListModel = await _remoteDataSource.getTrendingBottles(
        limit: limit,
        beforeBottleId: beforeBottleId,
        afterBottleId: afterBottleId,
        timeRange: timeRange,
      );
      
      final bottles = bottleListModel.bottles
          .map((model) => model.toEntity())
          .toList();
      
      return Right(bottles);
    } catch (e) {
      return Left(_handleException(e));
    }
  }
  
  @override
  Future<Either<Failure, List<Bottle>>> getRecommendedBottles({
    int? limit,
    String? beforeBottleId,
    String? afterBottleId,
  }) async {
    try {
      // 检查网络连接
      if (!await _networkInfo.isConnected) {
        return const Left(Failure.network(
          message: '网络连接不可用，请检查网络设置',
        ));
      }
      
      // 验证参数
      if (limit != null && limit <= 0) {
        return const Left(Failure.validation(
          message: '限制数量必须大于0',
        ));
      }
      
      final bottleListModel = await _remoteDataSource.getRecommendedBottles(
        limit: limit,
        beforeBottleId: beforeBottleId,
        afterBottleId: afterBottleId,
      );
      
      final bottles = bottleListModel.bottles
          .map((model) => model.toEntity())
          .toList();
      
      return Right(bottles);
    } catch (e) {
      return Left(_handleException(e));
    }
  }
  
  /// 处理异常
  Failure _handleException(dynamic e) {
    final errorMessage = e.toString();
    
    // 网络相关错误
    if (errorMessage.contains('网络') || 
        errorMessage.contains('连接') ||
        errorMessage.contains('timeout') ||
        errorMessage.contains('connection')) {
      return Failure.network(
        message: errorMessage.contains('网络') ? errorMessage : '网络连接失败',
      );
    }
    
    // 认证相关错误
    if (errorMessage.contains('401') || 
        errorMessage.contains('unauthorized') ||
        errorMessage.contains('token')) {
      return const Failure.auth(
        message: '认证失败，请重新登录',
      );
    }
    
    // 权限相关错误
    if (errorMessage.contains('403') || 
        errorMessage.contains('forbidden')) {
      return const Failure.auth(
        message: '权限不足，无法执行此操作',
      );
    }
    
    // 验证相关错误
    if (errorMessage.contains('422') || 
        errorMessage.contains('validation')) {
      return Failure.validation(
        message: errorMessage.contains('validation') ? errorMessage : '数据验证失败',
      );
    }
    
    // 服务器错误
    if (errorMessage.contains('500') || 
        errorMessage.contains('502') ||
        errorMessage.contains('503') ||
        errorMessage.contains('504')) {
      return const Failure.server(
        message: '服务器错误，请稍后重试',
      );
    }
    
    // 默认为未知错误
    return Failure.unknown(
      message: errorMessage.isNotEmpty ? errorMessage : '未知错误',
      error: e,
    );
  }

  @override
  Future<Either<Failure, bool>> canPickBottle({
    required String bottleId,
    required double latitude,
    required double longitude,
  }) async {
    try {
      // 检查网络连接
      if (!await _networkInfo.isConnected) {
        return const Left(Failure.network(
          message: '网络连接不可用，请检查网络设置',
        ));
      }

      // 调用远程数据源检查是否可以捡取
      final canPick = await _remoteDataSource.canPickBottle(
        bottleId: bottleId,
        latitude: latitude,
        longitude: longitude,
      );

      return Right(canPick);
    } catch (e) {
      return Left(_handleException(e));
    }
  }
}