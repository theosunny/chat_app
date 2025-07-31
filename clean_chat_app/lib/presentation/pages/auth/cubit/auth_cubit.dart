import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain/entities/user.dart';
import '../../../../domain/usecases/user/login_usecase.dart';
import '../../../../domain/usecases/user/register_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase? _loginUseCase;
  final RegisterUseCase? _registerUseCase;

  AuthCubit(this._loginUseCase, [this._registerUseCase]) : super(AuthInitial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    if (_loginUseCase == null) return;
    
    emit(AuthLoading());
    
    final result = await _loginUseCase!(LoginParams(
      email: email,
      password: password,
    ));
    
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    if (_registerUseCase == null) return;
    
    emit(AuthLoading());
    
    final result = await _registerUseCase!(RegisterParams(
      username: username,
      email: email,
      password: password,
    ));
    
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  void reset() {
    emit(AuthInitial());
  }
}