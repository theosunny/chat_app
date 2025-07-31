import 'package:dartz/dartz.dart';
import '../../entities/user.dart';
import '../../repositories/user_repository.dart';
import '../../../core/error/failures.dart';
import '../usecase.dart';

/// 注册用例参数
class RegisterParams {
  final String username;
  final String email;
  final String password;
  final String? nickname;

  const RegisterParams({
    required this.username,
    required this.email,
    required this.password,
    this.nickname,
  });
}

/// 注册用例
class RegisterUseCase implements UseCase<User, RegisterParams> {
  final UserRepository repository;

  const RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(RegisterParams params) async {
    // 验证输入参数
    if (params.username.isEmpty) {
      return const Left(ValidationFailure('用户名不能为空'));
    }
    
    if (params.username.length < 3) {
      return const Left(ValidationFailure('用户名长度不能少于3位'));
    }
    
    if (params.email.isEmpty) {
      return const Left(ValidationFailure('邮箱不能为空'));
    }
    
    if (!_isValidEmail(params.email)) {
      return const Left(ValidationFailure('邮箱格式不正确'));
    }
    
    if (params.password.isEmpty) {
      return const Left(ValidationFailure('密码不能为空'));
    }
    
    if (params.password.length < 6) {
      return const Left(ValidationFailure('密码长度不能少于6位'));
    }

    // 检查用户名是否可用
    final usernameCheck = await repository.checkUsernameAvailability(params.username);
    final isUsernameAvailable = usernameCheck.fold(
      (failure) => false,
      (isAvailable) => isAvailable,
    );
    
    if (!isUsernameAvailable) {
      return const Left(ValidationFailure('用户名已被使用'));
    }

    // 检查邮箱是否可用
    final emailCheck = await repository.checkEmailAvailability(params.email);
    final isEmailAvailable = emailCheck.fold(
      (failure) => false,
      (isAvailable) => isAvailable,
    );
    
    if (!isEmailAvailable) {
      return const Left(ValidationFailure('邮箱已被使用'));
    }

    // 执行注册
    final result = await repository.register(
      username: params.username,
      email: params.email,
      password: params.password,
      nickname: params.nickname,
    );

    // 注册成功后保存用户信息到本地
    return result.fold(
      (failure) => Left(failure),
      (user) async {
        await repository.saveUserToLocal(user);
        return Right(user);
      },
    );
  }

  /// 验证邮箱格式
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}