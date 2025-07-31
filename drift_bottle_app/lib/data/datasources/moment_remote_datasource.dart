import 'dart:io';
import 'package:injectable/injectable.dart';

import '../../core/errors/exceptions.dart';
import '../../core/network/dio_client.dart';
import '../models/moment_model.dart';
import '../models/api_response_model.dart';

/// 动态远程数据源抽象类
abstract class MomentRemoteDataSource {
  /// 发布动态
  Future<MomentModel> publishMoment({
    required String content,
    List<File>? images,
    File? video,
    String? location,
    double? latitude,
    double? longitude,
    String visibility = 'public',
    List<String>? tags,
  });
  
  /// 获取动态列表
  Future<MomentListModel> getMoments({
    int page = 1,
    int limit = 20,
    String? userId,
    String? visibility,
    List<String>? tags,
  });
  
  /// 获取动态详情
  Future<MomentModel> getMomentById(String momentId);
  
  /// 获取我的动态
  Future<MomentListModel> getMyMoments({
    int page = 1,
    int limit = 20,
  });
  
  /// 获取关注用户的动态
  Future<MomentListModel> getFollowingMoments({
    int page = 1,
    int limit = 20,
  });
  
  /// 获取附近的动态
  Future<MomentListModel> getNearbyMoments({
    required double latitude,
    required double longitude,
    double radius = 5.0,
    int page = 1,
    int limit = 20,
  });
  
  /// 搜索动态
  Future<MomentListModel> searchMoments({
    required String query,
    int page = 1,
    int limit = 20,
    List<String>? tags,
  });
  
  /// 点赞动态
  Future<void> likeMoment(String momentId);
  
  /// 取消点赞
  Future<void> unlikeMoment(String momentId);
  
  /// 收藏动态
  Future<void> bookmarkMoment(String momentId);
  
  /// 取消收藏
  Future<void> unbookmarkMoment(String momentId);
  
  /// 获取收藏的动态
  Future<MomentListModel> getBookmarkedMoments({
    int page = 1,
    int limit = 20,
  });
  
  /// 分享动态
  Future<void> shareMoment(String momentId);
  
  /// 删除动态
  Future<void> deleteMoment(String momentId);
  
  /// 举报动态
  Future<void> reportMoment({
    required String momentId,
    required String reason,
    String? description,
  });
  
  /// 更新动态
  Future<MomentModel> updateMoment({
    required String momentId,
    String? content,
    String? visibility,
    List<String>? tags,
  });
  
  /// 获取动态统计信息
  Future<MomentStatsModel> getMomentStats(String momentId);
  
  /// 获取热门动态
  Future<MomentListModel> getTrendingMoments({
    int page = 1,
    int limit = 20,
    String period = 'day',
  });
  
  /// 获取推荐动态
  Future<MomentListModel> getRecommendedMoments({
    int page = 1,
    int limit = 20,
  });
  
  /// 评论动态
  Future<void> commentMoment({
    required String momentId,
    required String content,
    String? replyToId,
  });
}

/// 动态远程数据源实现
@LazySingleton(as: MomentRemoteDataSource)
class MomentRemoteDataSourceImpl implements MomentRemoteDataSource {
  final DioClient _dioClient;
  
  MomentRemoteDataSourceImpl(this._dioClient);
  
  @override
  Future<MomentModel> publishMoment({
    required String content,
    List<File>? images,
    File? video,
    String? location,
    double? latitude,
    double? longitude,
    String visibility = 'public',
    List<String>? tags,
  }) async {
    try {
      final formData = <String, dynamic>{
        'content': content,
        'visibility': visibility,
        if (location != null) 'location': location,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        if (tags != null) 'tags': tags,
      };
      
      // 添加图片文件
      if (images != null && images.isNotEmpty) {
        for (int i = 0; i < images.length; i++) {
          formData['images[$i]'] = DioClient.multipartFile(images[i]);
        }
      }
      
      // 添加视频文件
      if (video != null) {
        formData['video'] = DioClient.multipartFile(video);
      }
      
      final response = await _dioClient.postFormData('/moments', formData);
      final apiResponse = ApiResponseModel.fromJson(response, (json) => json);
      
      if (apiResponse.isSuccess && apiResponse.data != null) {
        return MomentModel.fromJson(apiResponse.data);
      } else {
        throw ServerException(
          apiResponse.message,
          null,
          apiResponse.code,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('发布动态失败: $e');
    }
  }
  
  @override
  Future<MomentListModel> getMoments({
    int page = 1,
    int limit = 20,
    String? userId,
    String? visibility,
    List<String>? tags,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (userId != null) 'user_id': userId,
        if (visibility != null) 'visibility': visibility,
        if (tags != null) 'tags': tags.join(','),
      };
      
      final response = await _dioClient.get('/moments', queryParameters: queryParams);
      final apiResponse = ApiResponseModel.fromJson(response, (json) => json);
      
      if (apiResponse.isSuccess && apiResponse.data != null) {
        return MomentListModel.fromJson(apiResponse.data);
      } else {
        throw ServerException(
          apiResponse.message,
          null,
          apiResponse.code,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('获取动态列表失败: $e');
    }
  }
  
  @override
  Future<MomentModel> getMomentById(String momentId) async {
    try {
      final response = await _dioClient.get('/moments/$momentId');
      final apiResponse = ApiResponseModel.fromJson(response, (json) => json);
      
      if (apiResponse.isSuccess && apiResponse.data != null) {
        return MomentModel.fromJson(apiResponse.data);
      } else {
        throw ServerException(
          apiResponse.message,
          null,
          apiResponse.code,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('获取动态详情失败: $e');
    }
  }
  
  @override
  Future<MomentListModel> getMyMoments({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = {
        'page': page,
        'limit': limit,
      };
      
      final response = await _dioClient.get('/moments/my', queryParameters: queryParams);
      final apiResponse = ApiResponseModel.fromJson(response, (json) => json);
      
      if (apiResponse.isSuccess && apiResponse.data != null) {
        return MomentListModel.fromJson(apiResponse.data);
      } else {
        throw ServerException(
          apiResponse.message,
          null,
          apiResponse.code,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('获取我的动态失败: $e');
    }
  }
  
  @override
  Future<MomentListModel> getFollowingMoments({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = {
        'page': page,
        'limit': limit,
      };
      
      final response = await _dioClient.get('/moments/following', queryParameters: queryParams);
      final apiResponse = ApiResponseModel.fromJson(response, (json) => json);
      
      if (apiResponse.isSuccess && apiResponse.data != null) {
        return MomentListModel.fromJson(apiResponse.data);
      } else {
        throw ServerException(
          apiResponse.message,
          null,
          apiResponse.code,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('获取关注动态失败: $e');
    }
  }
  
  @override
  Future<MomentListModel> getNearbyMoments({
    required double latitude,
    required double longitude,
    double radius = 5.0,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = {
        'latitude': latitude,
        'longitude': longitude,
        'radius': radius,
        'page': page,
        'limit': limit,
      };
      
      final response = await _dioClient.get('/moments/nearby', queryParameters: queryParams);
      final apiResponse = ApiResponseModel.fromJson(response, (json) => json);
      
      if (apiResponse.isSuccess && apiResponse.data != null) {
        return MomentListModel.fromJson(apiResponse.data);
      } else {
        throw ServerException(
          apiResponse.message,
          null,
          apiResponse.code,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('获取附近动态失败: $e');
    }
  }
  
  @override
  Future<MomentListModel> searchMoments({
    required String query,
    int page = 1,
    int limit = 20,
    List<String>? tags,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'q': query,
        'page': page,
        'limit': limit,
        if (tags != null) 'tags': tags.join(','),
      };
      
      final response = await _dioClient.get('/moments/search', queryParameters: queryParams);
      final apiResponse = ApiResponseModel.fromJson(response, (json) => json);
      
      if (apiResponse.isSuccess && apiResponse.data != null) {
        return MomentListModel.fromJson(apiResponse.data);
      } else {
        throw ServerException(
          apiResponse.message,
          null,
          apiResponse.code,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('搜索动态失败: $e');
    }
  }
  
  @override
  Future<void> likeMoment(String momentId) async {
    try {
      final response = await _dioClient.post('/moments/$momentId/like');
      final apiResponse = ApiResponseModel.fromJson(response, (json) => json);
      
      if (!apiResponse.isSuccess) {
        throw ServerException(
          apiResponse.message,
          null,
          apiResponse.code,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('点赞失败: $e');
    }
  }
  
  @override
  Future<void> unlikeMoment(String momentId) async {
    try {
      final response = await _dioClient.delete('/moments/$momentId/like');
      final apiResponse = ApiResponseModel.fromJson(response, (json) => json);
      
      if (!apiResponse.isSuccess) {
        throw ServerException(
          apiResponse.message,
          null,
          apiResponse.code,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('取消点赞失败: $e');
    }
  }
  
  @override
  Future<void> bookmarkMoment(String momentId) async {
    try {
      final response = await _dioClient.post('/moments/$momentId/bookmark');
      final apiResponse = ApiResponseModel.fromJson(response, (json) => json);
      
      if (!apiResponse.isSuccess) {
        throw ServerException(
          apiResponse.message,
          null,
          apiResponse.code,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('收藏失败: $e');
    }
  }
  
  @override
  Future<void> unbookmarkMoment(String momentId) async {
    try {
      final response = await _dioClient.delete('/moments/$momentId/bookmark');
      final apiResponse = ApiResponseModel.fromJson(response, (json) => json);
      
      if (!apiResponse.isSuccess) {
        throw ServerException(
          apiResponse.message,
          null,
          apiResponse.code,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('取消收藏失败: $e');
    }
  }
  
  @override
  Future<MomentListModel> getBookmarkedMoments({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = {
        'page': page,
        'limit': limit,
      };
      
      final response = await _dioClient.get('/moments/bookmarked', queryParameters: queryParams);
      final apiResponse = ApiResponseModel.fromJson(response, (json) => json);
      
      if (apiResponse.isSuccess && apiResponse.data != null) {
        return MomentListModel.fromJson(apiResponse.data);
      } else {
        throw ServerException(
          apiResponse.message,
          null,
          apiResponse.code,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('获取收藏动态失败: $e');
    }
  }
  
  @override
  Future<void> shareMoment(String momentId) async {
    try {
      final response = await _dioClient.post('/moments/$momentId/share');
      final apiResponse = ApiResponseModel.fromJson(response, (json) => json);
      
      if (!apiResponse.isSuccess) {
        throw ServerException(
          apiResponse.message,
          null,
          apiResponse.code,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('分享失败: $e');
    }
  }
  
  @override
  Future<void> deleteMoment(String momentId) async {
    try {
      final response = await _dioClient.delete('/moments/$momentId');
      final apiResponse = ApiResponseModel.fromJson(response, (json) => json);
      
      if (!apiResponse.isSuccess) {
        throw ServerException(
          apiResponse.message,
          null,
          apiResponse.code,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('删除动态失败: $e');
    }
  }
  
  @override
  Future<void> reportMoment({
    required String momentId,
    required String reason,
    String? description,
  }) async {
    try {
      final data = {
        'reason': reason,
        if (description != null) 'description': description,
      };
      
      final response = await _dioClient.post('/moments/$momentId/report', data: data);
      final apiResponse = ApiResponseModel.fromJson(response, (json) => json);
      
      if (!apiResponse.isSuccess) {
        throw ServerException(
          apiResponse.message,
          null,
          apiResponse.code,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('举报失败: $e');
    }
  }
  
  @override
  Future<MomentModel> updateMoment({
    required String momentId,
    String? content,
    String? visibility,
    List<String>? tags,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (content != null) data['content'] = content;
      if (visibility != null) data['visibility'] = visibility;
      if (tags != null) data['tags'] = tags;
      
      final response = await _dioClient.put('/moments/$momentId', data: data);
      final apiResponse = ApiResponseModel.fromJson(response, (json) => json);
      
      if (apiResponse.isSuccess && apiResponse.data != null) {
        return MomentModel.fromJson(apiResponse.data);
      } else {
        throw ServerException(
          apiResponse.message,
          null,
          apiResponse.code,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('更新动态失败: $e');
    }
  }
  
  @override
  Future<MomentStatsModel> getMomentStats(String momentId) async {
    try {
      final response = await _dioClient.get('/moments/$momentId/stats');
      final apiResponse = ApiResponseModel.fromJson(response, (json) => json);
      
      if (apiResponse.isSuccess && apiResponse.data != null) {
        return MomentStatsModel.fromJson(apiResponse.data);
      } else {
        throw ServerException(
          apiResponse.message,
          null,
          apiResponse.code,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('获取动态统计失败: $e');
    }
  }
  
  @override
  Future<MomentListModel> getTrendingMoments({
    int page = 1,
    int limit = 20,
    String period = 'day',
  }) async {
    try {
      final queryParams = {
        'page': page,
        'limit': limit,
        'period': period,
      };
      
      final response = await _dioClient.get('/moments/trending', queryParameters: queryParams);
      final apiResponse = ApiResponseModel.fromJson(response, (json) => json);
      
      if (apiResponse.isSuccess && apiResponse.data != null) {
        return MomentListModel.fromJson(apiResponse.data);
      } else {
        throw ServerException(
          apiResponse.message,
          null,
          apiResponse.code,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('获取热门动态失败: $e');
    }
  }
  
  @override
  Future<MomentListModel> getRecommendedMoments({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = {
        'page': page,
        'limit': limit,
      };
      
      final response = await _dioClient.get('/moments/recommended', queryParameters: queryParams);
      final apiResponse = ApiResponseModel.fromJson(response, (json) => json);
      
      if (apiResponse.isSuccess && apiResponse.data != null) {
        return MomentListModel.fromJson(apiResponse.data);
      } else {
        throw ServerException(
          apiResponse.message,
          null,
          apiResponse.code,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('获取推荐动态失败: $e');
    }
  }
  
  @override
  Future<void> commentMoment({
    required String momentId,
    required String content,
    String? replyToId,
  }) async {
    try {
      final data = {
        'content': content,
        if (replyToId != null) 'reply_to_id': replyToId,
      };
      
      final response = await _dioClient.post('/moments/$momentId/comments', data: data);
      final apiResponse = ApiResponseModel.fromJson(response, (json) => json);
      
      if (!apiResponse.isSuccess) {
        throw ServerException(
          apiResponse.message,
          null,
          apiResponse.code,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('评论失败: $e');
    }
  }
}