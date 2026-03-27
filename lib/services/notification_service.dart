import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../user_panel/notification_screen.dart';

class NotificationService {
  //Global navigator key for navigation without context
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  // 1 Request notification permission (iOS & Android +)
  Future<void> requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: true,
    );
    if (kDebugMode) print('FCM Permission: ${settings.authorizationStatus}');

    if (Platform.isIOS) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  // 2 Get device token
  Future<String?> getDeviceToken() async {
    String? token = await _messaging.getToken();
    if (kDebugMode) print('FCM Token: $token');
    return token;
  }

  // 3 Listen for token refresh
  void listenTokenRefresh() {
    _messaging.onTokenRefresh.listen((newToken) {
      if (kDebugMode) print('New FCM Token: $newToken');
      // TODO: Send token to your backend
    });
  }

  // 4 Initialize local notifications (Updated for v21.0.0)
  Future<void> initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );


    // Android notification channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);


    await _localNotifications.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (kDebugMode) print('Notification tapped (foreground)');
        Map<String, dynamic> data = {};
        if (response.payload != null) {
          try {
            data = jsonDecode(response.payload!);
          } catch (_) {}
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          navigatorKey.currentState?.push(MaterialPageRoute(
            builder: (_) => NotificationScreen(message: RemoteMessage(data: data)),
          ));
        });
      },
    );
  }

  //5️5 Show local notification
  Future<void> showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      ticker: 'ticker',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _localNotifications.show(
      id: message.hashCode,
      title: message.notification?.title ?? 'No Title',
      body: message.notification?.body ?? 'No Body',
      notificationDetails: notificationDetails,
      payload: jsonEncode(message.data),
    );
  }

  // 6 Handle foreground
  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) print('Foreground message: ${message.notification?.title}');
      showNotification(message);
    });
  }

  // 7 iOS foreground presentation options
  Future<void> setIOSForegroundOptions() async {
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  // 8 Handle background & terminated messages
  Future<void> setupInteractMessage(BuildContext context) async {
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) handleMessage(initialMessage);
  }

  // 9 Navigation handler
  void handleMessage(RemoteMessage message) {
    if (kDebugMode) print('Message clicked: ${message.data}');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (_) => NotificationScreen(message: message),
      ));
    });
  }

  // 10 Initialize all notification services
  Future<void> init() async {
    await _messaging.setAutoInitEnabled(true);
    await requestPermission();
    await initLocalNotifications();
    await getDeviceToken();
    listenTokenRefresh();

  }


}