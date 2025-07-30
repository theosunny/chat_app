import 'package:dio/dio.dart';
import 'package:fluwx/fluwx.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();
  
  // 发送验证码
  Future<bool> sendVerificationCode(String phone) async {
    if (kDebugMode) {
      // 开发模式：模拟发送验证码成功
      await Future.delayed(const Duration(seconds: 1));
      return true;
    }
    
    try {
      final response = await _apiService.post('/user/send-code', {
        'phone': phone,
      });
      return response['success'] ?? false;
    } catch (e) {
      throw Exception('发送验证码失败: $e');
    }
  }
  
  // 手机号登录
  Future<Map<String, dynamic>> loginWithPhone(String phone, String code) async {
    try {
      final response = await _apiService.post('/user/login', {
        'phone': phone,
        'code': code,
      });
      
      if (response['success']) {
        final token = response['data']['token'];
        final user = UserModel.fromJson(response['data']['user']);
        
        // 保存token到本地存储
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        
        return {
          'success': true,
          'user': user,
          'token': token,
        };
      } else {
        return {
          'success': false,
          'message': response['message'] ?? '登录失败',
        };
      }
    } catch (e) {
      throw Exception('手机号登录失败: $e');
    }
  }
  
  // 微信登录
  Future<Map<String, dynamic>> loginWithWechat() async {
    try {
      // 暂时返回未实现状态
      return {
        'success': false,
        'message': '微信登录功能暂未实现',
      };
    } catch (e) {
      throw Exception('微信登录失败: $e');
    }
  }
  
  // QQ登录 (这里使用模拟实现，实际需要集成QQ SDK)
  Future<Map<String, dynamic>> loginWithQQ() async {
    try {
      // 模拟QQ登录流程
      // 实际实现需要集成腾讯QQ SDK
      
      // 这里返回模拟数据
      await Future.delayed(const Duration(seconds: 2));
      
      final response = await _apiService.post('/auth/login/qq', {
        'access_token': 'mock_qq_token',
        'openid': 'mock_qq_openid',
      });
      
      if (response['success']) {
        return {
          'success': true,
          'user': UserModel.fromJson(response['user']),
          'token': response['token'],
        };
      } else {
        return {
          'success': false,
          'message': response['message'] ?? 'QQ登录失败',
        };
      }
    } catch (e) {
      throw Exception('QQ登录失败: $e');
    }
  }
  
  // 获取用户信息
  Future<UserModel?> getUserInfo() async {
    try {
      final response = await _apiService.get('/user/profile');
      
      if (response['success']) {
        return UserModel.fromJson(response['data']);
      }
      return null;
    } catch (e) {
      throw Exception('获取用户信息失败: $e');
    }
  }
  
  // 更新用户信息
  Future<bool> updateUserInfo(UserModel user) async {
    try {
      final response = await _apiService.put('/user/profile', user.toJson());
      return response['success'] ?? false;
    } catch (e) {
      throw Exception('更新用户信息失败: $e');
    }
  }
  
  // 登出
  Future<bool> logout() async {
    try {
      final response = await _apiService.post('/auth/logout', {});
      
      // 清除本地存储的token
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      
      return response['success'] ?? false;
    } catch (e) {
      throw Exception('登出失败: $e');
    }
  }
}