import 'package:flutter/material.dart';
import 'package:postergali/core/localization/localization_service.dart';
import 'features/onboarding/presentation/screens/splash_screen.dart';
import 'core/constants/app_colors.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalizationService().init();
  runApp(const PosterGaliApp());
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
          localizationsDelegates: const [
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