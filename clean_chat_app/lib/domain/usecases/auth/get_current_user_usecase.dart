import 'package:dartz/dartz.dart';
import '../../entities/user.dart';
import '../../repositories/user_repository.dart';
import '../../../core/error/failures.dart';
import '../usecase.dart';

/// 获取当前用户用例
class GetCurrentUserUseCase implements NoParamsUseCase<User?> {
  final UserRepository repository;

  const GetCurrentUserUseCase(this.repository);

  @override
  Future<Either<Failure, User?>> call() async {
    // 首先尝试从本地获取用户信息
    final localResult = await repository.getUserFromLocal();
    
    return localResult.fold(
      (failure) async {
        // 本地获取失败，尝试从远程获取
        return await repository.getCurrentUser();
      },
      (localUser) async {
        if (localUser != null) {
          // 本地有用户信息，返回本地用户
          return Right(localUser);
        } else {
          // 本地没有用户信息，尝试从远程获取
          final remoteResult = await repository.getCurrentUser();
          return remoteResult.fold(
            (failure) => Left(failure),
            (remoteUser) async {
              // 远程获取成功，保存到本地
              if (remoteUser != null) {
                await repository.saveUserToLocal(remoteUser);
              }
              return Right(remoteUser);
            },
          );
        }
      },
    );
  }
}