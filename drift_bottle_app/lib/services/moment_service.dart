import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class MomentService {
  final ApiService _apiService = ApiService();
  
  // 获取授权头
  Future<Map<String, String>> _getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    return {'Authorization': 'Bearer $token'};
  }
  
  // 获取动态列表
  Future<Map<String, dynamic>> getMoments({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await _apiService.get(
        '/moments',
        queryParameters: {
          'page': page,
          'page_size': pageSize,
        },
        headers: headers,
      );
      return response;
    } catch (e) {
      throw Exception('获取动态列表失败: $e');
    }
  }
  
  // 发布动态
  Future<Map<String, dynamic>> publishMoment({
    required String content,
    List<String>? imagePaths,
  }) async {
    try {
      final headers = await _getAuthHeaders();
      List<String> imageUrls = [];
      
      // 如果有图片，先上传图片
      if (imagePaths != null && imagePaths.isNotEmpty) {
        for (String imagePath in imagePaths) {
          final uploadResult = await _apiService.uploadFile(
            '/upload/image',
            imagePath,
            headers: headers,
          );
          
          if (uploadResult['success']) {
            imageUrls.add(uploadResult['data']['url']);
          } else {
            throw Exception('图片上传失败');
          }
        }
      }
      
      final response = await _apiService.post(
        '/moments',
        {
          'content': content,
          'images': imageUrls,
        },
        headers: headers,
      );
      return response;
    } catch (e) {
      throw Exception('发布动态失败: $e');
    }
  }
  
  // 点赞动态
  Future<Map<String, dynamic>> likeMoment(String momentId) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await _apiService.post(
        '/moments/$momentId/like',
        {},
        headers: headers,
      );
      return response;
    } catch (e) {
      throw Exception('点赞动态失败: $e');
    }
  }
  
  // 评论动态
  Future<Map<String, dynamic>> commentMoment({
    required String momentId,
    required String content,
    String? replyToId,
  }) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await _apiService.post(
        '/moments/$momentId/comment',
        {
          'content': content,
          if (replyToId != null) 'reply_to_id': replyToId,
        },
        headers: headers,
      );
      return response;
    } catch (e) {
      throw Exception('评论动态失败: $e');
    }
  }
  
  // 获取动态详情
  Future<Map<String, dynamic>> getMomentDetail(String momentId) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await _apiService.get(
        '/moments/$momentId',
        headers: headers,
      );
      return response;
    } catch (e) {
      throw Exception('获取动态详情失败: $e');
    }
  }
  
  // 删除动态
  Future<Map<String, dynamic>> deleteMoment(String momentId) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await _apiService.delete(
        '/moments/$momentId',
        headers: headers,
      );
      return response;
    } catch (e) {
      throw Exception('删除动态失败: $e');
    }
  }
  
  // 获取用户动态
  Future<Map<String, dynamic>> getUserMoments(
    String userId, {
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await _apiService.get(
        '/users/$userId/moments',
        queryParameters: {
          'page': page,
          'page_size': pageSize,
        },
        headers: headers,
      );
      return response;
    } catch (e) {
      throw Exception('获取用户动态失败: $e');
    }
  }
  
  // 获取我的动态
  Future<Map<String, dynamic>> getMyMoments({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await _apiService.get(
        '/moments/my',
        queryParameters: {
          'page': page,
          'page_size': pageSize,
        },
        headers: headers,
      );
      return response;
    } catch (e) {
      throw Exception('获取我的动态失败: $e');
    }
  }
  
  // 删除评论
  Future<Map<String, dynamic>> deleteComment(String commentId) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await _apiService.delete(
        '/comments/$commentId',
        headers: headers,
      );
      return response;
    } catch (e) {
      throw Exception('删除评论失败: $e');
    }
  }
  
  // 举报动态
  Future<Map<String, dynamic>> reportMoment({
    required String momentId,
    required String reason,
  }) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await _apiService.post(
        '/moments/$momentId/report',
        {'reason': reason},
        headers: headers,
      );
      return response;
    } catch (e) {
      throw Exception('举报动态失败: $e');
    }
  }
}