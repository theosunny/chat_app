import 'package:dartz/dartz.dart';
import '../../entities/bottle.dart';
import '../../repositories/bottle_repository.dart';
import '../../../core/errors/failures.dart';
import '../usecase.dart';

/// 捡取漂流瓶用例
class PickBottleUseCase implements UseCase<Bottle, PickBottleParams> {
  final BottleRepository repository;
  
  PickBottleUseCase(this.repository);
  
  @override
  Future<Either<Failure, Bottle>> call(PickBottleParams params) async {
    // 验证参数
    final validationResult = _validateParams(params);
    if (validationResult != null) {
      return Left(ValidationFailure(validationResult));
    }
    
    // 执行捡取
    return await repository.pickBottle(
      bottleId: params.bottleId,
      latitude: params.latitude,
      longitude: params.longitude,
    );
  }
  
  /// 验证参数
  String? _validateParams(PickBottleParams params) {
    // 验证漂流瓶ID
    if (params.bottleId.trim().isEmpty) {
      return '漂流瓶ID不能为空';
    }
    
    // 验证位置信息
    if (params.latitude < -90 || params.latitude > 90) {
      return '纬度范围必须在-90到90之间';
    }
    if (params.longitude < -180 || params.longitude > 180) {
      return '经度范围必须在-180到180之间';
    }
    
    return null;
  }
}

/// 捡取漂流瓶参数
class PickBottleParams {
  final String bottleId;
  final double latitude;
  final double longitude;
  
  const PickBottleParams({
    required this.bottleId,
    required this.latitude,
    required this.longitude,
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PickBottleParams &&
        other.bottleId == bottleId &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }
  
  @override
  int get hashCode => bottleId.hashCode ^ latitude.hashCode ^ longitude.hashCode;
  
  @override
  String toString() {
    return 'PickBottleParams(bottleId: $bottleId, latitude: $latitude, longitude: $longitude)';
  }
  
  PickBottleParams copyWith({
    String? bottleId,
    double? latitude,
    double? longitude,
  }) {
    return PickBottleParams(
      bottleId: bottleId ?? this.bottleId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}