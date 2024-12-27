import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
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
  CreateAccountModel createAccountModelObj = CreateAccountModel();

  bool isShowPassword = true;
  bool isShowPassword1 = true;

  @override
  void dispose() {
    super.dispose();
    userNameController.dispose();
    emailtwoController.dispose();
    passwordtwoController.dispose();
    passwordthreeController.dispose();
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