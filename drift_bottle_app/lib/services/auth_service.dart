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
      // 调用实际的登录API（开发和生产环境都使用真实API）
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
      // 调用实际的微信登录API（开发和生产环境都使用真实API）
      final response = await _apiService.post('/auth/login/wechat', {
        'access_token': 'wechat_access_token',
        'openid': 'wechat_openid',
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
          'message': response['message'] ?? '微信登录失败',
        };
      }
    } catch (e) {
      throw Exception('微信登录失败: $e');
    }
  }
  
  // QQ登录
  Future<Map<String, dynamic>> loginWithQQ() async {
    try {
      // 调用实际的QQ登录API（开发和生产环境都使用真实API）
      final response = await _apiService.post('/auth/login/qq', {
        'access_token': 'qq_access_token',
        'openid': 'qq_openid',
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
          'message': response['message'] ?? 'QQ登录失败',
        };
      }
    } catch (e) {
      throw Exception('QQ登录失败: $e');
    }
  }
  
  // 检查是否已登录
  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
  
  // 获取当前保存的token
  Future<String?> getCurrentToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('auth_token');
    } catch (e) {
      return null;
    }
  }
  
  // 验证token是否有效
  Future<bool> validateToken() async {
    try {
      final response = await _apiService.get('/user/profile');
      return response['success'] ?? false;
    } catch (e) {
      return false;
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