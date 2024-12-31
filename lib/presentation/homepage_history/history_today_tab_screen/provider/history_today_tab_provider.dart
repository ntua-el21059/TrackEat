import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../models/history_today_tab_model.dart';

/// A provider class for the HistoryTodayTabScreen.
///
/// This provider manages the state of the HistoryTodayTabScreen, including the
/// current historyTodayTabModelObj
// ignore_for_file: must_be_immutable
class HistoryTodayTabProvider extends ChangeNotifier {
  HistoryTodayTabModel historyTodayTabModelObj = HistoryTodayTabModel();
  DateTime selectedDate = DateTime.now();
  int _dailyCalories = 2000; // Default value
  
  int get dailyCalories => _dailyCalories;

  // Navigation getters
  bool get hasBreakfast => isToday(); // Only show breakfast on today's date
  bool get hasLunch => isToday(); // Only show lunch on today's date

  HistoryTodayTabProvider() {
    listenToDailyCalories();
  }

  void listenToDailyCalories() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists) {
          _dailyCalories = snapshot.data()?['dailyCalories'] ?? 2000;
          notifyListeners();
        }
      });
    }
  }

  // Date navigation methods
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

  bool canGoForward() {
    final today = DateTime.now();
    return selectedDate.isBefore(today);
  }

  bool isToday() {
    final now = DateTime.now();
    return selectedDate.year == now.year && 
           selectedDate.month == now.month && 
           selectedDate.day == now.day;
  }

  String getFormattedDate() {
    return DateFormat('EEEE, MMMM d').format(selectedDate);
  }

  // Meal management
  void deleteMeal(String mealType) {
    // TODO: Implement meal deletion with Firebase
    notifyListeners();
  }
}
