import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metra/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('METRA smoke test', (WidgetTester tester) async {
    // Disable animations to avoid pending timers
    Animate.restartOnHotReload = true;
    // Mock SharedPreferences
    SharedPreferences.setMockInitialValues({});

    // Set a realistic mobile screen size to avoid overflow
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: MetraApp(),
      ),
    );

    // Initial pump and settle (wait for fade-ins)
    await tester.pumpAndSettle();

    // Verify that the app title is present.
    expect(find.text('METRA'), findsWidgets);
    expect(find.text('BPM'), findsWidgets);

    // Reset screen size
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
