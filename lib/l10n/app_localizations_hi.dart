// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'METRA';

  @override
  String get bpm => 'BPM';

  @override
  String get history => 'इतिहास';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get noRecords => 'अभी तक कोई रिकॉर्ड नहीं';

  @override
  String get bpmRecord => 'BPM रिकॉर्ड';

  @override
  String get acc => 'सटीकता';

  @override
  String get tapToStart => 'शुरू करने के लिए कहीं भी टैप करें';

  @override
  String get keepTapping => 'टैप करते रहें';

  @override
  String get measurementComplete => 'माप पूरा हुआ';

  @override
  String get reset => 'रीसेट';

  @override
  String get save => 'सहेजें';

  @override
  String get recordSaved => 'रिकॉर्ड सहेजा गया';

  @override
  String get preferences => 'वरीयताएं';

  @override
  String get hapticFeedback => 'हैप्टिक फीडबैक';

  @override
  String get clearHistory => 'इतिहास साफ़ करें';

  @override
  String get about => 'बारे में';

  @override
  String get devWebsite => 'डेवलपर वेबसाइट';

  @override
  String get buyMeCoffee => 'कॉफी भेंट करें';

  @override
  String get madeWithLove => 'प्यार से बनाया गया:';

  @override
  String get clearHistoryQuestion => 'इतिहास साफ़ करें?';

  @override
  String get clearHistoryWarning =>
      'यह आपके सभी BPM रिकॉर्ड को स्थायी रूप से हटा देगा।';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get clear => 'साफ़ करें';

  @override
  String get historyCleared => 'इतिहास साफ़ किया गया';

  @override
  String get saveNameTitle => 'सत्र का नाम रखें';

  @override
  String get renameRecord => 'रिकॉर्ड का नाम बदलें';

  @override
  String get nameHint => 'सत्र का नाम दर्ज करें (वैकल्पिक)';

  @override
  String get unnamed => 'बेनाम';

  @override
  String get overrideOldest => 'सबसे पुराने रिकॉर्ड बदलें';

  @override
  String get historyFull => 'इतिहास भर गया';

  @override
  String maxRecordsReached(int limit) {
    return 'इतिहास की सीमा ($limit रिकॉर्ड) पूरी हो गई है। नए माप सहेजने के लिए, इतिहास से एक रिकॉर्ड हटाएं या सेटिंग्स में \'सबसे पुराने रिकॉर्ड बदलें\' को सक्षम करें।';
  }

  @override
  String get saveError => 'रिकॉर्ड सहेजने में विफल';
}
