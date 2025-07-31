import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_model.dart';
import '../../../core/error/exceptions.dart';

/// 用户本地数据源接口
abstract class UserLocalDataSource {
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> clearUser();
  Future<void> saveAuthToken(String token);
  Future<String?> getAuthToken();
  Future<void> clearAuthToken();
  Future<void> saveUserList(List<UserModel> users);
  Future<List<UserModel>> getUserList();
  Future<void> clearUserList();
}

/// 用户本地数据源实现
class UserLocalDataSourceImpl implements UserLocalDataSource {
  final SharedPreferences sharedPreferences;
  final Box<Map<dynamic, dynamic>> userBox;
  final Box<List<dynamic>> userListBox;

  static const String _authTokenKey = 'auth_token';
  static const String _currentUserKey = 'current_user';
  static const String _userListKey = 'user_list';

  const UserLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.userBox,
    required this.userListBox,
  });

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      await userBox.put(_currentUserKey, user.toJson());
    } catch (e) {
      throw CacheException('保存用户信息失败: $e');
    }
  }

  @override
  Future<UserModel?> getUser() async {
    try {
      final userData = userBox.get(_currentUserKey);
      if (userData != null) {
        return UserModel.fromJson(Map<String, dynamic>.from(userData));
      }
      return null;
    } catch (e) {
      throw CacheException('获取用户信息失败: $e');
    }
  }

  @override
  Future<void> clearUser() async {
    try {
      await userBox.delete(_currentUserKey);
    } catch (e) {
      throw CacheException('清除用户信息失败: $e');
    }
  }

  @override
  Future<void> saveAuthToken(String token) async {
    try {
      await sharedPreferences.setString(_authTokenKey, token);
    } catch (e) {
      throw CacheException('保存认证令牌失败: $e');
    }
  }

  @override
  Future<String?> getAuthToken() async {
    try {
      return sharedPreferences.getString(_authTokenKey);
    } catch (e) {
      throw CacheException('获取认证令牌失败: $e');
    }
  }

  @override
  Future<void> clearAuthToken() async {
    try {
      await sharedPreferences.remove(_authTokenKey);
    } catch (e) {
      throw CacheException('清除认证令牌失败: $e');
    }
  }

  @override
  Future<void> saveUserList(List<UserModel> users) async {
    try {
      final userListData = users.map((user) => user.toJson()).toList();
      await userListBox.put(_userListKey, userListData);
    } catch (e) {
      throw CacheException('保存用户列表失败: $e');
    }
  }

  @override
  Future<List<UserModel>> getUserList() async {
    try {
      final userListData = userListBox.get(_userListKey);
      if (userListData != null) {
        return userListData
            .map((userData) => UserModel.fromJson(Map<String, dynamic>.from(userData)))
            .toList();
      }
      return [];
    } catch (e) {
      throw CacheException('获取用户列表失败: $e');
    }
  }

  @override
  Future<void> clearUserList() async {
    try {
      await userListBox.delete(_userListKey);
    } catch (e) {
      throw CacheException('清除用户列表失败: $e');
    }
  }
}