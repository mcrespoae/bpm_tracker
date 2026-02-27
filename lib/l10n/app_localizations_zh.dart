// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'METRA';

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

  @override
  String get saveNameTitle => '命名您的会话';

  @override
  String get renameRecord => '重命名记录';

  @override
  String get nameHint => '输入会话名称（可选）';

  @override
  String get unnamed => '未命名';

  @override
  String get overrideOldest => '覆盖最早的记录';

  @override
  String get historyFull => '历史记录已满';

  @override
  String maxRecordsReached(int limit) {
    return '已达到历史记录上限（$limit条）。要保存新测量值，请从历史记录中删除一条记录，或在设置中启用“覆盖最早的记录”。';
  }

  @override
  String get saveError => '无法保存记录';
}
