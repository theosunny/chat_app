import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../../core/error/failures.dart';

/// 用户仓库接口
abstract class UserRepository {
  /// 登录
  Future<Either<Failure, User>> login({
    required String username,
    required String password,
  });

  /// 注册
  Future<Either<Failure, User>> register({
    required String username,
    required String email,
    required String password,
    String? nickname,
  });

  /// 登出
  Future<Either<Failure, void>> logout();

  /// 获取当前用户
  Future<Either<Failure, User?>> getCurrentUser();

  /// 更新用户信息
  Future<Either<Failure, User>> updateProfile({
    String? nickname,
    String? bio,
    String? avatar,
  });

  /// 根据ID获取用户
  Future<Either<Failure, User>> getUserById(int userId);

  /// 搜索用户
  Future<Either<Failure, List<User>>> searchUsers(String query);

  /// 检查用户名是否可用
  Future<Either<Failure, bool>> checkUsernameAvailable(String username);

  /// 检查邮箱是否可用
  Future<Either<Failure, bool>> checkEmailAvailable(String email);

  /// 更新在线状态
  Future<Either<Failure, void>> updateOnlineStatus(bool isOnline);

  /// 获取用户列表
  Future<Either<Failure, List<User>>> getUsers({
    int page = 1,
    int limit = 20,
  });

  /// 保存用户到本地
  Future<Either<Failure, void>> saveUserToLocal(User user);

  /// 从本地获取用户
  Future<Either<Failure, User?>> getUserFromLocal();

  /// 清除本地用户数据
  Future<Either<Failure, void>> clearLocalUser();
}