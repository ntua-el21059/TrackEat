import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoProvider extends ChangeNotifier {
  String _firstName = 'John';
  String _lastName = 'Appleseed';
  String _username = 'jappleseed';
  final SharedPreferences _prefs;

  UserInfoProvider(this._prefs) {
    _loadUserInfo();
  }

  String get firstName => _firstName;
  String get lastName => _lastName;
  String get username => _username;
  String get fullName => '$_firstName $_lastName';

  Future<void> _loadUserInfo() async {
    _firstName = _prefs.getString('user_first_name') ?? 'John';
    _lastName = _prefs.getString('user_last_name') ?? 'Appleseed';
    _username = _prefs.getString('username') ?? 'jappleseed';
    notifyListeners();
  }

  Future<void> updateName(String firstName, String lastName) async {
    _firstName = firstName;
    _lastName = lastName;
    await _prefs.setString('user_first_name', firstName);
    await _prefs.setString('user_last_name', lastName);
    notifyListeners();
  }

  Future<void> updateUsername(String newUsername) async {
    _username = newUsername;
    await _prefs.setString('username', newUsername);
    notifyListeners();
  }
} 