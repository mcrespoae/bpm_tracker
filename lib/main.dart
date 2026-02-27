import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:metra/l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'features/tracker/presentation/pages/tracker_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    const ProviderScope(
      child: MetraApp(),
    ),
  );
}

class MetraApp extends StatelessWidget {
  const MetraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'METRA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
        Locale('pt'),
        Locale('fr'),
        Locale('de'),
        Locale('it'),
        Locale('pl'),
        Locale('ja'),
        Locale('zh'),
        Locale('hi'),
        Locale('ru'),
        Locale('ca'),
      ],
      home: const TrackerPage(),
    );
  }
}
