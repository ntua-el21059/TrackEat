import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../routes/app_routes.dart';
import '../widgets.dart';
import 'create_profile_1_2_screen.dart';

class CreateProfile12Model {
  // ignore_for_file: must_be_immutable
  String birthdateInput = "";
  DateTime? selectedBirthdateInput;
}

class CreateProfile12Provider extends ChangeNotifier {
  // ignore_for_file: must_be_immutable
  /// A provider class for the CreateProfile12Screen.
  ///
  /// This provider manages the state of the CreateProfile12Screen, including the
  /// current createProfile12ModelObj

  TextEditingController firstNameInputController = TextEditingController();
  TextEditingController lastNameInputController = TextEditingController();
  TextEditingController genderInputController = TextEditingController();
  TextEditingController birthdateInputController = TextEditingController();

  CreateProfile12Model createProfile12ModelObj = CreateProfile12Model();

  @override
  void dispose() {
    firstNameInputController.dispose();
    lastNameInputController.dispose();
    genderInputController.dispose();
    birthdateInputController.dispose();
    super.dispose();
  }
}
