import 'package:dartz/dartz.dart';
import '../../entities/bottle.dart';
import '../../repositories/bottle_repository.dart';
import '../../../core/errors/failures.dart';
import '../usecase.dart';

/// 获取漂流瓶列表用例
class GetBottlesUseCase implements UseCase<List<Bottle>, GetBottlesParams> {
  final BottleRepository repository;
  
  GetBottlesUseCase(this.repository);
  
  @override
  Future<Either<Failure, List<Bottle>>> call(GetBottlesParams params) async {
    // 验证参数
    final validationResult = _validateParams(params);
    if (validationResult != null) {
      return Left(Failure.validation(message: validationResult));
    }
    
    // 根据类型获取漂流瓶
    switch (params.type) {
      case BottleListType.nearby:
        return await repository.getNearbyBottles(
          latitude: params.latitude!,
          longitude: params.longitude!,
          radius: params.radius,
          limit: params.limit,
        );
      case BottleListType.sent:
        return await repository.getMySentBottles(
          limit: params.limit,
        );
      case BottleListType.picked:
        return await repository.getMyPickedBottles(
          limit: params.limit,
        );
      case BottleListType.favorites:
        return await repository.getMyFavoriteBottles(
          limit: params.limit,
        );
      case BottleListType.hot:
        return await repository.getTrendingBottles(
          limit: params.limit,
          timeRange: 'day',
        );
      case BottleListType.recommended:
        return await repository.getRecommendedBottles(
          limit: params.limit,
          offset: params.offset,
        );
    }
  }
  
  /// 验证参数
  String? _validateParams(GetBottlesParams params) {
    // 验证分页参数
    if (params.limit <= 0) {
      return '每页数量必须大于0';
    }
    if (params.limit > 100) {
      return '每页数量不能超过100';
    }
    if (params.offset < 0) {
      return '偏移量不能小于0';
    }
    
    // 验证位置参数（附近漂流瓶需要）
    if (params.type == BottleListType.nearby) {
      if (params.latitude == null || params.longitude == null) {
        return '获取附近漂流瓶需要提供位置信息';
      }
      if (params.latitude! < -90 || params.latitude! > 90) {
        return '纬度范围必须在-90到90之间';
      }
      if (params.longitude! < -180 || params.longitude! > 180) {
        return '经度范围必须在-180到180之间';
      }
      if (params.radius != null && params.radius! <= 0) {
        return '搜索半径必须大于0';
      }
    }
    
    return null;
  }
}

/// 获取漂流瓶参数
class GetBottlesParams {
  final BottleListType type;
  final int limit;
  final int offset;
  final double? latitude;
  final double? longitude;
  final double? radius; // 搜索半径（米）
  
  const GetBottlesParams({
    required this.type,
    this.limit = 20,
    this.offset = 0,
    this.latitude,
    this.longitude,
    this.radius,
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GetBottlesParams &&
        other.type == type &&
        other.limit == limit &&
        other.offset == offset &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.radius == radius;
  }
  
  @override
  int get hashCode {
    return type.hashCode ^
        limit.hashCode ^
        offset.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        radius.hashCode;
  }
  
  @override
  String toString() {
    return 'GetBottlesParams(type: $type, limit: $limit, offset: $offset, latitude: $latitude, longitude: $longitude, radius: $radius)';
  }
  
  GetBottlesParams copyWith({
    BottleListType? type,
    int? limit,
    int? offset,
    double? latitude,
    double? longitude,
    double? radius,
  }) {
    return GetBottlesParams(
      type: type ?? this.type,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radius: radius ?? this.radius,
    );
  }
}

/// 漂流瓶列表类型
enum BottleListType {
  /// 附近的漂流瓶
  nearby,
  
  /// 我发送的漂流瓶
  sent,
  
  /// 我捡到的漂流瓶
  picked,
  
  /// 我收藏的漂流瓶
  favorites,
  
  /// 热门漂流瓶
  hot,
  
  /// 推荐漂流瓶
  recommended,
}

/// 漂流瓶列表类型扩展
extension BottleListTypeExtension on BottleListType {
  String get displayText {
    switch (this) {
      case BottleListType.nearby:
        return '附近';
      case BottleListType.sent:
        return '我发送的';
      case BottleListType.picked:
        return '我捡到的';
      case BottleListType.favorites:
        return '我收藏的';
      case BottleListType.hot:
        return '热门';
      case BottleListType.recommended:
        return '推荐';
    }
  }
  
  String get description {
    switch (this) {
      case BottleListType.nearby:
        return '查看附近的漂流瓶';
      case BottleListType.sent:
        return '查看我发送的漂流瓶';
      case BottleListType.picked:
        return '查看我捡到的漂流瓶';
      case BottleListType.favorites:
        return '查看我收藏的漂流瓶';
      case BottleListType.hot:
        return '查看热门漂流瓶';
      case BottleListType.recommended:
        return '查看推荐漂流瓶';
    }
  }
  
  bool get requiresLocation => this == BottleListType.nearby;
}