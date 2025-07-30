import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'api_service.dart';
import '../models/bottle_model.dart';
import '../models/user_model.dart';

class BottleService {
  final ApiService _apiService = ApiService();
  

  
  // 获取漂流瓶列表
  Future<Map<String, dynamic>> getBottles({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _apiService.get(
        '/bottles',
        queryParameters: {
          'page': page,
          'page_size': pageSize,
        },
      );
      return response;
    } catch (e) {
      throw Exception('获取漂流瓶列表失败: $e');
    }
  }
  
  // 捞取随机漂流瓶
  Future<Map<String, dynamic>> pickRandomBottle() async {
    try {
      final response = await _apiService.post(
        '/bottles/pick',
        {},
      );
      return response;
    } catch (e) {
      throw Exception('捞取漂流瓶失败: $e');
    }
  }
  
  // 创建漂流瓶
  Future<Map<String, dynamic>> createBottle({
    required String content,
    String? imagePath,
  }) async {
    return await publishBottle(
      content: content,
      imagePath: imagePath,
    );
  }

  // 发布漂流瓶
  Future<Map<String, dynamic>> publishBottle({
    required String content,
    String? imagePath,
  }) async {
    try {
      if (imagePath != null) {
        // 如果有图片，先上传图片
        final uploadResult = await _apiService.uploadFile(
          '/upload/image',
          imagePath,
        );
        
        if (uploadResult['success']) {
          final imageUrl = uploadResult['data']['url'];
          final response = await _apiService.post(
            '/bottles',
            {
              'content': content,
              'image_url': imageUrl,
            },
          );
          return response;
        } else {
          throw Exception('图片上传失败');
        }
      } else {
        final response = await _apiService.post(
          '/bottles',
          {'content': content},
        );
        return response;
      }
    } catch (e) {
      throw Exception('发布漂流瓶失败: $e');
    }
  }
  
  // 回复漂流瓶
  Future<Map<String, dynamic>> replyToBottle({
    required String bottleId,
    required String content,
  }) async {
    try {
      final response = await _apiService.post(
        '/bottles/$bottleId/reply',
        {'content': content},
      );
      return response;
    } catch (e) {
      throw Exception('回复漂流瓶失败: $e');
    }
  }
  
  // 点赞漂流瓶
  Future<Map<String, dynamic>> likeBottle(String bottleId) async {
    try {
      final response = await _apiService.post(
        '/bottles/$bottleId/like',
        {},
      );
      return response;
    } catch (e) {
      throw Exception('点赞漂流瓶失败: $e');
    }
  }
  
  // 获取漂流瓶详情
  Future<Map<String, dynamic>> getBottleDetail(String bottleId) async {
    try {
      final response = await _apiService.get(
        '/bottles/$bottleId',
      );
      return response;
    } catch (e) {
      throw Exception('获取漂流瓶详情失败: $e');
    }
  }
  
  // 获取我的漂流瓶
  Future<Map<String, dynamic>> getMyBottles({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _apiService.get(
        '/bottles/my',
        queryParameters: {
          'page': page,
          'page_size': pageSize,
        },
      );
      return response;
    } catch (e) {
      throw Exception('获取我的漂流瓶失败: $e');
    }
  }
  
  // 删除漂流瓶
  Future<Map<String, dynamic>> deleteBottle(String bottleId) async {
    try {
      final response = await _apiService.delete(
        '/bottles/$bottleId',
      );
      return response;
    } catch (e) {
      throw Exception('删除漂流瓶失败: $e');
    }
  }
  
  // 举报漂流瓶
  Future<Map<String, dynamic>> reportBottle({
    required String bottleId,
    required String reason,
  }) async {
    try {
      final response = await _apiService.post(
        '/bottles/$bottleId/report',
        {'reason': reason},
      );
      return response;
    } catch (e) {
      throw Exception('举报漂流瓶失败: $e');
    }
  }
  
  // 模拟数据方法
  Map<String, dynamic> _getMockBottles(int page, int pageSize) {
    final mockBottles = List.generate(pageSize, (index) => {
      'id': 'bottle_${page}_${index + 1}',
      'content': '这是第${page}页第${index + 1}个模拟漂流瓶的内容，包含一些有趣的文字...',
      'image_url': index % 3 == 0 ? 'https://picsum.photos/300/200?random=${page * pageSize + index}' : null,
      'author': {
        'id': 'user_${index + 1}',
        'nickname': '用户${index + 1}',
        'avatar': 'https://picsum.photos/50/50?random=${index + 100}',
      },
      'created_at': DateTime.now().subtract(Duration(hours: index)).toIso8601String(),
      'reply_count': (index * 3) % 10,
      'like_count': (index * 7) % 20,
    });
    
    return {
      'success': true,
      'data': {
        'bottles': mockBottles,
        'total': 100,
        'page': page,
        'page_size': pageSize,
        'has_more': page < 5,
      }
    };
  }
  
  Map<String, dynamic> _getMockRandomBottle() {
    final random = DateTime.now().millisecondsSinceEpoch % 10;
    return {
      'success': true,
      'data': {
        'bottle': {
          'id': 'random_bottle_$random',
          'content': '这是一个随机捞取的漂流瓶，里面装着来自远方的问候和祝福...',
          'image_url': random % 2 == 0 ? 'https://picsum.photos/400/300?random=$random' : null,
          'author': {
            'id': 'random_user_$random',
            'nickname': '神秘用户$random',
            'avatar': 'https://picsum.photos/50/50?random=${random + 200}',
          },
          'created_at': DateTime.now().subtract(Duration(days: random)).toIso8601String(),
          'reply_count': random * 2,
          'like_count': random * 5,
        }
      }
    };
  }
}