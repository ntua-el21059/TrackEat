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
  static const String _ringsClosedKey = 'rings_closed';
  static const String _ringChangedKey = 'ring_changed';

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

  Future<void> setRingsClosed(bool closed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_ringsClosedKey, closed);
    if (!closed) {
      // If rings are not closed, mark that a ring has changed
      await setRingChanged(true);
    }
  }

  Future<bool> areRingsClosed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_ringsClosedKey) ?? false;
  }

  Future<void> setRingChanged(bool changed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_ringChangedKey, changed);
  }

  Future<bool> hasRingChanged() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_ringChangedKey) ?? false;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
