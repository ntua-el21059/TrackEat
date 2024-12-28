import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import '../models/calorie_calculator_model.dart';

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
    zipcodeController.dispose();
    super.dispose();
  }
}
