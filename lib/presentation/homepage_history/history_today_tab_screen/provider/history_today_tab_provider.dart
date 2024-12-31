import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A provider class for the HistoryTodayTabScreen.
///
/// This provider manages the state of the HistoryTodayTabScreen, including the
/// current historyTodayTabModelObj
// ignore_for_file: must_be_immutable
class HistoryTodayTabProvider extends ChangeNotifier {
  DateTime selectedDate = DateTime.now();

  bool get hasBreakfast {
    return isToday(); // Only show breakfast on today's date
  }

  bool get hasLunch {
    return isToday(); // Only show lunch on today's date
  }

  bool isToday() {
    final now = DateTime.now();
    return selectedDate.year == now.year && 
           selectedDate.month == now.month && 
           selectedDate.day == now.day;
  }

  bool canGoForward() {
    final today = DateTime.now();
    return selectedDate.isBefore(today);
  }

  void goToPreviousDay() {
    selectedDate = selectedDate.subtract(Duration(days: 1));
    notifyListeners();
  }

  void goToNextDay() {
    if (canGoForward()) {
      final today = DateTime.now();
      selectedDate = selectedDate.add(Duration(days: 1));
      if (selectedDate.isAfter(today)) {
        selectedDate = today;
      }
      notifyListeners();
    }
  }

  String getFormattedDate() {
    return DateFormat('EEEE, MMMM d').format(selectedDate);
  }

  void deleteMeal(String mealType) {
    notifyListeners();
  }
}
