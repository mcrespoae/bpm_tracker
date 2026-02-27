// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'METRA';

  @override
  String get bpm => 'BPM';

  @override
  String get history => 'HISTORIQUE';

  @override
  String get settings => 'RÉGLAGES';

  @override
  String get noRecords => 'PAS ENCORE D\'ENREGISTREMENTS';

  @override
  String get bpmRecord => 'ENREGISTREMENT BPM';

  @override
  String get acc => 'PRÉC';

  @override
  String get tapToStart => 'APPUYEZ N\'IMPORTE OÙ POUR COMMENCER';

  @override
  String get keepTapping => 'CONTINUEZ À APPUYER';

  @override
  String get measurementComplete => 'MESURE TERMINÉE';

  @override
  String get reset => 'RÉINITIALISER';

  @override
  String get save => 'ENREGISTRER';

  @override
  String get recordSaved => 'ENREGISTREMENT SAUVEGARDÉ';

  @override
  String get preferences => 'PRÉFÉRENCES';

  @override
  String get hapticFeedback => 'Feedback Haptique';

  @override
  String get clearHistory => 'Effacer l\'historique';

  @override
  String get about => 'À PROPOS';

  @override
  String get devWebsite => 'Site Web du Développeur';

  @override
  String get buyMeCoffee => 'Payez-moi un café';

  @override
  String get madeWithLove => 'fait avec amour par';

  @override
  String get clearHistoryQuestion => 'Effacer l\'historique ?';

  @override
  String get clearHistoryWarning =>
      'Cela effacera définitivement tous vos enregistrements BPM.';

  @override
  String get cancel => 'ANNULER';

  @override
  String get clear => 'EFFACER';

  @override
  String get historyCleared => 'Historique effacé';

  @override
  String get saveNameTitle => 'NOMMER VOTRE SESSION';

  @override
  String get renameRecord => 'RENOMMER L\'ENREGISTREMENT';

  @override
  String get nameHint => 'Entrez le nom de la session (facultatif)';

  @override
  String get unnamed => 'Sans nom';

  @override
  String get overrideOldest => 'Écraser les plus anciens';

  @override
  String get historyFull => 'HISTORIQUE PLEIN';

  @override
  String maxRecordsReached(int limit) {
    return 'Limite d\'historique atteinte ($limit enregistrements). Pour enregistrer de nouvelles mesures, supprimez un enregistrement de l\'Historique ou activez \'Écraser les plus anciens\' dans les Réglages.';
  }

  @override
  String get saveError => 'ÉCHEC DE L\'ENREGISTREMENT';
}
