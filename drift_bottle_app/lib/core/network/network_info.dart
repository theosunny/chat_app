import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

/// 网络信息接口
abstract class NetworkInfo {
  /// 检查是否有网络连接
  Future<bool> get isConnected;
  
  /// 获取连接类型
  Future<ConnectivityResult> get connectionType;
  
  /// 监听网络状态变化
  Stream<ConnectivityResult> get onConnectivityChanged;
  
  /// 检查是否有互联网连接（实际能访问网络）
  Future<bool> get hasInternetConnection;
  
  /// 检查是否为移动网络
  Future<bool> get isMobileConnection;
  
  /// 检查是否为WiFi网络
  Future<bool> get isWifiConnection;
  
  /// 检查是否为以太网连接
  Future<bool> get isEthernetConnection;
}

/// 网络信息实现
@LazySingleton(as: NetworkInfo)
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;
  final InternetConnectionChecker _internetChecker;
  
  NetworkInfoImpl(
    this._connectivity,
    this._internetChecker,
  );
  
  @override
  Future<bool> get isConnected async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
  
  @override
  Future<ConnectivityResult> get connectionType async {
    return await _connectivity.checkConnectivity();
  }
  
  @override
  Stream<ConnectivityResult> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged;
  }
  
  @override
  Future<bool> get hasInternetConnection async {
    try {
      // 首先检查基本连接
      if (!await isConnected) {
        return false;
      }
      
      // 然后检查实际的互联网连接
      return await _internetChecker.hasConnection;
    } catch (e) {
      return false;
    }
  }
  
  @override
  Future<bool> get isMobileConnection async {
    final connectivityResult = await connectionType;
    return connectivityResult == ConnectivityResult.mobile;
  }
  
  @override
  Future<bool> get isWifiConnection async {
    final connectivityResult = await connectionType;
    return connectivityResult == ConnectivityResult.wifi;
  }
  
  @override
  Future<bool> get isEthernetConnection async {
    final connectivityResult = await connectionType;
    return connectivityResult == ConnectivityResult.ethernet;
  }
}

/// 网络状态扩展
extension ConnectivityResultExtension on ConnectivityResult {
  /// 是否有连接
  bool get hasConnection => this != ConnectivityResult.none;
  
  /// 连接类型名称
  String get name {
    switch (this) {
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.mobile:
        return '移动网络';
      case ConnectivityResult.ethernet:
        return '以太网';
      case ConnectivityResult.vpn:
        return 'VPN';
      case ConnectivityResult.bluetooth:
        return '蓝牙';
      case ConnectivityResult.other:
        return '其他';
      case ConnectivityResult.none:
        return '无连接';
    }
  }
  
  /// 连接类型图标
  String get icon {
    switch (this) {
      case ConnectivityResult.wifi:
        return '📶';
      case ConnectivityResult.mobile:
        return '📱';
      case ConnectivityResult.ethernet:
        return '🔌';
      case ConnectivityResult.vpn:
        return '🔒';
      case ConnectivityResult.bluetooth:
        return '🔵';
      case ConnectivityResult.other:
        return '🌐';
      case ConnectivityResult.none:
        return '❌';
    }
  }
  
  /// 是否为高速连接
  bool get isHighSpeed {
    switch (this) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.ethernet:
        return true;
      case ConnectivityResult.mobile:
      case ConnectivityResult.vpn:
      case ConnectivityResult.bluetooth:
      case ConnectivityResult.other:
      case ConnectivityResult.none:
        return false;
    }
  }
  
  /// 是否为计费连接
  bool get isMetered {
    switch (this) {
      case ConnectivityResult.mobile:
        return true;
      case ConnectivityResult.wifi:
      case ConnectivityResult.ethernet:
      case ConnectivityResult.vpn:
      case ConnectivityResult.bluetooth:
      case ConnectivityResult.other:
      case ConnectivityResult.none:
        return false;
    }
  }
}

/// 网络状态监听器
class NetworkStatusListener {
  final NetworkInfo _networkInfo;
  ConnectivityResult? _lastConnectivityResult;
  bool? _lastInternetStatus;
  
  NetworkStatusListener(this._networkInfo);
  
  /// 开始监听网络状态
  Stream<NetworkStatus> startListening() async* {
    // 获取初始状态
    final initialConnectivity = await _networkInfo.connectionType;
    final initialInternet = await _networkInfo.hasInternetConnection;
    
    _lastConnectivityResult = initialConnectivity;
    _lastInternetStatus = initialInternet;
    
    yield NetworkStatus(
      connectivityResult: initialConnectivity,
      hasInternet: initialInternet,
      isConnected: initialConnectivity.hasConnection,
    );
    
    // 监听连接状态变化
    await for (final connectivityResult in _networkInfo.onConnectivityChanged) {
      final hasInternet = await _networkInfo.hasInternetConnection;
      
      // 只有状态真正改变时才发出事件
      if (connectivityResult != _lastConnectivityResult ||
          hasInternet != _lastInternetStatus) {
        _lastConnectivityResult = connectivityResult;
        _lastInternetStatus = hasInternet;
        
        yield NetworkStatus(
          connectivityResult: connectivityResult,
          hasInternet: hasInternet,
          isConnected: connectivityResult.hasConnection,
        );
      }
    }
  }
}

/// 网络状态数据类
class NetworkStatus {
  final ConnectivityResult connectivityResult;
  final bool hasInternet;
  final bool isConnected;
  
  const NetworkStatus({
    required this.connectivityResult,
    required this.hasInternet,
    required this.isConnected,
  });
  
  /// 是否为在线状态
  bool get isOnline => isConnected && hasInternet;
  
  /// 是否为离线状态
  bool get isOffline => !isOnline;
  
  /// 连接质量
  NetworkQuality get quality {
    if (!isOnline) return NetworkQuality.none;
    
    if (connectivityResult.isHighSpeed) {
      return NetworkQuality.high;
    } else if (connectivityResult == ConnectivityResult.mobile) {
      return NetworkQuality.medium;
    } else {
      return NetworkQuality.low;
    }
  }
  
  @override
  String toString() {
    return 'NetworkStatus(connectivity: ${connectivityResult.name}, '
        'hasInternet: $hasInternet, isConnected: $isConnected)';
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is NetworkStatus &&
        other.connectivityResult == connectivityResult &&
        other.hasInternet == hasInternet &&
        other.isConnected == isConnected;
  }
  
  @override
  int get hashCode {
    return connectivityResult.hashCode ^
        hasInternet.hashCode ^
        isConnected.hashCode;
  }
}

/// 网络质量枚举
enum NetworkQuality {
  none,
  low,
  medium,
  high,
}

/// 网络质量扩展
extension NetworkQualityExtension on NetworkQuality {
  String get name {
    switch (this) {
      case NetworkQuality.none:
        return '无网络';
      case NetworkQuality.low:
        return '网络较慢';
      case NetworkQuality.medium:
        return '网络一般';
      case NetworkQuality.high:
        return '网络良好';
    }
  }
  
  String get icon {
    switch (this) {
      case NetworkQuality.none:
        return '❌';
      case NetworkQuality.low:
        return '🔴';
      case NetworkQuality.medium:
        return '🟡';
      case NetworkQuality.high:
        return '🟢';
    }
  }
  
  /// 建议的操作
  String get suggestion {
    switch (this) {
      case NetworkQuality.none:
        return '请检查网络连接';
      case NetworkQuality.low:
        return '网络较慢，建议切换到WiFi';
      case NetworkQuality.medium:
        return '网络一般，可能影响使用体验';
      case NetworkQuality.high:
        return '网络良好';
    }
  }
}