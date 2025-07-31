import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../core/constants/api_constants.dart';
import '../../core/network/dio_client.dart';
import '../models/bottle_model.dart';
import '../models/user_model.dart';

/// 漂流瓶远程数据源抽象类
abstract class BottleRemoteDataSource {
  /// 发送漂流瓶
  Future<BottleModel> sendBottle({
    required String content,
    String? imageUrl,
    double? latitude,
    double? longitude,
    String? locationName,
    List<String>? tags,
  });
  
  /// 捡漂流瓶
  Future<BottleModel?> pickBottle({
    double? latitude,
    double? longitude,
    int? radius,
  });
  
  /// 获取漂流瓶列表
  Future<BottleListModel> getBottles({
    int? limit,
    String? beforeBottleId,
    String? afterBottleId,
    String? type, // 'sent', 'picked', 'all'
    double? latitude,
    double? longitude,
    int? radius,
    List<String>? tags,
  });
  
  /// 获取漂流瓶详情
  Future<BottleModel> getBottleById(String bottleId);
  
  /// 删除漂流瓶
  Future<void> deleteBottle(String bottleId);
  
  /// 举报漂流瓶
  Future<void> reportBottle({
    required String bottleId,
    required String reason,
    String? description,
  });
  
  /// 点赞漂流瓶
  Future<void> likeBottle(String bottleId);
  
  /// 取消点赞漂流瓶
  Future<void> unlikeBottle(String bottleId);
  
  /// 收藏漂流瓶
  Future<void> favoriteBottle(String bottleId);
  
  /// 取消收藏漂流瓶
  Future<void> unfavoriteBottle(String bottleId);
  
  /// 获取收藏的漂流瓶列表
  Future<BottleListModel> getFavoriteBottles({
    int? limit,
    String? beforeBottleId,
    String? afterBottleId,
  });
  
  /// 获取漂流瓶统计信息
  Future<BottleStatsModel> getBottleStats();
  
  /// 搜索漂流瓶
  Future<BottleListModel> searchBottles({
    required String query,
    int? limit,
    String? beforeBottleId,
    String? afterBottleId,
    double? latitude,
    double? longitude,
    int? radius,
    List<String>? tags,
  });
  
  /// 获取附近的漂流瓶
  Future<BottleListModel> getNearbyBottles({
    required double latitude,
    required double longitude,
    int? radius,
    int? limit,
    String? beforeBottleId,
    String? afterBottleId,
  });
  
  /// 获取热门漂流瓶
  Future<BottleListModel> getTrendingBottles({
    int? limit,
    String? beforeBottleId,
    String? afterBottleId,
    String? timeRange, // 'day', 'week', 'month'
  });
  
  /// 获取推荐漂流瓶
  Future<BottleListModel> getRecommendedBottles({
    int? limit,
    String? beforeBottleId,
    String? afterBottleId,
  });

  /// 检查是否可以捡取漂流瓶
  Future<bool> canPickBottle({
    required String bottleId,
    required double latitude,
    required double longitude,
  });
}

/// 漂流瓶远程数据源实现
@LazySingleton(as: BottleRemoteDataSource)
class BottleRemoteDataSourceImpl implements BottleRemoteDataSource {
  final DioClient _dioClient;
  
  const BottleRemoteDataSourceImpl(this._dioClient);
  
  @override
  Future<BottleModel> sendBottle({
    required String content,
    String? imageUrl,
    double? latitude,
    double? longitude,
    String? locationName,
    List<String>? tags,
  }) async {
    try {
      final data = {
        'content': content,
        if (imageUrl != null) 'image_url': imageUrl,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        if (locationName != null) 'location_name': locationName,
        if (tags != null && tags.isNotEmpty) 'tags': tags,
      };
      
      final response = await _dioClient.post(
        ApiConstants.sendBottle,
        data: data,
      );
      
      return BottleModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('发送漂流瓶失败: $e');
    }
  }
  
  @override
  Future<BottleModel?> pickBottle({
    double? latitude,
    double? longitude,
    int? radius,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (latitude != null) queryParams['latitude'] = latitude;
      if (longitude != null) queryParams['longitude'] = longitude;
      if (radius != null) queryParams['radius'] = radius;
      
      final response = await _dioClient.post(
        ApiConstants.pickBottle,
        queryParameters: queryParams,
      );
      
      final data = response.data['data'];
      return data != null ? BottleModel.fromJson(data) : null;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('捡漂流瓶失败: $e');
    }
  }
  
  @override
  Future<BottleListModel> getBottles({
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
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      if (beforeBottleId != null) queryParams['before_bottle_id'] = beforeBottleId;
      if (afterBottleId != null) queryParams['after_bottle_id'] = afterBottleId;
      if (type != null) queryParams['type'] = type;
      if (latitude != null) queryParams['latitude'] = latitude;
      if (longitude != null) queryParams['longitude'] = longitude;
      if (radius != null) queryParams['radius'] = radius;
      if (tags != null && tags.isNotEmpty) queryParams['tags'] = tags.join(',');
      
      final response = await _dioClient.get(
        ApiConstants.bottles,
        queryParameters: queryParams,
      );
      
      return BottleListModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('获取漂流瓶列表失败: $e');
    }
  }
  
  @override
  Future<BottleModel> getBottleById(String bottleId) async {
    try {
      final response = await _dioClient.get(
        ApiConstants.getBottleById(bottleId),
      );
      
      return BottleModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('获取漂流瓶详情失败: $e');
    }
  }
  
  @override
  Future<void> deleteBottle(String bottleId) async {
    try {
      await _dioClient.delete(
        ApiConstants.deleteBottleById(bottleId),
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('删除漂流瓶失败: $e');
    }
  }
  
  @override
  Future<void> reportBottle({
    required String bottleId,
    required String reason,
    String? description,
  }) async {
    try {
      final data = {
        'reason': reason,
        if (description != null) 'description': description,
      };
      
      await _dioClient.post(
        ApiConstants.reportBottleById(bottleId),
        data: data,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('举报漂流瓶失败: $e');
    }
  }
  
  @override
  Future<void> likeBottle(String bottleId) async {
    try {
      await _dioClient.post(
        ApiConstants.likeBottleById(bottleId),
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('点赞漂流瓶失败: $e');
    }
  }
  
  @override
  Future<void> unlikeBottle(String bottleId) async {
    try {
      await _dioClient.delete(
        '${ApiConstants.likeBottleById}/$bottleId',
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('取消点赞漂流瓶失败: $e');
    }
  }
  
  @override
  Future<void> favoriteBottle(String bottleId) async {
    try {
      await _dioClient.post(
        ApiConstants.favoriteBottleById(bottleId),
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('收藏漂流瓶失败: $e');
    }
  }
  
  @override
  Future<void> unfavoriteBottle(String bottleId) async {
    try {
      await _dioClient.delete(
        '${ApiConstants.favoriteBottleById}/$bottleId',
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('取消收藏漂流瓶失败: $e');
    }
  }
  
  @override
  Future<BottleListModel> getFavoriteBottles({
    int? limit,
    String? beforeBottleId,
    String? afterBottleId,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      if (beforeBottleId != null) queryParams['before_bottle_id'] = beforeBottleId;
      if (afterBottleId != null) queryParams['after_bottle_id'] = afterBottleId;
      
      final response = await _dioClient.get(
        ApiConstants.favoriteBottles,
        queryParameters: queryParams,
      );
      
      return BottleListModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('获取收藏漂流瓶列表失败: $e');
    }
  }
  
  @override
  Future<BottleStatsModel> getBottleStats() async {
    try {
      final response = await _dioClient.get(
        ApiConstants.getBottleStats,
      );
      
      return BottleStatsModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('获取漂流瓶统计信息失败: $e');
    }
  }
  
  @override
  Future<BottleListModel> searchBottles({
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
      final queryParams = <String, dynamic>{
        'q': query,
      };
      if (limit != null) queryParams['limit'] = limit;
      if (beforeBottleId != null) queryParams['before_bottle_id'] = beforeBottleId;
      if (afterBottleId != null) queryParams['after_bottle_id'] = afterBottleId;
      if (latitude != null) queryParams['latitude'] = latitude;
      if (longitude != null) queryParams['longitude'] = longitude;
      if (radius != null) queryParams['radius'] = radius;
      if (tags != null && tags.isNotEmpty) queryParams['tags'] = tags.join(',');
      
      final response = await _dioClient.get(
        ApiConstants.searchBottles,
        queryParameters: queryParams,
      );
      
      return BottleListModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('搜索漂流瓶失败: $e');
    }
  }
  
  @override
  Future<BottleListModel> getNearbyBottles({
    required double latitude,
    required double longitude,
    int? radius,
    int? limit,
    String? beforeBottleId,
    String? afterBottleId,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'latitude': latitude,
        'longitude': longitude,
      };
      if (radius != null) queryParams['radius'] = radius;
      if (limit != null) queryParams['limit'] = limit;
      if (beforeBottleId != null) queryParams['before_bottle_id'] = beforeBottleId;
      if (afterBottleId != null) queryParams['after_bottle_id'] = afterBottleId;
      
      final response = await _dioClient.get(
        ApiConstants.getNearbyBottles,
        queryParameters: queryParams,
      );
      
      return BottleListModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('获取附近漂流瓶失败: $e');
    }
  }
  
  @override
  Future<BottleListModel> getTrendingBottles({
    int? limit,
    String? beforeBottleId,
    String? afterBottleId,
    String? timeRange,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      if (beforeBottleId != null) queryParams['before_bottle_id'] = beforeBottleId;
      if (afterBottleId != null) queryParams['after_bottle_id'] = afterBottleId;
      if (timeRange != null) queryParams['time_range'] = timeRange;
      
      final response = await _dioClient.get(
        ApiConstants.getTrendingBottles,
        queryParameters: queryParams,
      );
      
      return BottleListModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('获取热门漂流瓶失败: $e');
    }
  }
  
  @override
  Future<BottleListModel> getRecommendedBottles({
    int? limit,
    String? beforeBottleId,
    String? afterBottleId,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      if (beforeBottleId != null) queryParams['before_bottle_id'] = beforeBottleId;
      if (afterBottleId != null) queryParams['after_bottle_id'] = afterBottleId;
      
      final response = await _dioClient.get(
        ApiConstants.getRecommendedBottles,
        queryParameters: queryParams,
      );
      
      return BottleListModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('获取推荐漂流瓶失败: $e');
    }
  }
  
  @override
  Future<bool> canPickBottle({
    required String bottleId,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final queryParams = {
        'latitude': latitude,
        'longitude': longitude,
      };
      
      final response = await _dioClient.get(
        '/bottles/$bottleId/can-pick',
        queryParameters: queryParams,
      );
      
      return response.data['data']['can_pick'] as bool;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('检查漂流瓶可捡取状态失败: $e');
    }
  }

  /// 处理Dio异常
  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('网络连接超时，请检查网络设置');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? '请求失败';
        return Exception('请求失败 ($statusCode): $message');
      case DioExceptionType.cancel:
        return Exception('请求已取消');
      case DioExceptionType.connectionError:
        return Exception('网络连接失败，请检查网络设置');
      default:
        return Exception('网络请求失败: ${e.message}');
    }
  }
}