// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'BPM TRACKER';

  @override
  String get bpm => 'BPM';

  @override
  String get history => 'HISTORIA';

  @override
  String get settings => 'USTAWIENIA';

  @override
  String get noRecords => 'BRAK REKORDÓW';

  @override
  String get bpmRecord => 'REKORD BPM';

  @override
  String get acc => 'DOKŁ';

  @override
  String get tapToStart => 'DOTKNIJ GDZIEKOLWIEK, ABY ZACZĄĆ';

  @override
  String get keepTapping => 'KONTYNUUJ STUKANIE';

  @override
  String get measurementComplete => 'POMIAR ZAKOŃCZONY';

  @override
  String get reset => 'RESETUJ';

  @override
  String get save => 'ZAPISZ';

  @override
  String get recordSaved => 'REKORD ZAPISANY';

  @override
  String get preferences => 'PREFERENCJE';

  @override
  String get hapticFeedback => 'Wibracje (Haptyka)';

  @override
  String get clearHistory => 'Wyczyść historię';

  @override
  String get about => 'O APLIKACJI';

  @override
  String get devWebsite => 'Strona programisty';

  @override
  String get buyMeCoffee => 'Postaw mi kawę';

  @override
  String get madeWithLove => 'stworzone z miłością przez';

  @override
  String get clearHistoryQuestion => 'Wyczyścić historię?';

  @override
  String get clearHistoryWarning =>
      'To na stałe usunie wszystkie Twoje rekordy BPM.';

  @override
  String get cancel => 'ANULUJ';

  @override
  String get clear => 'WYCZYŚĆ';

  @override
  String get historyCleared => 'Historia wyczyszczona';
}
