import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../core/utils/app_utils.dart';

class ThemeProvider extends ChangeNotifier {
  Future<void> themeChange(String themeType) async {
    PrefUtils().setThemeData(themeType);
    notifyListeners();
  }
}