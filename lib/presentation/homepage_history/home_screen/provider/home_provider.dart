import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/home_initial_model.dart';
import '../models/home_model.dart';
import '../../../../providers/user_info_provider.dart';

/// A provider class for the HomeScreen.
///
/// This provider manages the state of the HomeScreen, including the
/// current homeModelObj
// ignore_for_file: must_be_immutable
class HomeProvider extends ChangeNotifier {
  HomeModel homeModelObj = HomeModel();
  HomeInitialModel _homeInitialModelObj = HomeInitialModel();
  int _dailyCalories = 0;

  int get dailyCalories => _dailyCalories;

  void setDailyCalories(int calories) {
    _dailyCalories = calories;
    notifyListeners();
  }

  HomeInitialModel get homeInitialModelObj => _homeInitialModelObj;

  void updateSuggestions(BuildContext context) {
    final userInfo = Provider.of<UserInfoProvider>(context, listen: false);
    _homeInitialModelObj = HomeInitialModel()..updateGreens(userInfo.firstName);
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
