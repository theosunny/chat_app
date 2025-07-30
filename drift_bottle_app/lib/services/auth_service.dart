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
      if (kDebugMode) {
        // 开发模式：模拟手机号登录成功
        await Future.delayed(const Duration(seconds: 1));
        
        // 简单验证：验证码为123456时登录成功
        if (code == '123456') {
          final mockUser = UserModel(
            id: 'phone_user_001',
            nickname: '手机用户',
            avatar: 'https://via.placeholder.com/100',
            phone: phone,
            email: 'phone@example.com',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          
          final token = 'mock_phone_token_${DateTime.now().millisecondsSinceEpoch}';
          
          // 保存token到本地存储
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
          
          return {
            'success': true,
            'user': mockUser,
            'token': token,
          };
        } else {
          return {
            'success': false,
            'message': '验证码错误，请输入123456',
          };
        }
      }
      
      // 生产环境：调用实际的登录API
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
      if (kDebugMode) {
        // 开发模式：模拟微信登录成功
        await Future.delayed(const Duration(seconds: 2));
        
        final mockUser = UserModel(
          id: 'wechat_user_001',
          nickname: '微信用户',
          avatar: 'https://via.placeholder.com/100',
          phone: '138****8888',
          email: 'wechat@example.com',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        final token = 'mock_wechat_token_${DateTime.now().millisecondsSinceEpoch}';
        
        // 保存token到本地存储
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        
        return {
          'success': true,
          'user': mockUser,
          'token': token,
        };
      }
      
      // 生产环境：调用实际的微信登录API
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
      if (kDebugMode) {
        // 开发模式：模拟QQ登录成功
        await Future.delayed(const Duration(seconds: 2));
        
        final mockUser = UserModel(
          id: 'qq_user_001',
          nickname: 'QQ用户',
          avatar: 'https://via.placeholder.com/100',
          phone: '139****9999',
          email: 'qq@example.com',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        final token = 'mock_qq_token_${DateTime.now().millisecondsSinceEpoch}';
        
        // 保存token到本地存储
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        
        return {
          'success': true,
          'user': mockUser,
          'token': token,
        };
      }
      
      // 生产环境：调用实际的QQ登录API
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