import 'package:flutter_test/flutter_test.dart';
import 'package:metra/main.dart';

void main() {
  testWidgets('METRA smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MetraApp());
    expect(find.text('METRA'), findsOneWidget);
  });
}
