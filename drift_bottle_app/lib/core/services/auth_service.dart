import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';

/// 基于环信IM的认证服务
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final Dio _dio = Dio();
  late SharedPreferences _prefs;
  bool _isInitialized = false;

  // 环信配置
  static const String _appKey = '1195250731193294#demo'; // 需要替换为实际的AppKey
  static const String _baseUrl = 'http://localhost:8080/api';

  /// 初始化服务
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _prefs = await SharedPreferences.getInstance();
    
    // 初始化环信SDK
    EMOptions options = EMOptions(
      appKey: _appKey,
      autoLogin: false,
    );
    
    await EMClient.getInstance.init(options);
    
    // 配置Dio拦截器
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            await logout();
          }
          handler.next(error);
        },
      ),
    );
    
    _isInitialized = true;
  }

  /// 用户注册
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    String? nickname,
  }) async {
    try {
      // 1. 在后端注册用户
      final response = await _dio.post(
        '$_baseUrl/auth/register',
        data: {
          'username': username,
          'email': email,
          'password': password,
          'nickname': nickname ?? username,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        // 2. 在环信注册用户
        await EMClient.getInstance.createAccount(
          username,
          password,
        );

        return {
          'success': true,
          'message': '注册成功',
          'data': data,
        };
      }
      
      return {
        'success': false,
        'message': '注册失败',
      };
    } catch (e) {
      return {
        'success': false,
        'message': '注册失败: ${e.toString()}',
      };
    }
  }

  /// 用户登录
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      // 1. 后端登录验证
      final response = await _dio.post(
        '$_baseUrl/auth/login',
        data: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final token = data['token'];
        final user = data['user'];

        // 2. 保存Token
        await saveToken(token);
        await saveUserInfo(user);

        // 3. 环信登录
        await EMClient.getInstance.login(
          username,
          password,
        );

        return {
          'success': true,
          'message': '登录成功',
          'data': data,
        };
      }
      
      return {
        'success': false,
        'message': '登录失败',
      };
    } catch (e) {
      return {
        'success': false,
        'message': '登录失败: ${e.toString()}',
      };
    }
  }

  /// 用户登出
  Future<void> logout() async {
    try {
      // 1. 环信登出
      await EMClient.getInstance.logout(true);
      
      // 2. 清除本地数据
      await _prefs.remove('auth_token');
      await _prefs.remove('user_info');
      await _prefs.remove('refresh_token');
    } catch (e) {
      print('登出失败: $e');
    }
  }

  /// 检查登录状态
  Future<bool> isLoggedIn() async {
    try {
      final token = await getToken();
      final isEMLoggedIn = await EMClient.getInstance.isLoginBefore();
      return token != null && isEMLoggedIn;
    } catch (e) {
      return false;
    }
  }

  /// 获取当前用户信息
  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final userInfo = _prefs.getString('user_info');
      if (userInfo != null) {
        return Map<String, dynamic>.from(
          Uri.splitQueryString(userInfo),
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// 更新用户资料
  Future<Map<String, dynamic>> updateProfile({
    String? nickname,
    String? avatar,
    String? signature,
  }) async {
    try {
      final response = await _dio.put(
        '$_baseUrl/user/profile',
        data: {
          if (nickname != null) 'nickname': nickname,
          if (avatar != null) 'avatar': avatar,
          if (signature != null) 'signature': signature,
        },
      );

      if (response.statusCode == 200) {
        // 更新环信用户信息
        if (nickname != null) {
          await EMClient.getInstance.userInfoManager.updateUserInfo(
            nickname: nickname,
          );
        }
        
        // 更新本地用户信息
        final currentUser = await getCurrentUser();
        if (currentUser != null) {
          if (nickname != null) currentUser['nickname'] = nickname;
          if (avatar != null) currentUser['avatar'] = avatar;
          if (signature != null) currentUser['signature'] = signature;
          await saveUserInfo(currentUser);
        }

        return {
          'success': true,
          'message': '更新成功',
          'data': response.data,
        };
      }
      
      return {
        'success': false,
        'message': '更新失败',
      };
    } catch (e) {
      return {
        'success': false,
        'message': '更新失败: ${e.toString()}',
      };
    }
  }

  /// 修改密码
  Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.put(
        '$_baseUrl/auth/change-password',
        data: {
          'old_password': oldPassword,
          'new_password': newPassword,
        },
      );

      if (response.statusCode == 200) {
        // 更新环信密码
        // 环信SDK不直接支持修改密码，需要通过服务端API实现
    // 这里只更新本地状态，实际密码修改通过后端API完成

        return {
          'success': true,
          'message': '密码修改成功',
        };
      }
      
      return {
        'success': false,
        'message': '密码修改失败',
      };
    } catch (e) {
      return {
        'success': false,
        'message': '密码修改失败: ${e.toString()}',
      };
    }
  }

  /// 重置密码
  Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/auth/reset-password',
        data: {'email': email},
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': '重置密码邮件已发送',
        };
      }
      
      return {
        'success': false,
        'message': '重置密码失败',
      };
    } catch (e) {
      return {
        'success': false,
        'message': '重置密码失败: ${e.toString()}',
      };
    }
  }

  // Token管理
  Future<void> saveToken(String token) async {
    await _prefs.setString('auth_token', token);
  }

  Future<String?> getToken() async {
    return _prefs.getString('auth_token');
  }

  Future<void> saveUserInfo(Map<String, dynamic> userInfo) async {
    await _prefs.setString('user_info', userInfo.toString());
  }

  /// 获取环信用户信息
  Future<EMUserInfo?> getEMUserInfo(String userId) async {
    try {
      final userInfos = await EMClient.getInstance.userInfoManager.fetchUserInfoById([userId]);
      return userInfos[userId];
    } catch (e) {
      print('获取环信用户信息失败: $e');
      return null;
    }
  }

  /// 获取环信当前用户ID
  String? getCurrentEMUserId() {
    return EMClient.getInstance.currentUsername;
  }
}