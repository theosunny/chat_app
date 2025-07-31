import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';

/// 基础用例接口
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// 无参数用例接口
abstract class NoParamsUseCase<Type> {
  Future<Either<Failure, Type>> call();
}

/// 无参数类
class NoParams {
  const NoParams();
}