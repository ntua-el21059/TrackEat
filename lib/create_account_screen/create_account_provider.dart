import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../routes/app_routes.dart';
import '../widgets.dart';
import 'create_account_screen.dart';

class CreateAccountModel {}

/// A provider class for the CreateAccountScreen.
///
/// This provider manages the state of the CreateAccountScreen, including the
/// current createAccountModelObj
// ignore_for_file: must_be_immutable
class CreateAccountProvider extends ChangeNotifier {
  TextEditingController usernameInputController = TextEditingController();
  TextEditingController emailInputController = TextEditingController();
  TextEditingController passwordInputController = TextEditingController();
  TextEditingController reenterPasswordInputController = TextEditingController();

  CreateAccountModel createAccountModelObj = CreateAccountModel();

  bool isShowPassword = true;
  bool isShowPassword1 = true;

  @override
  void dispose() {
    super.dispose();
    usernameInputController.dispose();
    emailInputController.dispose();
    passwordInputController.dispose();
    reenterPasswordInputController.dispose();
  }

  void changePasswordVisibility() {
    isShowPassword = !isShowPassword;
    notifyListeners();
  }

  void changePasswordVisibility1() {
    isShowPassword1 = !isShowPassword1;
    notifyListeners();
  }
}
