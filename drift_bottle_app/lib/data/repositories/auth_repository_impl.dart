import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../../core/storage/token_storage.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

/// 认证仓库实现 - 简化版，与后端API保持一致
@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;
  final TokenStorage _tokenStorage;
  
  AuthRepositoryImpl(
    this._remoteDataSource,
    this._networkInfo,
    this._tokenStorage,
  );
  
  @override
  Future<Either<Failure, void>> sendVerificationCode({
    required String phone,
    required String type,
  }) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure('网络连接失败，请检查网络设置'));
    }
    
    try {
      await _remoteDataSource.sendVerificationCode(phone: phone, type: type);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('发送验证码失败: $e'));
    }
  }
  
  @override
  Future<Either<Failure, User>> loginWithPhone({
    required String phone,
    required String verificationCode,
  }) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure('网络连接失败，请检查网络设置'));
    }
    
    try {
      final result = await _remoteDataSource.loginWithPhone(
        phone: phone,
        verificationCode: verificationCode,
      );
      
      final userModel = result['user'] as UserModel;
      final token = result['token'] as String;
      
      // 保存用户信息和令牌
      await _saveUserData(userModel);
      
      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('登录失败: $e'));
    }
  }
  
  @override
  Future<Either<Failure, User>> loginWithThirdParty({
    required String provider,
    required String code,
  }) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure('网络连接失败，请检查网络设置'));
    }
    
    try {
      final result = await _remoteDataSource.loginWithThirdParty(
        provider: provider,
        code: code,
      );
      
      final userModel = result['user'] as UserModel;
      final token = result['token'] as String;
      
      // 保存用户信息和令牌
      await _saveUserData(userModel);
      
      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('第三方登录失败: $e'));
    }
  }
  
  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      // 首先尝试从本地获取用户信息
      final userInfo = await _tokenStorage.getUserInfo();
      if (userInfo != null) {
        final userModel = UserModel.fromJson(userInfo);
        return Right(userModel.toEntity());
      }
      
      // 如果本地没有，从服务器获取
      if (!await _networkInfo.isConnected) {
        return Left(NetworkFailure('网络连接失败，请检查网络设置'));
      }
      
      final userModel = await _remoteDataSource.getCurrentUser();
      
      // 保存到本地
      await _tokenStorage.saveUserInfo(userModel.toJson());
      
      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('获取用户信息失败: $e'));
    }
  }
  
  @override
  Future<Either<Failure, User>> updateUserProfile({
    String? nickname,
    String? avatar,
    String? bio,
    int? gender,
    DateTime? birthday,
    UserLocation? location,
    UserSettings? settings,
  }) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure('网络连接失败，请检查网络设置'));
    }
    
    try {
      final userModel = await _remoteDataSource.updateProfile(
        nickname: nickname,
        avatar: avatar,
        signature: bio,
        gender: gender?.toString(),
        age: birthday != null ? DateTime.now().year - birthday.year : null,
        location: location?.toString(),
      );
      
      // 更新本地用户信息
      await _tokenStorage.saveUserInfo(userModel.toJson());
      
      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('更新用户信息失败: $e'));
    }
  }
  
  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // 清除本地数据
      await _tokenStorage.clearAll();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('登出失败: $e'));
    }
  }
  
  @override
  Future<bool> isLoggedIn() async {
    return await _tokenStorage.isLoggedIn();
  }
  
  @override
  Future<String?> getAccessToken() async {
    return await _tokenStorage.getAccessToken();
  }
  
  @override
  Future<void> clearAuthData() async {
    await _tokenStorage.clearAll();
  }
  
  /// 保存用户数据到本地
  Future<void> _saveUserData(UserModel userModel) async {
    await Future.wait([
      _tokenStorage.saveUserId(userModel.id.toString()),
      _tokenStorage.saveUserInfo(userModel.toJson()),
      if (userModel.accessToken != null)
        _tokenStorage.saveAccessToken(userModel.accessToken!),
    ]);
  }
}