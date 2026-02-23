// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'METRA';

  @override
  String get bpm => 'BPM';

  @override
  String get history => 'CRONOLOGIA';

  @override
  String get settings => 'IMPOSTAZIONI';

  @override
  String get noRecords => 'NESSUN RECORD ANCORA';

  @override
  String get bpmRecord => 'RECORD BPM';

  @override
  String get acc => 'ACC';

  @override
  String get tapToStart => 'TOCCA OVUNQUE PER INIZIARE';

  @override
  String get keepTapping => 'CONTINUA A TOCCARE';

  @override
  String get measurementComplete => 'MISURAZIONE COMPLETATA';

  @override
  String get reset => 'RESET';

  @override
  String get save => 'SALVA';

  @override
  String get recordSaved => 'RECORD SALVATO';

  @override
  String get preferences => 'PREFERENZE';

  @override
  String get hapticFeedback => 'Feedback Aptico';

  @override
  String get clearHistory => 'Cancella Cronologia';

  @override
  String get about => 'INFO';

  @override
  String get devWebsite => 'Sito Web Sviluppatore';

  @override
  String get buyMeCoffee => 'Offrimi un caffè';

  @override
  String get madeWithLove => 'fatto con amore da';

  @override
  String get clearHistoryQuestion => 'Cancella Cronologia?';

  @override
  String get clearHistoryWarning =>
      'Questo eliminerà permanentemente tutti i tuoi record BPM.';

  @override
  String get cancel => 'ANNULLA';

  @override
  String get clear => 'CANCELLA';

  @override
  String get historyCleared => 'Cronologia cancellata';

  @override
  String get saveNameTitle => 'NOMINA LA TUA SESSIONE';

  @override
  String get renameRecord => 'RINOMINA RECORD';

  @override
  String get nameHint => 'Inserisci il nome della sessione (opzionale)';

  @override
  String get unnamed => 'Senza nome';

  @override
  String get overrideOldest => 'Sovrascrivi i più vecchi';

  @override
  String get historyFull => 'CRONOLOGIA PIENA';

  @override
  String maxRecordsReached(int limit) {
    return 'Limite cronologia raggiunto ($limit record). Per salvare nuove misurazioni, elimina un record dalla Cronologia o abilita \'Sovrascrivi i più vecchi\' nelle Impostazioni.';
  }
}
