// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'BPM 测量器';

  @override
  String get bpm => 'BPM';

  @override
  String get history => '历史记录';

  @override
  String get settings => '设置';

  @override
  String get noRecords => '暂无记录';

  @override
  String get bpmRecord => 'BPM 记录';

  @override
  String get acc => '精度';

  @override
  String get tapToStart => '点击任意位置开始';

  @override
  String get keepTapping => '请继续点击';

  @override
  String get measurementComplete => '测量完成';

  @override
  String get reset => '重置';

  @override
  String get save => '保存';

  @override
  String get recordSaved => '记录已保存';

  @override
  String get preferences => '首选项';

  @override
  String get hapticFeedback => '震动反馈';

  @override
  String get clearHistory => '清除历史记录';

  @override
  String get about => '关于';

  @override
  String get devWebsite => '开发者网站';

  @override
  String get buyMeCoffee => '请我喝杯咖啡';

  @override
  String get madeWithLove => '用心创作:';

  @override
  String get clearHistoryQuestion => '清除历史记录？';

  @override
  String get clearHistoryWarning => '这将永久删除您的所有 BPM 记录。';

  @override
  String get cancel => '取消';

  @override
  String get clear => '清除';

  @override
  String get historyCleared => '历史记录已清除';
}
