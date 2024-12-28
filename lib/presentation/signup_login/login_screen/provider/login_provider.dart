import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import '../models/login_model.dart';

/// A provider class for the LoginScreen.
///
/// This provider manages the state of the LoginScreen, including the
/// current loginModelObj
// ignore_for_file: must_be_immutable
class LoginProvider extends ChangeNotifier {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordtwoController = TextEditingController();
  LoginModel loginModelObj = LoginModel();

  bool isShowPassword = true;
  bool keepmesignedin = false;

  @override
  void dispose() {
    userNameController.dispose();
    passwordtwoController.dispose();
    super.dispose();
  }

  void changePasswordVisibility() {
    isShowPassword = !isShowPassword;
    notifyListeners();
  }

  void changeCheckBox(bool value) {
    keepmesignedin = value;
    notifyListeners();
  }
}
