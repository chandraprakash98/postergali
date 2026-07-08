import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:postergali/core/localization/localization_service.dart';
import 'package:postergali/service/local_notification_service.dart';
import 'package:postergali/service/otification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/onboarding/presentation/screens/splash_screen.dart';
import 'core/constants/app_colors.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
    ) async {
  await Firebase.initializeApp();

  print("Background Message: ${message.messageId}");
}

  // Future<void> main() async {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   await Firebase.initializeApp();
  //   await initNotification();
  //
  //   String? token =
  //   await FirebaseMessaging.instance.getToken();
  //
  //   print("++++++++++++++");
  //   print(token);
  //
  //   runApp(const PosterGaliApp());
  //
  //   FirebaseMessaging.onBackgroundMessage(
  //     firebaseMessagingBackgroundHandler,
  //   );
  //   await NotificationService.initialize();
  // }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );

  // Initialize Localization
  await LocalizationService().init();

  // Initialize Local Notifications first
  await LocalNotificationService.initialize();

  await initNotification();

  String? token =
  await FirebaseMessaging.instance.getToken();

  if (token != null) {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm_token', token);
  }

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
      builder: (context, localeCode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'PosterGali',
          locale: Locale(localeCode),
          supportedLocales: const [
            Locale('en', ''),
            Locale('hi', ''),
          ],
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
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
      },
    );
  }
}
