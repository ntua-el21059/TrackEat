import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../services/meal_service.dart';
import '../../../../models/meal.dart';

/// A provider class for the HistoryTodayTabScreen.
///
/// This provider manages the state of the HistoryTodayTabScreen, including the
/// current historyTodayTabModelObj
// ignore_for_file: must_be_immutable
class HistoryTodayTabProvider extends ChangeNotifier {
  final MealService _mealService = MealService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DateTime selectedDate = DateTime.now();
  List<Meal> _meals = [];
  bool _isLoading = true;
  
  // User data
  double _proteinGoal = 0.0;
  double _fatGoal = 0.0;
  double _carbsGoal = 0.0;
  int _dailyCalories = 0;

  bool get isLoading => _isLoading;
  List<Meal> get meals => _meals;
  double get proteinGoal => _proteinGoal;
  double get fatGoal => _fatGoal;
  double get carbsGoal => _carbsGoal;
  int get dailyCalories => _dailyCalories;

  bool get hasBreakfast {
    return _meals.any((meal) => 
      meal.mealType.toLowerCase() == 'breakfast' && 
      isSameDay(meal.date, selectedDate)
    );
  }

  bool get hasLunch {
    return _meals.any((meal) => 
      meal.mealType.toLowerCase() == 'lunch' && 
      isSameDay(meal.date, selectedDate)
    );
  }

  bool get hasDinner {
    return _meals.any((meal) => 
      meal.mealType.toLowerCase() == 'dinner' && 
      isSameDay(meal.date, selectedDate)
    );
  }

  HistoryTodayTabProvider() {
    _initializeUserData();
    _initializeMeals();
  }

  void _initializeUserData() {
    final userEmail = _auth.currentUser?.email;
    if (userEmail != null) {
      _firestore
          .collection('users')
          .doc(userEmail)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists) {
          final userData = snapshot.data()!;
          _proteinGoal = double.tryParse(userData['proteingoal']?.toString() ?? '0') ?? 0.0;
          _fatGoal = double.tryParse(userData['fatgoal']?.toString() ?? '0') ?? 0.0;
          _carbsGoal = double.tryParse(userData['carbsgoal']?.toString() ?? '0') ?? 0.0;
          _dailyCalories = userData['dailyCalories'] as int? ?? 0;
          notifyListeners();
        }
      });
    }
  }

  void _initializeMeals() {
    final userEmail = _auth.currentUser?.email;
    if (userEmail != null) {
      _mealService.getMealsByUserAndDate(userEmail, selectedDate).listen((meals) {
        _meals = meals;
        _isLoading = false;
        notifyListeners();
      });
    }
  }

  void refreshMeals() {
    _initializeMeals();
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && 
           date1.month == date2.month && 
           date1.day == date2.day;
  }

  bool isToday() {
    final now = DateTime.now();
    return selectedDate.year == now.year && 
           selectedDate.month == now.month && 
           selectedDate.day == now.day;
  }

  int getDaysDifference() {
    final now = DateTime.now();
    final difference = now.difference(selectedDate).inDays;
    return difference;
  }

  bool canGoForward() {
    return selectedDate.isBefore(DateTime.now());
  }

  void goToPreviousDay() {
    selectedDate = selectedDate.subtract(Duration(days: 1));
    _initializeMeals();
    notifyListeners();
  }

  void goToNextDay() {
    if (canGoForward()) {
      final today = DateTime.now();
      selectedDate = selectedDate.add(Duration(days: 1));
      if (selectedDate.isAfter(today)) {
        selectedDate = today;
      }
      _initializeMeals();
      notifyListeners();
    }
  }

  String getFormattedDate() {
    return DateFormat('EEEE, MMMM d').format(selectedDate);
  }

  Future<void> deleteMeal(String mealId) async {
    try {
      await _mealService.deleteMeal(mealId);
      _meals.removeWhere((meal) => meal.id == mealId);
      notifyListeners();
    } catch (e) {
      print('Error deleting meal: $e');
      rethrow;
    }
  }

  Meal? getMealByType(String mealType) {
    try {
      return _meals.firstWhere(
        (meal) => meal.mealType.toLowerCase() == mealType.toLowerCase() && 
                  isSameDay(meal.date, selectedDate)
      );
    } catch (e) {
      return null;
    }
  }

  List<Meal> getMealsByType(String mealType) {
    return _meals.where(
      (meal) => meal.mealType.toLowerCase() == mealType.toLowerCase() && 
                isSameDay(meal.date, selectedDate)
    ).toList();
  }

  Future<int> getTotalCalories() async {
    final userEmail = _auth.currentUser?.email;
    if (userEmail != null) {
      return await _mealService.getTotalCaloriesForDate(userEmail, selectedDate);
    }
    return 0;
  }

  Future<Map<String, double>> getTotalMacros() async {
    final userEmail = _auth.currentUser?.email;
    if (userEmail != null) {
      return await _mealService.getTotalMacrosForDate(userEmail, selectedDate);
    }
    return {
      'protein': 0.0,
      'fats': 0.0,
      'carbs': 0.0,
    };
  }
}