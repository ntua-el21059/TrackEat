import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import '../models/create_profile_1_2_model.dart';

/// A provider class for the CreateProfile12Screen.
///
/// This provider manages the state of the CreateProfile12Screen, including the
/// current createProfile12ModelObj.
// ignore_for_file: must_be_immutable
class CreateProfile12Provider extends ChangeNotifier {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController gendertwoController = TextEditingController();
  CreateProfile12Model createProfile12ModelObj = CreateProfile12Model();

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    dateController.dispose();
    gendertwoController.dispose();
  }
}