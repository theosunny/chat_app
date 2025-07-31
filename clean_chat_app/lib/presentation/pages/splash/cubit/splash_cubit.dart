import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../domain/usecases/user/get_current_user_usecase.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  SplashCubit(this._getCurrentUserUseCase) : super(SplashInitial());

  Future<void> checkAuthStatus() async {
    emit(SplashLoading());
    
    // 添加一个短暂的延迟以显示启动画面
    await Future.delayed(const Duration(seconds: 2));
    
    final result = await _getCurrentUserUseCase(NoParams());
    
    result.fold(
      (failure) => emit(SplashUnauthenticated()),
      (user) => emit(SplashAuthenticated()),
    );
  }
}