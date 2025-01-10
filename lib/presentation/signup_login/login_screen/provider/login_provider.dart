import 'package:flutter/material.dart';
import '../models/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool? keepmesignedin = false;
  bool isLoading = false;
  String? emailError;
  String? passwordError;

  // Keys for SharedPreferences
  static const String _rememberMeKey = 'remember_me';
  static const String _savedEmailKey = 'saved_email';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userEmailKey = 'user_email';

  LoginProvider() {
    _loadSavedState();
    userNameController.addListener(_textChanged);
    passwordtwoController.addListener(_textChanged);
  }

  Future<void> _loadSavedState() async {
    final prefs = await SharedPreferences.getInstance();
    keepmesignedin = prefs.getBool(_rememberMeKey) ?? false;
    if (keepmesignedin!) {
      userNameController.text = prefs.getString(_savedEmailKey) ?? '';
    }
    notifyListeners();
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMeKey, keepmesignedin ?? false);
    if (keepmesignedin!) {
      await prefs.setString(_savedEmailKey, userNameController.text);
    } else {
      await prefs.remove(_savedEmailKey);
    }
  }

  Future<void> saveLoginState(String email) async {
    if (keepmesignedin!) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setString(_userEmailKey, email);
    }
  }

  static Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<String?> getLoggedInUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  static Future<void> clearLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_userEmailKey);
  }

  void _textChanged() {
    // Clear errors when user starts typing
    if (emailError != null || passwordError != null) {
      clearErrors();
    }
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

  void clearErrors() {
    emailError = null;
    passwordError = null;
    notifyListeners();
  }

  void changePasswordVisibility() {
    isShowPassword = !isShowPassword;
    notifyListeners();
  }

  void changeCheckBox(bool? value) {
    keepmesignedin = value;
    _saveState(); // Save state when checkbox changes
    notifyListeners();
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    userNameController.removeListener(_textChanged);
    passwordtwoController.removeListener(_textChanged);
    userNameController.dispose();
    passwordtwoController.dispose();
    super.dispose();
  }
}
