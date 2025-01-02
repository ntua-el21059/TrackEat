import 'package:flutter/material.dart';
import '../models/create_account_model.dart';

/// A provider class for the CreateAccountScreen.
///
/// This provider manages the state of the CreateAccountScreen, including the
/// current createAccountModelObj.
// ignore_for_file: must_be_immutable
class CreateAccountProvider extends ChangeNotifier {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailtwoController = TextEditingController();
  TextEditingController passwordtwoController = TextEditingController();
  TextEditingController passwordthreeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  CreateAccountModel createAccountModelObj = CreateAccountModel();

  bool isShowPassword = true;
  bool isShowPassword1 = true;
  bool isPasswordVisible = false;

  String? usernameError;
  String? emailError;
  String? passwordError;

  CreateAccountProvider() {
    userNameController.addListener(_textChanged);
    emailtwoController.addListener(_textChanged);
    passwordtwoController.addListener(_textChanged);
    passwordthreeController.addListener(_textChanged);
    passwordController.addListener(_textChanged);
  }

  void _textChanged() {
    notifyListeners();
  }

  void clearErrors() {
    usernameError = null;
    emailError = null;
    passwordError = null;
    notifyListeners();
  }

  void setUsernameError(String error) {
    usernameError = error;
    notifyListeners();
  }

  void setEmailError(String error) {
    emailError = error;
    notifyListeners();
  }

  void setPasswordError(String error) {
    passwordError = error;
    notifyListeners();
  }

  void changePasswordVisibility() {
    isShowPassword = !isShowPassword;
    notifyListeners();
  }

  void changePasswordVisibility1() {
    isShowPassword1 = !isShowPassword1;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  @override
  void dispose() {
    userNameController.removeListener(_textChanged);
    emailtwoController.removeListener(_textChanged);
    passwordtwoController.removeListener(_textChanged);
    passwordthreeController.removeListener(_textChanged);
    passwordController.removeListener(_textChanged);
    userNameController.dispose();
    emailtwoController.dispose();
    passwordtwoController.dispose();
    passwordthreeController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}