import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoProvider with ChangeNotifier {
  String _firstName = '';
  String _lastName = '';
  String _username = '';
  String _birthdate = '';
  String _gender = '';
  String _height = '';
  String _dailyCalories = '';
  final SharedPreferences _prefs;

  UserInfoProvider(this._prefs) {
    print("Initializing UserInfoProvider");
    _loadUserInfo();
  }

  String get firstName {
    print("Getting firstName: '$_firstName'");
    return _firstName;
  }
  
  String get lastName {
    print("Getting lastName: '$_lastName'");
    return _lastName;
  }
  
  String get username {
    print("Getting username: '$_username'");
    return _username;
  }

  String get fullName {
    print("Getting fullName: '$_firstName $_lastName'");
    return '$_firstName $_lastName'.trim();
  }

  String get birthdate => _birthdate;
  String get gender => _gender;
  String get height => _height;
  String get dailyCalories => _dailyCalories;

  Future<void> updateName(String firstName, String lastName) async {
    print("\n=== UserInfoProvider.updateName ===");
    print("Current values:");
    print("_firstName: '$_firstName'");
    print("_lastName: '$_lastName'");
    
    print("\nNew values:");
    print("firstName: '$firstName'");
    print("lastName: '$lastName'");

    _firstName = firstName;
    _lastName = lastName;

    print("\nSaving to SharedPreferences...");
    await _prefs.setString('user_first_name', firstName);
    await _prefs.setString('user_last_name', lastName);

    print("\nVerifying saved values:");
    final savedFirstName = _prefs.getString('user_first_name');
    final savedLastName = _prefs.getString('user_last_name');
    print("Saved firstName: '$savedFirstName'");
    print("Saved lastName: '$savedLastName'");

    print("\nCalling notifyListeners()");
    notifyListeners();
    Future.microtask(() => notifyListeners());
    print("Update complete");
  }

  Future<void> _loadUserInfo() async {
    print("\n=== UserInfoProvider._loadUserInfo ===");
    _firstName = _prefs.getString('user_first_name') ?? '';
    _lastName = _prefs.getString('user_last_name') ?? '';
    _username = _prefs.getString('username') ?? '';
    _birthdate = _prefs.getString('user_birthdate') ?? '';
    _gender = _prefs.getString('user_gender') ?? '';
    _height = _prefs.getString('user_height') ?? '';
    _dailyCalories = _prefs.getString('user_daily_calories') ?? '';
    
    print("Loaded values:");
    print("firstName: '$_firstName'");
    print("lastName: '$_lastName'");
    print("username: '$_username'");
    print("birthdate: '$_birthdate'");
    print("gender: '$_gender'");
    print("height: '$_height'");
    print("dailyCalories: '$_dailyCalories'");
    
    notifyListeners();
  }

  Future<void> updateUsername(String newUsername) async {
    _username = newUsername;
    await _prefs.setString('username', newUsername);
    notifyListeners();
  }

  Future<void> updateBirthdate(String birthdate) async {
    _birthdate = birthdate;
    await _prefs.setString('user_birthdate', birthdate);
    notifyListeners();
  }

  Future<void> updateGender(String gender) async {
    _gender = gender;
    await _prefs.setString('user_gender', gender);
    notifyListeners();
  }

  Future<void> updateHeight(String height) async {
    _height = height;
    await _prefs.setString('user_height', height);
    notifyListeners();
  }

  Future<void> updateDailyCalories(String calories) async {
    _dailyCalories = calories;
    await _prefs.setString('user_daily_calories', calories);
    notifyListeners();
  }

  Future<void> clearUserInfo() async {
    await _prefs.remove('user_first_name');
    await _prefs.remove('user_last_name');
    await _prefs.remove('username');
    await _prefs.remove('user_birthdate');
    await _prefs.remove('user_gender');
    await _prefs.remove('user_height');
    await _prefs.remove('user_daily_calories');
    _firstName = '';
    _lastName = '';
    _username = '';
    _birthdate = '';
    _gender = '';
    _height = '';
    _dailyCalories = '';
    notifyListeners();
  }

  void silentUpdateName(String firstName, String lastName) {
    _firstName = firstName;
    _lastName = lastName;
    notifyListeners();
  }

  void silentUpdateUsername(String username) {
    _username = username;
    notifyListeners();
  }

  void silentUpdateBirthdate(String birthdate) {
    _birthdate = birthdate;
    notifyListeners();
  }

  void silentUpdateGender(String gender) {
    _gender = gender;
    notifyListeners();
  }

  void silentUpdateHeight(String height) {
    _height = height;
    notifyListeners();
  }

  Future<void> updateAllValues({
    required String firstName,
    required String lastName,
    required String username,
    required String birthdate,
    required String gender,
    required String height,
  }) async {
    _firstName = firstName;
    _lastName = lastName;
    _username = username;
    _birthdate = birthdate;
    _gender = gender;
    _height = height;
    notifyListeners();
  }
} 