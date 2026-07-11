import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'local_notification_service.dart';

class NotificationService {
  static Future<void> initialize() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Permission
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Device Token
    try {
      String? token;
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        final apnsToken = await messaging.getAPNSToken();
        if (apnsToken != null) {
          token = await messaging.getToken();
        }
      } else {
        token = await messaging.getToken();
      }
      print("FCM TOKEN (Service): $token");
    } catch (e) {
      print("Error fetching token in NotificationService: $e");
    }

    // Foreground Notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Title: ${message.notification?.title}");
      print("Body: ${message.notification?.body}");

      if (message.notification != null) {
        LocalNotificationService.showNotification(
          title: message.notification!.title ?? '',
          body: message.notification!.body ?? '',
        );
      }
    });

    // User taps notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification Clicked");
    });
  }
}
