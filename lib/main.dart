import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/tracker/presentation/pages/tracker_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: BPMTrackerApp(),
    ),
  );
}

class BPMTrackerApp extends StatelessWidget {
  const BPMTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BPM Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const TrackerPage(),
    );
  }
}
