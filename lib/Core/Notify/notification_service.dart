import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../Controller/Dashboard/dashboard_controller.dart';

/// 🔹 Top-level background handler (required by Firebase)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("🌙 Background FCM: ${message.data}");
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Initialize both FCM + Local Notifications
  Future<void> init() async {
    await _initLocalNotifications();
    await _initFirebaseMessaging();
  }

  /// Setup local notifications
  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInit = DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onSelectNotification,
    );

    // ✅ Create Android channel explicitly
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'default_channel',
      'General Notifications',
      description: 'Used for general notifications',
      importance: Importance.high,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    // ✅ Request Android 13+ notification permission
    if (Platform.isAndroid) {
      final status = await Permission.notification.request();
      debugPrint("🔔 Android Notification Permission: $status");
    }

    // ✅ Request iOS permissions
    if (Platform.isIOS) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }

    debugPrint("✅ Local Notifications initialized");
  }

  /// Setup FCM
  Future<void> _initFirebaseMessaging() async {
    // iOS FCM permission
    // if (Platform.isIOS) {
    //   await _messaging.requestPermission(alert: true, badge: true, sound: true);
    // }
    String? token;
    try {
      if (GetPlatform.isIOS) {
        await _messaging.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );
        final apnsToken = await _messaging.getAPNSToken();
        if (apnsToken != null) {
          // only safe to call getToken() after APNS exists
          await Future.delayed(const Duration(seconds: 2));
          token = await _messaging.getToken();
        }
      } else {
        // Android is safe
        token = await _messaging.getToken();
      }
    } catch (e) {
      debugPrint("⚠️ Skipping device token: $e");
    }

    // Get FCM token
    // String? token = await _messaging.getToken();
    debugPrint("📲 FCM Token: $token");

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("🔥 Foreground FCM: ${message.data}");
      _showNotificationFromFcm(message);
    });

    // Background & Terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("👉 Opened from Notification: ${message.data}");
      _onSelectNotification(
        NotificationResponse(
          notificationResponseType:
              NotificationResponseType.selectedNotification,
          payload: message.data.toString(),
        ),
      );
    });

    // ✅ Register top-level background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    debugPrint("✅ FCM initialized");
  }

  /// Show notification from FCM
  Future<void> _showNotificationFromFcm(RemoteMessage message) async {
    String title = message.notification?.title ?? "No Title";
    String body = message.notification?.body ?? "No Body";

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'default_channel',
          'General Notifications',
          channelDescription: 'Used for general notifications',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      platformDetails,
      payload: message.data.toString(),
    );

    debugPrint("📩 Local Notification Shown: title=$title, body=$body");
    debugPrint("📩 Local Notification Shown: Data::${message.data}");
  }

  /// Handle notification click
  Future<void> _onSelectNotification(NotificationResponse response) async {
    debugPrint("👉 Notification Clicked: ${response.payload}");

    if (response.payload != null && response.payload!.isNotEmpty) {
      try {
        String rawPayload = response.payload!;
        debugPrint(":::::::::: RawPayload ::::::::::: $rawPayload");
        DashboardController? dashboardController;
        if (!Get.isRegistered<DashboardController>()) {
          Get.lazyPut(() => DashboardController(), fenix: true);
        }
        dashboardController = Get.find<DashboardController>();

        await 1.seconds.delay();
        dashboardController.changeTab(1);
        // TODO: Parse payload into your model & navigate if needed
      } catch (e, st) {
        debugPrint("❌ Error parsing notification payload: $e");
        debugPrintStack(stackTrace: st);
      }
    }
  }
}
