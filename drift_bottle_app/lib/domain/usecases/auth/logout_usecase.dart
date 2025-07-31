import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../repositories/auth_repository.dart';
import '../../../core/errors/failures.dart';
import '../usecase.dart';

/// 登出用例
@lazySingleton
class LogoutUseCase implements UseCase<void, LogoutParams> {
  final AuthRepository repository;
  
  LogoutUseCase(this.repository);
  
  @override
  Future<Either<Failure, void>> call(LogoutParams params) async {
    return await repository.logout();
  }
}

/// 登出参数
class LogoutParams {
  final bool clearLocalData;
  final String? deviceId;
  
  const LogoutParams({
    this.clearLocalData = true,
    this.deviceId,
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LogoutParams &&
        other.clearLocalData == clearLocalData &&
        other.deviceId == deviceId;
  }
  
  @override
  int get hashCode => clearLocalData.hashCode ^ deviceId.hashCode;
  
  @override
  String toString() {
    return 'LogoutParams(clearLocalData: $clearLocalData, deviceId: $deviceId)';
  }
  
  LogoutParams copyWith({
    bool? clearLocalData,
    String? deviceId,
  }) {
    return LogoutParams(
      clearLocalData: clearLocalData ?? this.clearLocalData,
      deviceId: deviceId ?? this.deviceId,
    );
  }
}