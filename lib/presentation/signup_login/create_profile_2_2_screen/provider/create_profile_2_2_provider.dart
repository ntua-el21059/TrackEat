import 'package:flutter/material.dart';
import '../models/create_profile_2_2_model.dart';

/// A provider class for the CreateProfile22Screen.
///
/// This provider manages the state of the CreateProfile22Screen, including the
/// current createProfile22ModelObj.
// ignore_for_file: must_be_immutable
class CreateProfile22Provider extends ChangeNotifier {
  TextEditingController timeController = TextEditingController();
  TextEditingController inputoneController = TextEditingController();
  TextEditingController inputthreeController = TextEditingController();
  TextEditingController inputfiveController = TextEditingController();
  TextEditingController inputsevenController = TextEditingController();
  TextEditingController weeklyGoalController = TextEditingController();
  TextEditingController goalWeightController = TextEditingController();

  CreateProfile22Model createProfile22ModelObj = CreateProfile22Model();

  String _activityLevel = '';
  
  String get activityLevel => _activityLevel;

  void setActivityLevel(String level) {
    _activityLevel = level;
    timeController.text = level;
    notifyListeners();
  }

  String _dietType = '';
  
  String get dietType => _dietType;

  void setDietType(String type) {
    _dietType = type;
    inputoneController.text = type;
    notifyListeners();
  }

  String _goalType = '';
  
  String get goalType => _goalType;

  void setGoalType(String type) {
    _goalType = type;
    inputthreeController.text = type;
    
    // Reset weekly goal and set goal weight when changing goal type
    if (type == 'Maintain Weight') {
      weeklyGoalController.text = '0.0';
      _selectedValue = 0.0;
      // Set goal weight to current weight
      goalWeightController.text = inputsevenController.text;
    }
    
    notifyListeners();
  }

  // Weekly goal picker properties
  int _selectedSign = 1;
  double _selectedValue = 0.0;
  double _selectedWeeklyGoalValue = 0.0;

  int get selectedSign => _selectedSign;
  double get selectedValue => _selectedValue;
  double get selectedWeeklyGoalValue => _selectedWeeklyGoalValue;

  void setSelectedSign(int sign) {
    _selectedSign = sign;
    _updateSelectedValue();
    notifyListeners();
  }

  void setSelectedValue(double value) {
    _selectedValue = value;
    _updateSelectedValue();
    notifyListeners();
  }

  void _updateSelectedValue() {
    _selectedWeeklyGoalValue = _goalType == 'Lose Weight' ? -_selectedValue : _selectedValue;
  }

  CreateProfile22Provider() {
    timeController.addListener(_textChanged);
    inputoneController.addListener(_textChanged);
    inputthreeController.addListener(_textChanged);
    inputfiveController.addListener(_textChanged);
    inputsevenController.addListener(_textChanged);
    weeklyGoalController.addListener(_textChanged);
    goalWeightController.addListener(_textChanged);
  }

  void _textChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    timeController.removeListener(_textChanged);
    inputoneController.removeListener(_textChanged);
    inputthreeController.removeListener(_textChanged);
    inputfiveController.removeListener(_textChanged);
    inputsevenController.removeListener(_textChanged);
    weeklyGoalController.removeListener(_textChanged);
    goalWeightController.removeListener(_textChanged);
    timeController.dispose();
    inputoneController.dispose();
    inputthreeController.dispose();
    inputfiveController.dispose();
    inputsevenController.dispose();
    weeklyGoalController.dispose();
    goalWeightController.dispose();
    super.dispose();
  }
}

