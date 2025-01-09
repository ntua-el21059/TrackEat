import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/home_initial_model.dart';
import '../models/home_model.dart';

/// A provider class for the HomeScreen.
///
/// This provider manages the state of the HomeScreen, including the
/// current homeModelObj
// ignore_for_file: must_be_immutable
class HomeProvider extends ChangeNotifier {
  HomeModel homeModelObj = HomeModel();
  HomeInitialModel _homeInitialModelObj = HomeInitialModel();
  int _dailyCalories = 0;

  // Keys for SharedPreferences
  static const String _rewardShownKey = 'reward_shown';
  static const String _caloriesGoalReachedKey = 'calories_goal_reached';
  static const String _caloriesGoalChangedKey = 'calories_goal_changed';

  int get dailyCalories => _dailyCalories;

  void setDailyCalories(int calories) {
    _dailyCalories = calories;
    notifyListeners();
  }

  HomeInitialModel get homeInitialModelObj => _homeInitialModelObj;

  void updateSuggestions(BuildContext context) {
    _homeInitialModelObj = HomeInitialModel();
    notifyListeners();
  }

  Future<bool> shouldShowRewardScreen() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(_rewardShownKey) ?? false);
  }

  Future<void> markRewardScreenAsShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rewardShownKey, true);
  }

  Future<void> resetRewardScreenShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rewardShownKey, false);
  }

  Future<bool> isRewardScreenShown() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rewardShownKey) ?? false;
  }

  Future<void> setRingsClosed(bool reached) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_caloriesGoalReachedKey, reached);
    if (!reached) {
      // If calories goal is not reached, mark that it has changed
      await setRingChanged(true);
    }
  }

  Future<bool> areRingsClosed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_caloriesGoalReachedKey) ?? false;
  }

  Future<void> setRingChanged(bool changed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_caloriesGoalChangedKey, changed);
  }

  Future<bool> hasRingChanged() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_caloriesGoalChangedKey) ?? false;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
