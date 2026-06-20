import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:odk_flutter_template/core/utils/log_utils.dart';
import 'package:odk_flutter_template/features/notification/models/push_message.dart';
import 'package:odk_flutter_template/routes/navigator_utils.dart';

typedef PushMessageCallback = void Function(PushMessage message);

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final StreamController<PushMessage> _messageStreamController =
      StreamController<PushMessage>.broadcast();

  Stream<PushMessage> get messageStream => _messageStreamController.stream;

  PushMessageCallback? onMessageReceived;

  final List<PushMessage> _localMessages = [];

  List<PushMessage> get messages => List.unmodifiable(_localMessages);

  int get unreadCount => _localMessages.where((m) => !m.isRead).length;

  bool _initialized = false;

  FlutterLocalNotificationsPlugin? _localNotificationsPlugin;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    try {
      await _initLocalNotifications();
    } catch (e, stack) {
      Log.e('NotificationService initialize failed: $e\n$stack');
    }
  }

  Future<void> _initLocalNotifications() async {
    _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/launcher_icon',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const macosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      macOS: macosSettings,
    );

    await _localNotificationsPlugin!.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    await _requestNotificationPermission();
  }

  Future<void> _requestNotificationPermission() async {
    if (_localNotificationsPlugin == null) return;

    // Android
    final android = _localNotificationsPlugin!
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      await android.requestNotificationsPermission();
    }

    // iOS
    final ios = _localNotificationsPlugin!
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (ios != null) {
      await ios.requestPermissions(alert: true, badge: true, sound: true);
    }

    // macOS
    final macos = _localNotificationsPlugin!
        .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin
        >();
    if (macos != null) {
      await macos.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  void _handleMessage(PushMessage message) {
    _localMessages.insert(0, message);
    _messageStreamController.add(message);

    if (onMessageReceived != null) {
      onMessageReceived!(message);
    }
  }

  void _showSystemNotification(PushMessage message) async {
    if (_localNotificationsPlugin == null) return;

    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      '默认通知',
      channelDescription: '应用通知',
      importance: Importance.high,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('default'),
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      sound: 'default',
      presentBadge: true,
      presentAlert: true,
      presentSound: true,
    );

    const macosDetails = DarwinNotificationDetails(
      sound: 'default',
      presentBadge: true,
      presentAlert: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      macOS: macosDetails,
    );

    final id = int.tryParse(message.messageId ?? '0');
    final safeId = (id ?? 0) % 2147483647;

    await _localNotificationsPlugin!.show(
      safeId,
      message.title,
      message.body,
      notificationDetails,
      payload: message.routePath ?? message.data?['routePath'] ?? '',
    );
  }

  void _onNotificationTapped(NotificationResponse response) {
    final payload = response.payload;
    if (payload != null && payload.isNotEmpty) {
      NavigatorUtils.push(payload);
    }
  }

  void handleForegroundMessage(Map<String, dynamic> messageData) {
    final message = PushMessage.fromFirebaseMessage(messageData);
    _handleMessage(message);
    _showSystemNotification(message);
  }

  void handleBackgroundMessage(Map<String, dynamic> messageData) {
    final message = PushMessage.fromFirebaseMessage(messageData);
    _handleMessage(message);
    _showSystemNotification(message);
    _handleNavigation(message);
  }

  void _handleNavigation(PushMessage message) {
    final routePath = message.routePath ?? message.data?['routePath'];
    if (routePath != null && routePath.isNotEmpty) {
      NavigatorUtils.push(routePath);
    }
  }

  void markAsRead(String messageId) {
    final index = _localMessages.indexWhere((m) => m.messageId == messageId);
    if (index != -1) {
      _localMessages[index] = _localMessages[index].copyWith(isRead: true);
    }
  }

  void clearMessages() {
    _localMessages.clear();
  }

  Future<String?> getToken() async {
    return null;
  }

  Future<void> deleteToken() async {}

  void dispose() {
    _messageStreamController.close();
  }

  void simulatePush({
    String? title,
    String? body,
    PushMessageType? type = PushMessageType.system,
    Map<String, dynamic>? data,
  }) {
    final message = PushMessage(
      messageId: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title ?? '测试通知',
      body: body ?? '这是一条测试推送消息',
      type: type,
      data: data,
      sendTime: DateTime.now().millisecondsSinceEpoch.toString(),
      isRead: false,
    );
    _handleMessage(message);
    _showSystemNotification(message);
  }
}
