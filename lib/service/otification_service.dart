import 'package:firebase_messaging/firebase_messaging.dart';

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
    String? token = await messaging.getToken();

    print("FCM TOKEN: $token");

    // Foreground Notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Title: ${message.notification?.title}");
      print("Body: ${message.notification?.body}");
    });

    // User taps notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification Clicked");
    });
  }
}