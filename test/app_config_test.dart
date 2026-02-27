import 'package:flutter_test/flutter_test.dart';
import 'package:metra/features/history/presentation/history_provider.dart';
import 'package:metra/l10n/app_localizations.dart';

void main() {
  group('App Configuration Tests', () {
    test('History limit is correctly set to 20', () {
      expect(HistoryRepository.maxItems, 20);
    });

    test('Supported locales include Catalan', () {
      const List<String> expectedLocales = [
        'en', 'es', 'pt', 'fr', 'de', 'it', 'pl', 'ja', 'zh', 'hi', 'ru', 'ca'
      ];

      final supportedLocales = AppLocalizations.supportedLocales.map((l) => l.languageCode).toList();

      for (var locale in expectedLocales) {
        expect(supportedLocales, contains(locale));
      }
    });
  });
}
