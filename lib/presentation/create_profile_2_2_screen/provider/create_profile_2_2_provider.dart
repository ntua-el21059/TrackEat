import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
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

  @override
  void dispose() {
    timeController.dispose();
    inputoneController.dispose();
    inputthreeController.dispose();
    inputfiveController.dispose();
    inputsevenController.dispose();
    super.dispose();
  }
}

