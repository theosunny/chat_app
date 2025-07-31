// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i973;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../data/datasources/auth_remote_datasource.dart' as _i1016;
import '../../data/datasources/bottle_remote_datasource.dart' as _i190;
import '../../data/datasources/message_remote_datasource.dart' as _i662;
import '../../data/datasources/moment_remote_datasource.dart' as _i688;
import '../../data/repositories/auth_repository_impl.dart' as _i895;
import '../../data/repositories/bottle_repository_impl.dart' as _i719;
import '../../data/repositories/message_repository_impl.dart' as _i564;
import '../../data/repositories/moment_repository_impl.dart' as _i534;
import '../../domain/repositories/auth_repository.dart' as _i1073;
import '../../domain/repositories/bottle_repository.dart' as _i115;
import '../../domain/repositories/message_repository.dart' as _i761;
import '../../domain/repositories/moment_repository.dart' as _i785;
import '../../domain/usecases/auth/change_password_usecase.dart' as _i157;
import '../../domain/usecases/auth/login_usecase.dart' as _i461;
import '../../domain/usecases/auth/logout_usecase.dart' as _i320;
import '../../domain/usecases/auth/register_usecase.dart' as _i659;
import '../../domain/usecases/conversation/get_conversations_usecase.dart'
    as _i140;
import '../network/dio_client.dart' as _i667;
import '../network/network_info.dart' as _i932;
import '../storage/token_storage.dart' as _i973;
import 'injection.dart' as _i464;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i895.Connectivity>(() => registerModule.connectivity);
    gh.lazySingleton<_i973.InternetConnectionChecker>(
        () => registerModule.internetConnectionChecker);
    await gh.lazySingletonAsync<_i460.SharedPreferences>(
      () => registerModule.sharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i973.TokenStorage>(
        () => _i973.TokenStorage(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i667.DioClient>(
        () => _i667.DioClient(gh<_i973.TokenStorage>()));
    gh.lazySingleton<_i662.MessageRemoteDataSource>(
        () => _i662.MessageRemoteDataSourceImpl(gh<_i667.DioClient>()));
    gh.lazySingleton<_i190.BottleRemoteDataSource>(
        () => _i190.BottleRemoteDataSourceImpl(gh<_i667.DioClient>()));
    gh.lazySingleton<_i688.MomentRemoteDataSource>(
        () => _i688.MomentRemoteDataSourceImpl(gh<_i667.DioClient>()));
    gh.lazySingleton<_i785.MomentRepository>(
        () => _i534.MomentRepositoryImpl(gh<_i688.MomentRemoteDataSource>()));
    gh.lazySingleton<_i932.NetworkInfo>(() => _i932.NetworkInfoImpl(
          gh<_i895.Connectivity>(),
          gh<_i973.InternetConnectionChecker>(),
        ));
    gh.lazySingleton<_i1016.AuthRemoteDataSource>(
        () => _i1016.AuthRemoteDataSourceImpl(gh<_i667.DioClient>()));
    gh.lazySingleton<_i115.BottleRepository>(() => _i719.BottleRepositoryImpl(
          gh<_i190.BottleRemoteDataSource>(),
          gh<_i932.NetworkInfo>(),
        ));
    gh.lazySingleton<_i761.MessageRepository>(() => _i564.MessageRepositoryImpl(
          gh<_i662.MessageRemoteDataSource>(),
          gh<_i932.NetworkInfo>(),
        ));
    gh.lazySingleton<_i1073.AuthRepository>(() => _i895.AuthRepositoryImpl(
          gh<_i1016.AuthRemoteDataSource>(),
          gh<_i932.NetworkInfo>(),
          gh<_i973.TokenStorage>(),
        ));
    gh.lazySingleton<_i140.GetConversationsUseCase>(
        () => _i140.GetConversationsUseCase(gh<_i761.MessageRepository>()));
    gh.lazySingleton<_i157.ChangePasswordUseCase>(
        () => _i157.ChangePasswordUseCase(gh<_i1073.AuthRepository>()));
    gh.lazySingleton<_i461.LoginUseCase>(
        () => _i461.LoginUseCase(gh<_i1073.AuthRepository>()));
    gh.lazySingleton<_i320.LogoutUseCase>(
        () => _i320.LogoutUseCase(gh<_i1073.AuthRepository>()));
    gh.lazySingleton<_i659.RegisterUseCase>(
        () => _i659.RegisterUseCase(gh<_i1073.AuthRepository>()));
    return this;
  }
}

class _$RegisterModule extends _i464.RegisterModule {}
