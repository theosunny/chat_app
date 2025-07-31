import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../../models/user_model.dart';

part 'user_remote_datasource.g.dart';

/// 用户远程数据源接口
abstract class UserRemoteDataSource {
  Future<UserModel> login(String username, String password);
  Future<UserModel> register(String username, String email, String password, String? nickname);
  Future<UserModel?> getCurrentUser();
  Future<UserModel> updateUser(int userId, Map<String, dynamic> data);
  Future<UserModel> getUserById(int userId);
  Future<List<UserModel>> searchUsers(String query, int page, int limit);
  Future<bool> checkUsernameAvailability(String username);
  Future<bool> checkEmailAvailability(String email);
  Future<void> updateOnlineStatus(bool isOnline);
  Future<List<UserModel>> getUsers(int page, int limit);
  Future<void> logout();
}

/// 用户远程数据源实现
@RestApi()
abstract class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  factory UserRemoteDataSourceImpl(Dio dio, {String baseUrl}) = _UserRemoteDataSourceImpl;

  @override
  @POST('/auth/login')
  Future<UserModel> login(
    @Field('username') String username,
    @Field('password') String password,
  );

  @override
  @POST('/auth/register')
  Future<UserModel> register(
    @Field('username') String username,
    @Field('email') String email,
    @Field('password') String password,
    @Field('nickname') String? nickname,
  );

  @override
  @GET('/auth/me')
  Future<UserModel?> getCurrentUser();

  @override
  @PUT('/users/{userId}')
  Future<UserModel> updateUser(
    @Path('userId') int userId,
    @Body() Map<String, dynamic> data,
  );

  @override
  @GET('/users/{userId}')
  Future<UserModel> getUserById(@Path('userId') int userId);

  @override
  @GET('/users/search')
  Future<List<UserModel>> searchUsers(
    @Query('q') String query,
    @Query('page') int page,
    @Query('limit') int limit,
  );

  @override
  @GET('/users/check-username')
  Future<bool> checkUsernameAvailability(@Query('username') String username);

  @override
  @GET('/users/check-email')
  Future<bool> checkEmailAvailability(@Query('email') String email);

  @override
  @PUT('/users/online-status')
  Future<void> updateOnlineStatus(@Field('isOnline') bool isOnline);

  @override
  @GET('/users')
  Future<List<UserModel>> getUsers(
    @Query('page') int page,
    @Query('limit') int limit,
  );

  @override
  @POST('/auth/logout')
  Future<void> logout();
}