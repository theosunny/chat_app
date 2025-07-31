import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';

/// 用例基类
abstract class UseCase<Type, Params> {
  /// 执行用例
  Future<Either<Failure, Type>> call(Params params);
}

/// 无参数用例基类
abstract class NoParamsUseCase<Type> {
  /// 执行用例
  Future<Either<Failure, Type>> call();
}

/// 流式用例基类
abstract class StreamUseCase<Type, Params> {
  /// 执行用例
  Stream<Either<Failure, Type>> call(Params params);
}

/// 无参数流式用例基类
abstract class NoParamsStreamUseCase<Type> {
  /// 执行用例
  Stream<Either<Failure, Type>> call();
}

/// 无返回值用例基类
abstract class VoidUseCase<Params> {
  /// 执行用例
  Future<Either<Failure, void>> call(Params params);
}

/// 无参数无返回值用例基类
abstract class NoParamsVoidUseCase {
  /// 执行用例
  Future<Either<Failure, void>> call();
}

/// 无参数标记类
class NoParams {
  const NoParams();
  
  @override
  bool operator ==(Object other) => other is NoParams;
  
  @override
  int get hashCode => 0;
}

/// 分页参数
class PaginationParams {
  final int page;
  final int limit;
  final String? cursor;
  
  const PaginationParams({
    this.page = 1,
    this.limit = 20,
    this.cursor,
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaginationParams &&
        other.page == page &&
        other.limit == limit &&
        other.cursor == cursor;
  }
  
  @override
  int get hashCode => page.hashCode ^ limit.hashCode ^ cursor.hashCode;
  
  @override
  String toString() {
    return 'PaginationParams(page: $page, limit: $limit, cursor: $cursor)';
  }
  
  PaginationParams copyWith({
    int? page,
    int? limit,
    String? cursor,
  }) {
    return PaginationParams(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      cursor: cursor ?? this.cursor,
    );
  }
}

/// 搜索参数
class SearchParams {
  final String keyword;
  final Map<String, dynamic>? filters;
  final String? sortBy;
  final bool ascending;
  final PaginationParams pagination;
  
  const SearchParams({
    required this.keyword,
    this.filters,
    this.sortBy,
    this.ascending = true,
    this.pagination = const PaginationParams(),
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SearchParams &&
        other.keyword == keyword &&
        other.filters == filters &&
        other.sortBy == sortBy &&
        other.ascending == ascending &&
        other.pagination == pagination;
  }
  
  @override
  int get hashCode {
    return keyword.hashCode ^
        filters.hashCode ^
        sortBy.hashCode ^
        ascending.hashCode ^
        pagination.hashCode;
  }
  
  @override
  String toString() {
    return 'SearchParams(keyword: $keyword, filters: $filters, sortBy: $sortBy, ascending: $ascending, pagination: $pagination)';
  }
  
  SearchParams copyWith({
    String? keyword,
    Map<String, dynamic>? filters,
    String? sortBy,
    bool? ascending,
    PaginationParams? pagination,
  }) {
    return SearchParams(
      keyword: keyword ?? this.keyword,
      filters: filters ?? this.filters,
      sortBy: sortBy ?? this.sortBy,
      ascending: ascending ?? this.ascending,
      pagination: pagination ?? this.pagination,
    );
  }
}

/// 位置参数
class LocationParams {
  final double latitude;
  final double longitude;
  final double? radius; // 半径（米）
  
  const LocationParams({
    required this.latitude,
    required this.longitude,
    this.radius,
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationParams &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.radius == radius;
  }
  
  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode ^ radius.hashCode;
  
  @override
  String toString() {
    return 'LocationParams(latitude: $latitude, longitude: $longitude, radius: $radius)';
  }
  
  LocationParams copyWith({
    double? latitude,
    double? longitude,
    double? radius,
  }) {
    return LocationParams(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radius: radius ?? this.radius,
    );
  }
}