import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../routes/app_routes.dart';
import '../widgets.dart';
import 'calorie_calculator_screen.dart';

class CalorieCalculatorModel {}

/// A provider class for the CalorieCalculatorScreen.
///
/// This provider manages the state of the CalorieCalculatorScreen, including the
/// current calorieCalculatorModelObj
// ignore_for_file: must_be_immutable
class CalorieCalculatorProvider extends ChangeNotifier {
  TextEditingController zipcodeController = TextEditingController();
  CalorieCalculatorModel calorieCalculatorModelObj = CalorieCalculatorModel();

  @override
  void dispose() {
    super.dispose();
    zipcodeController.dispose();
  }
}
