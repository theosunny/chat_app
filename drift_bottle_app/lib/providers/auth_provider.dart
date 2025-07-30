import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  
  final AuthService _authService = AuthService();
  
  UserModel? get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  
  AuthProvider() {
    _checkLoginStatus();
  }
  
  // 检查登录状态
  Future<void> _checkLoginStatus() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (token != null && token.isNotEmpty) {
        try {
          // 验证token有效性
          final user = await _authService.getUserInfo();
          debugPrint('AuthProvider: 获取到用户信息: ${user?.toJson()}');
          if (user != null) {
            _user = user;
            _isLoggedIn = true;
            debugPrint('AuthProvider: 用户状态更新成功 - isLoggedIn: $_isLoggedIn, user: ${_user?.nickname}');
          } else {
            debugPrint('AuthProvider: 用户信息为空，执行登出');
            await logout();
          }
        } catch (e) {
          debugPrint('Token验证失败，清除登录状态: $e');
          await logout();
        }
      }
    } catch (e) {
      debugPrint('检查登录状态失败: $e');
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  // 手机号登录
  Future<bool> loginWithPhone(String phone, String code) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final result = await _authService.loginWithPhone(phone, code);
      if (result['success']) {
        _user = result['user'];
        _isLoggedIn = true;
        
        // 保存token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', result['token']);
        
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint('手机号登录失败: $e');
    }
    
    _isLoading = false;
    notifyListeners();
    return false;
  }
  
  // 微信登录
  Future<bool> loginWithWechat() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final result = await _authService.loginWithWechat();
      if (result['success']) {
        _user = result['user'];
        _isLoggedIn = true;
        
        // 保存token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', result['token']);
        
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint('微信登录失败: $e');
    }
    
    _isLoading = false;
    notifyListeners();
    return false;
  }
  
  // QQ登录
  Future<bool> loginWithQQ() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final result = await _authService.loginWithQQ();
      if (result['success']) {
        _user = result['user'];
        _isLoggedIn = true;
        
        // 保存token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', result['token']);
        
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint('QQ登录失败: $e');
    }
    
    _isLoading = false;
    notifyListeners();
    return false;
  }
  
  // 登出
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      
      _user = null;
      _isLoggedIn = false;
      notifyListeners();
    } catch (e) {
      debugPrint('登出失败: $e');
    }
  }
  
  // 更新用户信息
  void updateUser(UserModel user) {
    _user = user;
    notifyListeners();
  }
  
  // 更新用户资料
  Future<void> updateProfile({
    String? nickname,
    String? signature,
  }) async {
    try {
      // 创建更新后的用户对象
      final updatedUserData = _user!.copyWith(
        nickname: nickname ?? _user!.nickname,
        signature: signature ?? _user!.signature,
      );
      
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      
      final success = await _authService.updateUserInfo(updatedUserData);
      
      if (success) {
         _user = updatedUserData;
         notifyListeners();
       }
    } catch (e) {
      debugPrint('更新用户资料失败: $e');
      rethrow;
    }
  }
}