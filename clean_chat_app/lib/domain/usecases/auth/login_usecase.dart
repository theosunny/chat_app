import 'package:dartz/dartz.dart';
import '../../entities/user.dart';
import '../../repositories/user_repository.dart';
import '../../../core/error/failures.dart';
import '../usecase.dart';

/// 登录用例参数
class LoginParams {
  final String username;
  final String password;

  const LoginParams({
    required this.username,
    required this.password,
  });
}

/// 登录用例
class LoginUseCase implements UseCase<User, LoginParams> {
  final UserRepository repository;

  const LoginUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    // 验证输入参数
    if (params.username.isEmpty) {
      return const Left(ValidationFailure('用户名不能为空'));
    }
    
    if (params.password.isEmpty) {
      return const Left(ValidationFailure('密码不能为空'));
    }
    
    if (params.password.length < 6) {
      return const Left(ValidationFailure('密码长度不能少于6位'));
    }

    // 执行登录
    final result = await repository.login(
      username: params.username,
      password: params.password,
    );

    // 登录成功后保存用户信息到本地
    return result.fold(
      (failure) => Left(failure),
      (user) async {
        await repository.saveUserToLocal(user);
        return Right(user);
      },
    );
  }
}