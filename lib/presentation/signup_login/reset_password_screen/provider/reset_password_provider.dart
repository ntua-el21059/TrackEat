import 'package:flutter/material.dart';
import '../models/reset_password_model.dart';

/// A provider class for the ResetPasswordScreen.
///
/// This provider manages the state of the ResetPasswordScreen, including the
/// current resetPasswordModelObj
// ignore_for_file: must_be_immutable
class ResetPasswordProvider extends ChangeNotifier {
  TextEditingController newpasswordController = TextEditingController();
  TextEditingController newpasswordoneController = TextEditingController();
  ResetPasswordModel resetPasswordModelObj = ResetPasswordModel();

  bool isShowPassword = true;
  bool isShowPassword1 = true;

  @override
  void dispose() {
    newpasswordController.dispose();
    newpasswordoneController.dispose();
    super.dispose();
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
