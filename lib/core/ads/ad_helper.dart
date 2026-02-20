import 'dart:io';
import 'package:flutter/foundation.dart';

class AdHelper {
  static String? get bannerAdUnitId {
    if (kDebugMode) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/6300978111'; // Test Android
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3940256099942544/2934735716'; // Test iOS
      }
    } else {
      // RELEASE MODE - REAL IDs
      if (Platform.isAndroid) {
        return 'ca-app-pub-6733960051732922/8876124608'; // Real Android
      } else if (Platform.isIOS) {
        return 'ca-app-pub-6733960051732922/9474890408'; // Real iOS
      }
    }
    return null;
  }
}
