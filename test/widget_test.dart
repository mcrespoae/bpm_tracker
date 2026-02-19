import 'package:flutter_test/flutter_test.dart';
import 'package:bpm_tracker/main.dart';

void main() {
  testWidgets('BPM Tracker smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const BPMTrackerApp());
    expect(find.text('BPM TRACKER'), findsOneWidget);
  });
}
