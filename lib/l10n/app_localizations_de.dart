// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'METRA';

  @override
  String get bpm => 'BPM';

  @override
  String get history => 'VERLAUF';

  @override
  String get settings => 'EINSTELLUNGEN';

  @override
  String get noRecords => 'NOCH KEINE AUFZEICHNUNGEN';

  @override
  String get bpmRecord => 'BPM AUFZEICHNUNG';

  @override
  String get acc => 'GEN';

  @override
  String get tapToStart => 'ZUM STARTEN ÜBERALL TIPPEN';

  @override
  String get keepTapping => 'WEITER TIPPEN';

  @override
  String get measurementComplete => 'MESSUNG ABGESCHLOSSEN';

  @override
  String get reset => 'ZURÜCKSETZEN';

  @override
  String get save => 'SPEICHERN';

  @override
  String get recordSaved => 'AUFZEICHNUNG GESPEICHERT';

  @override
  String get preferences => 'EINSTELLUNGEN';

  @override
  String get hapticFeedback => 'Haptisches Feedback';

  @override
  String get clearHistory => 'Verlauf löschen';

  @override
  String get about => 'ÜBER';

  @override
  String get devWebsite => 'Entwickler-Website';

  @override
  String get buyMeCoffee => 'Kauf mir einen Kaffee';

  @override
  String get madeWithLove => 'mit Liebe gemacht von';

  @override
  String get clearHistoryQuestion => 'Verlauf löschen?';

  @override
  String get clearHistoryWarning =>
      'Dies wird alle Ihre BPM-Aufzeichnungen dauerhaft löschen.';

  @override
  String get cancel => 'ABBRECHEN';

  @override
  String get clear => 'LÖSCHEN';

  @override
  String get historyCleared => 'Verlauf gelöscht';

  @override
  String get saveNameTitle => 'SITZUNG BENENNEN';

  @override
  String get renameRecord => 'AUFZEICHNUNG UMBENENNEN';

  @override
  String get nameHint => 'Sitzungsname eingeben (optional)';

  @override
  String get unnamed => 'Unbenannt';

  @override
  String get overrideOldest => 'Älteste Aufzeichnungen überschreiben';

  @override
  String get historyFull => 'VERLAUF VOLL';

  @override
  String maxRecordsReached(int limit) {
    return 'Verlaufslimit erreicht ($limit Aufzeichnungen). Um neue Messungen zu speichern, lösche eine Aufzeichnung im Verlauf oder aktiviere \'Älteste überschreiben\' in den Einstellungen.';
  }

  @override
  String get saveError => 'SPEICHERN FEHLGESCHLAGEN';
}
