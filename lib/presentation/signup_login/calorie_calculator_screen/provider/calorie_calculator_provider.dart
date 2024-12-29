import 'package:flutter/material.dart';
import '../models/calorie_calculator_model.dart';

/// A provider class for the CalorieCalculatorScreen.
///
/// This provider manages the state of the CalorieCalculatorScreen, including the
/// current calorieCalculatorModelObj
// ignore_for_file: must_be_immutable
class CalorieCalculatorProvider extends ChangeNotifier {
  TextEditingController zipcodeController = TextEditingController();
  CalorieCalculatorModel calorieCalculatorModelObj = CalorieCalculatorModel();

  int calculateDailyCalories(double weight, double height, int age, String gender) {
    // Mifflin-St Jeor Equation
    double bmr;
    if (gender.toLowerCase() == 'male') {
      bmr = 10 * weight + 6.25 * height - 5 * age + 5;
    } else {
      bmr = 10 * weight + 6.25 * height - 5 * age - 161;
    }
    
    int dailyCalories = bmr.round();
    
    // Update the text field
    zipcodeController.text = dailyCalories.toString();
    
    return dailyCalories;
  }

  @override
  void dispose() {
    zipcodeController.dispose();
    super.dispose();
  }
}
