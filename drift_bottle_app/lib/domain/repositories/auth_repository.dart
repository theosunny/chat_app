import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../../core/errors/failures.dart';

/// 认证仓库接口
abstract class AuthRepository {
  /// 登录
  Future<Either<Failure, User>> login({
    required String username,
    required String password,
  });
  
  /// 手机号登录
  Future<Either<Failure, User>> loginWithPhone({
    required String phone,
    required String verificationCode,
  });
  
  /// 第三方登录
  Future<Either<Failure, User>> loginWithThirdParty({
    required String provider,
    required String accessToken,
    Map<String, dynamic>? extra,
  });
  
  /// 注册
  Future<Either<Failure, User>> register({
    required String username,
    required String password,
    required String email,
    String? phone,
    String? nickname,
  });
  
  /// 发送验证码
  Future<Either<Failure, void>> sendVerificationCode({
    required String phone,
    required String type, // 'login', 'register', 'reset_password'
  });
  
  /// 验证验证码
  Future<Either<Failure, bool>> verifyCode({
    required String phone,
    required String code,
    required String type,
  });
  
  /// 重置密码
  Future<Either<Failure, void>> resetPassword({
    required String phone,
    required String verificationCode,
    required String newPassword,
  });
  
  /// 修改密码
  Future<Either<Failure, void>> changePassword({
    required String oldPassword,
    required String newPassword,
  });
  
  /// 登出
  Future<Either<Failure, void>> logout();
  
  /// 刷新令牌
  Future<Either<Failure, String>> refreshToken();
  
  /// 获取当前用户信息
  Future<Either<Failure, User?>> getCurrentUser();
  
  /// 更新用户信息
  Future<Either<Failure, User>> updateUserProfile({
    String? nickname,
    String? avatar,
    String? bio,
    int? gender,
    DateTime? birthday,
    UserLocation? location,
    UserSettings? settings,
  });
  
  /// 上传头像
  Future<Either<Failure, String>> uploadAvatar(String filePath);
  
  /// 检查用户名是否可用
  Future<Either<Failure, bool>> checkUsernameAvailable(String username);
  
  /// 检查邮箱是否可用
  Future<Either<Failure, bool>> checkEmailAvailable(String email);
  
  /// 检查手机号是否可用
  Future<Either<Failure, bool>> checkPhoneAvailable(String phone);
  
  /// 绑定手机号
  Future<Either<Failure, void>> bindPhone({
    required String phone,
    required String verificationCode,
  });
  
  /// 绑定邮箱
  Future<Either<Failure, void>> bindEmail({
    required String email,
    required String verificationCode,
  });
  
  /// 解绑手机号
  Future<Either<Failure, void>> unbindPhone({
    required String verificationCode,
  });
  
  /// 解绑邮箱
  Future<Either<Failure, void>> unbindEmail({
    required String verificationCode,
  });
  
  /// 注销账户
  Future<Either<Failure, void>> deleteAccount({
    required String password,
    String? reason,
  });
  
  /// 获取用户设置
  Future<Either<Failure, UserSettings>> getUserSettings();
  
  /// 更新用户设置
  Future<Either<Failure, UserSettings>> updateUserSettings(UserSettings settings);
  
  /// 获取隐私设置
  Future<Either<Failure, UserPrivacySettings>> getPrivacySettings();
  
  /// 更新隐私设置
  Future<Either<Failure, UserPrivacySettings>> updatePrivacySettings(UserPrivacySettings settings);
  
  /// 获取漂流瓶设置
  Future<Either<Failure, BottleSettings>> getBottleSettings();
  
  /// 更新漂流瓶设置
  Future<Either<Failure, BottleSettings>> updateBottleSettings(BottleSettings settings);
  
  /// 检查是否已登录
  Future<bool> isLoggedIn();
  
  /// 获取访问令牌
  Future<String?> getAccessToken();
  
  /// 获取刷新令牌
  Future<String?> getRefreshToken();
  
  /// 清除本地认证数据
  Future<void> clearAuthData();
  
  /// 监听认证状态变化
  Stream<User?> get authStateChanges;
  
  /// 监听用户信息变化
  Stream<User?> get userChanges;
}