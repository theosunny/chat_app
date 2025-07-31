import 'package:dartz/dartz.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import '../datasources/remote/user_remote_datasource.dart';
import '../datasources/local/user_local_datasource.dart';
import '../models/user_model.dart';

/// 用户仓库实现
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;

  const UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, User>> login({
    required String username,
    required String password,
  }) async {
    try {
      final userModel = await remoteDataSource.login(username, password);
      
      // 保存用户信息到本地
      await localDataSource.saveUser(userModel);
      
      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String username,
    required String email,
    required String password,
    String? nickname,
  }) async {
    try {
      final userModel = await remoteDataSource.register(username, email, password, nickname);
      
      // 保存用户信息到本地
      await localDataSource.saveUser(userModel);
      
      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      
      // 清除本地数据
      await localDataSource.clearUser();
      await localDataSource.clearAuthToken();
      
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final userModel = await remoteDataSource.getCurrentUser();
      
      if (userModel != null) {
        // 保存到本地
        await localDataSource.saveUser(userModel);
        return Right(userModel.toEntity());
      }
      
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> updateUser({
    required int userId,
    String? nickname,
    String? avatar,
    String? bio,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      if (nickname != null) updateData['nickname'] = nickname;
      if (avatar != null) updateData['avatar'] = avatar;
      if (bio != null) updateData['bio'] = bio;
      
      final userModel = await remoteDataSource.updateUser(userId, updateData);
      
      // 更新本地数据
      await localDataSource.saveUser(userModel);
      
      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getUserById(int userId) async {
    try {
      final userModel = await remoteDataSource.getUserById(userId);
      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<User>>> searchUsers({
    required String query,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final userModels = await remoteDataSource.searchUsers(query, page, limit);
      final users = userModels.map((model) => model.toEntity()).toList();
      return Right(users);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkUsernameAvailability(String username) async {
    try {
      final isAvailable = await remoteDataSource.checkUsernameAvailability(username);
      return Right(isAvailable);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkEmailAvailability(String email) async {
    try {
      final isAvailable = await remoteDataSource.checkEmailAvailability(email);
      return Right(isAvailable);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateOnlineStatus(bool isOnline) async {
    try {
      await remoteDataSource.updateOnlineStatus(isOnline);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<User>>> getUsers({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final userModels = await remoteDataSource.getUsers(page, limit);
      final users = userModels.map((model) => model.toEntity()).toList();
      
      // 保存用户列表到本地
      await localDataSource.saveUserList(userModels);
      
      return Right(users);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveUserToLocal(User user) async {
    try {
      final userModel = UserModel.fromEntity(user);
      await localDataSource.saveUser(userModel);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getUserFromLocal() async {
    try {
      final userModel = await localDataSource.getUser();
      return Right(userModel?.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearUserFromLocal() async {
    try {
      await localDataSource.clearUser();
      await localDataSource.clearAuthToken();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on Exception catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}