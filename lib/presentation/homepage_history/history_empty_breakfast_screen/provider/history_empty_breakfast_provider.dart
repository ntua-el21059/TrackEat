import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import '../models/history_empty_breakfast_model.dart';
import '../models/listview_item_model.dart';

/// A provider class for the HistoryEmptyBreakfastScreen.
///
/// This provider manages the state of the HistoryEmptyBreakfastScreen, including the
/// current historyEmptyBreakfastModelObj
// ignore_for_file: must_be_immutable
class HistoryEmptyBreakfastProvider extends ChangeNotifier {
  HistoryEmptyBreakfastModel historyEmptyBreakfastModelObj = HistoryEmptyBreakfastModel();

  @override
  void dispose() {
    super.dispose();
  }
}
