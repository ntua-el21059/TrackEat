import 'package:flutter/material.dart';
import '../models/create_account_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

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
  String? reenterPasswordError;

  Timer? _usernameDebounce;
  Timer? _emailDebounce;

  CreateAccountProvider() {
    userNameController.addListener(() {
      _textChanged();
      if (userNameController.text.isNotEmpty) {
        if (_usernameDebounce?.isActive ?? false) _usernameDebounce!.cancel();
        _usernameDebounce = Timer(const Duration(milliseconds: 500), () {
          validateUsername(userNameController.text);
        });
      } else {
        clearUsernameError();
      }
    });
    
    emailtwoController.addListener(() {
      _textChanged();
      if (emailtwoController.text.isNotEmpty) {
        if (_emailDebounce?.isActive ?? false) _emailDebounce!.cancel();
        _emailDebounce = Timer(const Duration(milliseconds: 500), () {
          validateEmail(emailtwoController.text);
        });
      } else {
        clearEmailError();
      }
    });
    
    passwordtwoController.addListener(() {
      _textChanged();
      validatePasswords();
    });

    passwordthreeController.addListener(() {
      _textChanged();
      validatePasswords();
    });
    
    passwordController.addListener(_textChanged);
  }

  void _textChanged() {
    notifyListeners();
  }

  Future<void> validateUsername(String username) async {
    final usernameQuery = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
    
    if (usernameQuery.docs.isNotEmpty) {
      setUsernameError("This username already exists!");
    } else {
      clearUsernameError();
    }
  }

  Future<void> validateEmail(String email) async {
    final emailQuery = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    
    if (emailQuery.docs.isNotEmpty) {
      setEmailError("This email already exists!");
    } else {
      clearEmailError();
    }
  }

  void clearUsernameError() {
    usernameError = null;
    notifyListeners();
  }

  void clearEmailError() {
    emailError = null;
    notifyListeners();
  }

  void clearErrors() {
    clearUsernameError();
    clearEmailError();
    passwordError = null;
    reenterPasswordError = null;
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

  void validatePasswords() {
    // Check first password length
    if (passwordtwoController.text.length < 6) {
      passwordError = "Password must be at least 6 characters";
    } else {
      passwordError = null;
    }

    // Check if passwords match only if both fields have content
    if (passwordtwoController.text.isNotEmpty && 
        passwordthreeController.text.isNotEmpty) {
      if (passwordtwoController.text != passwordthreeController.text) {
        reenterPasswordError = "Passwords do not match";
      } else {
        reenterPasswordError = null;
      }
    } else {
      reenterPasswordError = null;
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _usernameDebounce?.cancel();
    _emailDebounce?.cancel();
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