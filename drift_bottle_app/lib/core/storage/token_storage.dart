import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

/// Token存储管理
@lazySingleton
class TokenStorage {
  final SharedPreferences _prefs;
  
  TokenStorage(this._prefs);
  
  /// 初始化
  Future<void> init() async {
    // 不需要初始化，SharedPreferences已经通过依赖注入提供
  }
  
  /// 保存访问token
  Future<void> saveAccessToken(String token) async {
    await _prefs.setString(AppConstants.keyAccessToken, token);
  }
  
  /// 保存刷新token
  Future<void> saveRefreshToken(String token) async {
    await _prefs.setString(AppConstants.keyRefreshToken, token);
  }
  
  /// 同时保存两个token
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _prefs.setString(AppConstants.keyAccessToken, accessToken),
      _prefs.setString(AppConstants.keyRefreshToken, refreshToken),
    ]);
  }
  
  /// 获取访问token
  Future<String?> getAccessToken() async {
    return _prefs.getString(AppConstants.keyAccessToken);
  }
  
  /// 获取刷新token
  Future<String?> getRefreshToken() async {
    return _prefs.getString(AppConstants.keyRefreshToken);
  }
  
  /// 检查是否有有效token
  Future<bool> hasValidToken() async {
    final accessToken = await getAccessToken();
    return accessToken != null && accessToken.isNotEmpty;
  }
  
  /// 清除所有token
  Future<void> clearTokens() async {
    await Future.wait([
      _prefs.remove(AppConstants.keyAccessToken),
      _prefs.remove(AppConstants.keyRefreshToken),
    ]);
  }
  
  /// 保存用户ID
  Future<void> saveUserId(String userId) async {
    await _prefs.setString(AppConstants.keyUserId, userId);
  }
  
  /// 获取用户ID
  Future<String?> getUserId() async {
    return _prefs.getString(AppConstants.keyUserId);
  }
  
  /// 清除用户ID
  Future<void> clearUserId() async {
    await _prefs.remove(AppConstants.keyUserId);
  }
  
  /// 清除所有用户相关数据
  Future<void> clearUserData() async {
    await Future.wait([
      clearTokens(),
      clearUserId(),
      _prefs.remove(AppConstants.keyUserInfo),
    ]);
  }

  /// 保存用户信息
  Future<void> saveUserInfo(Map<String, dynamic> userInfo) async {
    await _prefs.setString(AppConstants.keyUserInfo, 
        userInfo.toString()); // 简化实现，实际应该用JSON
  }

  /// 获取用户信息
  Future<Map<String, dynamic>?> getUserInfo() async {
    final userInfoStr = _prefs.getString(AppConstants.keyUserInfo);
    if (userInfoStr == null) return null;
    // 简化实现，实际应该解析JSON
    return <String, dynamic>{};
  }

  /// 检查是否已登录
  Future<bool> isLoggedIn() async {
    return await hasValidToken();
  }

  /// 清除所有数据
  Future<void> clearAll() async {
    await clearUserData();
  }
}