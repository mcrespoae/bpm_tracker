// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get appTitle => 'METRA';

  @override
  String get bpm => 'BPM';

  @override
  String get history => 'HISTORIAL';

  @override
  String get settings => 'AJUSTES';

  @override
  String get noRecords => 'SENSE REGISTRES';

  @override
  String get bpmRecord => 'REGISTRE BPM';

  @override
  String get acc => 'ACC';

  @override
  String get tapToStart => 'TOCA A QUALSEVOL LLOC PER COMENÇAR';

  @override
  String get keepTapping => 'SEGUEIX TOCANT';

  @override
  String get measurementComplete => 'MESURAMENT COMPLETAT';

  @override
  String get reset => 'REINICIAR';

  @override
  String get save => 'DESAR';

  @override
  String get recordSaved => 'REGISTRE DESAT';

  @override
  String get preferences => 'PREFERÈNCIES';

  @override
  String get hapticFeedback => 'Vibració';

  @override
  String get clearHistory => 'Esborra tot l\'historial';

  @override
  String get about => 'SOBRE';

  @override
  String get devWebsite => 'Lloc web del desenvolupador';

  @override
  String get buyMeCoffee => 'Convida\'m a un cafè';

  @override
  String get madeWithLove => 'fet amb amor per';

  @override
  String get clearHistoryQuestion => 'Esborrar historial?';

  @override
  String get clearHistoryWarning =>
      'Això eliminarà permanentment tots els teus registres de BPM.';

  @override
  String get cancel => 'CANCEL·LAR';

  @override
  String get clear => 'ESBORRAR';

  @override
  String get historyCleared => 'Historial esborrat';

  @override
  String get saveNameTitle => 'NOMENAR SESSIÓ';

  @override
  String get renameRecord => 'Renomenar registre';

  @override
  String get nameHint => 'Nom de la sessió (opcional)';

  @override
  String get unnamed => 'Sense nom';

  @override
  String get overrideOldest => 'Sobreescriure antics';

  @override
  String get historyFull => 'HISTORIAL PLE';

  @override
  String maxRecordsReached(int limit) {
    return 'Límit d\'historial assolit ($limit registres). Per desar noves mesures, elimina un registre de l\'Historial o activa \'Sobreescriure antics\' als Ajustos.';
  }

  @override
  String get saveError => 'ERROR EN DESAR EL REGISTRE';
}
