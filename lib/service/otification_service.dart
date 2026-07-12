import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'local_notification_service.dart';

class NotificationService {
  static Future<void> initialize() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Permission
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print("Notification permission status: ${settings.authorizationStatus}");

    // Device Token
    try {
      String? token;
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        // Try getting token, if null it means APNS is not ready yet.
        // On iOS, getToken() automatically waits for APNS token if swizzling is enabled.
        token = await messaging.getToken();
        
        // If still null, we don't block initialization, we just log it.
        if (token == null) {
          print("FCM Token not available yet on iOS. It will be fetched later.");
        }
      } else {
        token = await messaging.getToken();
      }
      
      if (token != null) {
        print("FCM TOKEN: $token");
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('fcm_token', token);
      }
    } catch (e) {
      print("Error fetching token: $e");
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
