import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
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
    notifyListeners();
  }

  CreateProfile22Provider() {
    timeController.addListener(_textChanged);
    inputoneController.addListener(_textChanged);
    inputthreeController.addListener(_textChanged);
    inputfiveController.addListener(_textChanged);
    inputsevenController.addListener(_textChanged);
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
    timeController.dispose();
    inputoneController.dispose();
    inputthreeController.dispose();
    inputfiveController.dispose();
    inputsevenController.dispose();
    super.dispose();
  }
}

