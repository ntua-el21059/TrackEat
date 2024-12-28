import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import '../models/history_today_tab_model.dart';
import '../models/historytoday_item_model.dart';

/// A provider class for the HistoryTodayTabScreen.
///
/// This provider manages the state of the HistoryTodayTabScreen, including the
/// current historyTodayTabModelObj
// ignore_for_file: must_be_immutable
class HistoryTodayTabProvider extends ChangeNotifier {
  HistoryTodayTabModel historyTodayTabModelObj = HistoryTodayTabModel();
  bool hasBreakfast = true;
  bool hasLunch = true;

  @override
  void dispose() {
    super.dispose();
  }

  void deleteMeal(String mealType) {
    if (mealType == 'breakfast') {
      hasBreakfast = false;
    } else if (mealType == 'lunch') {
      hasLunch = false;
    }
    notifyListeners();
  }
}
