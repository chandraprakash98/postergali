import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:postergali/core/localization/localization_service.dart';
import 'package:postergali/service/local_notification_service.dart';
import 'package:postergali/service/otification_service.dart';
import 'features/onboarding/presentation/screens/splash_screen.dart';
import 'core/constants/app_colors.dart';


Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
    ) async {
  await Firebase.initializeApp();

  print("Background Message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Localization
  await LocalizationService().init();

  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );

  // Initialize Local Notifications first
  await LocalNotificationService.initialize();

  await initNotification();

  String? token =
  await FirebaseMessaging.instance.getToken();

  print("FCM TOKEN: $token");

  await NotificationService.initialize();

  runApp(const PosterGaliApp());
}

Future<void> initNotification() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings =
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print(settings.authorizationStatus);

}

class PosterGaliApp extends StatelessWidget {
  const PosterGaliApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: LocalizationService().localeNotifier,
      builder: (context, locale, child) {
        return MaterialApp(
          key: ValueKey(locale), // Force rebuild on language change
          debugShowCheckedModeBanner: false,
          title: 'PosterGali',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primaryRed,
              primary: AppColors.primaryRed,
            ),
            fontFamily: 'HelveticaNeue',
          ),
          home: const SplashScreen(),
        );
      }
    );
  }
}
