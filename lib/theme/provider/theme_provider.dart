import 'package:flutter/material.dart';
import '../../core/app_export.dart';

class ThemeProvider extends ChangeNotifier {
  Future<void> themeChange(String themeType) async {
    PrefUtils().setThemeData(themeType);
    notifyListeners();
  }
}