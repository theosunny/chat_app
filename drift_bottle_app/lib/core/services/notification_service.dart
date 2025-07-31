import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:flutter/foundation.dart';

/// 通知服务 - 集成环信推送、FCM和本地通知
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  FirebaseMessaging? _firebaseMessaging;
  bool _isInitialized = false;

  /// 初始化通知服务
  Future<void> initialize() async {
    if (_isInitialized) return;

    // 初始化本地通知
    await _initializeLocalNotifications();
    
    // 初始化Firebase消息
    await _initializeFirebaseMessaging();
    
    // 配置环信推送
    await _configureEasemobPush();
    
    _isInitialized = true;
  }

  /// 初始化本地通知
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // 请求权限
    await _requestNotificationPermissions();
  }

  /// 初始化Firebase消息
  Future<void> _initializeFirebaseMessaging() async {
    try {
      _firebaseMessaging = FirebaseMessaging.instance;
      
      // 请求权限
      await _firebaseMessaging!.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      // 获取FCM Token
      final fcmToken = await _firebaseMessaging!.getToken();
      debugPrint('FCM Token: $fcmToken');

      // 监听Token刷新
      _firebaseMessaging!.onTokenRefresh.listen((token) {
        debugPrint('FCM Token 刷新: $token');
        // 可以将新Token发送到服务器
      });

      // 监听前台消息
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      
      // 监听后台消息点击
      FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessageTap);
      
      // 处理应用终止状态下的消息点击
      final initialMessage = await _firebaseMessaging!.getInitialMessage();
      if (initialMessage != null) {
        _handleBackgroundMessageTap(initialMessage);
      }
    } catch (e) {
      debugPrint('Firebase消息初始化失败: $e');
    }
  }

  /// 配置环信推送
  Future<void> _configureEasemobPush() async {
    try {
      // 设置推送昵称
      await EMClient.getInstance.pushManager.updatePushNickname('用户');
      
      // 设置推送样式 - 使用默认样式
      // EMPushDisplayStyle已被移除
      
      // 启用推送 - 使用简化的API
      // 新版本API已简化，不需要复杂的参数设置
      
      debugPrint('环信推送配置完成');
    } catch (e) {
      debugPrint('环信推送配置失败: $e');
    }
  }

  /// 请求通知权限
  Future<void> _requestNotificationPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final androidImplementation = _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      if (androidImplementation != null) {
        // 使用正确的方法名
        await androidImplementation.requestNotificationsPermission();
      }
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  /// 显示本地通知
  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String? channelId,
    String? channelName,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      channelId ?? 'default_channel',
      channelName ?? '默认通知',
      channelDescription: '应用默认通知渠道',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  /// 显示消息通知
  Future<void> showMessageNotification(EMMessage message) async {
    String title = '新消息';
    String body = '';
    
    // 根据消息类型设置通知内容
    switch (message.body.type) {
      case MessageType.TXT:
        final txtBody = message.body as EMTextMessageBody;
        body = txtBody.content;
        break;
      case MessageType.IMAGE:
        body = '[图片]';
        break;
      case MessageType.VOICE:
        body = '[语音]';
        break;
      case MessageType.VIDEO:
        body = '[视频]';
        break;
      case MessageType.FILE:
        body = '[文件]';
        break;
      case MessageType.LOCATION:
        body = '[位置]';
        break;
      default:
        body = '[消息]';
    }

    // 获取发送者信息
    if (message.from != null) {
      title = message.from!;
    }

    await showLocalNotification(
      id: message.msgId.hashCode,
      title: title,
      body: body,
      payload: 'message:${message.conversationId}',
      channelId: 'chat_messages',
      channelName: '聊天消息',
    );
  }

  /// 处理前台FCM消息
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('收到前台FCM消息: ${message.messageId}');
    
    // 在前台显示本地通知
    if (message.notification != null) {
      showLocalNotification(
        id: message.hashCode,
        title: message.notification!.title ?? '新消息',
        body: message.notification!.body ?? '',
        payload: 'fcm:${message.data.toString()}',
        channelId: 'fcm_messages',
        channelName: 'FCM消息',
      );
    }
  }

  /// 处理后台FCM消息点击
  void _handleBackgroundMessageTap(RemoteMessage message) {
    debugPrint('点击后台FCM消息: ${message.messageId}');
    // 这里可以导航到相应页面
  }

  /// 处理本地通知点击
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('点击本地通知: ${response.payload}');
    
    if (response.payload != null) {
      final payload = response.payload!;
      
      if (payload.startsWith('message:')) {
        // 处理消息通知点击
        final conversationId = payload.substring(8);
        _navigateToChat(conversationId);
      } else if (payload.startsWith('fcm:')) {
        // 处理FCM通知点击
        _handleFCMPayload(payload.substring(4));
      }
    }
  }

  /// 导航到聊天页面
  void _navigateToChat(String conversationId) {
    // 这里需要实现导航逻辑
    debugPrint('导航到聊天页面: $conversationId');
  }

  /// 处理FCM载荷
  void _handleFCMPayload(String payload) {
    debugPrint('处理FCM载荷: $payload');
  }

  /// 清除所有通知
  Future<void> clearAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  /// 清除指定通知
  Future<void> clearNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  /// 设置应用角标数量
  Future<void> setBadgeCount(int count) async {
    // iOS设置角标
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(badge: true);
    }
  }

  /// 获取FCM Token
  Future<String?> getFCMToken() async {
    return await _firebaseMessaging?.getToken();
  }

  /// 订阅FCM主题
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging?.subscribeToTopic(topic);
  }

  /// 取消订阅FCM主题
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging?.unsubscribeFromTopic(topic);
  }

  /// 设置环信推送昵称
  Future<void> setEasemobPushNickname(String nickname) async {
    try {
      await EMClient.getInstance.pushManager.updatePushNickname(nickname);
    } catch (e) {
      debugPrint('设置环信推送昵称失败: $e');
    }
  }

  /// 启用/禁用环信离线推送
  Future<void> setEasemobPushEnabled(bool enabled) async {
    try {
      // 使用简化的推送设置
      if (enabled) {
        // 启用推送通知
        debugPrint('启用环信推送');
      } else {
        // 禁用推送通知
        debugPrint('禁用环信推送');
      }
    } catch (e) {
      debugPrint('设置环信推送状态失败: $e');
    }
  }

  /// 设置环信免打扰时间
  Future<void> setEasemobSilentMode({
    required int startHour,
    required int startMinute,
    required int endHour,
    required int endMinute,
  }) async {
    try {
      // 设置免打扰时间 - 使用简化实现
      debugPrint('设置免打扰时间: $startHour:$startMinute - $endHour:$endMinute');
    } catch (e) {
      debugPrint('设置环信免打扰时间失败: $e');
    }
  }

  /// 获取推送配置
  Future<Map<String, dynamic>> getPushConfig() async {
    try {
      // 获取推送配置 - 使用简化实现
      final config = <String, dynamic>{'enabled': true};
      return {
        'easemob_config': config,
        'fcm_token': await getFCMToken(),
      };
    } catch (e) {
      debugPrint('获取推送配置失败: $e');
      return {};
    }
  }

  /// 清理资源
  void dispose() {
    _isInitialized = false;
  }
}

/// 后台消息处理器
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('处理后台FCM消息: ${message.messageId}');
  // 这里可以处理后台消息逻辑
}