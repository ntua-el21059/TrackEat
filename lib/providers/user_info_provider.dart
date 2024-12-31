import 'package:flutter/material.dart';
import '../services/firebase/firestore/firestore_service.dart';
import '../models/user_model.dart';

class UserInfoProvider extends ChangeNotifier {
  String _birthdate = '';
  String _gender = '';
  double _height = 0;
  int _dailyCalories = 0;
  final FirestoreService _firestoreService = FirestoreService();
  UserModel? _user;

  // Getters
  String get birthdate => _birthdate;
  String get gender => _gender;
  String get height => _height.toString();
  int get dailyCalories => _dailyCalories;
  String get firstName => _user?.firstName ?? '';
  String get lastName => _user?.lastName ?? '';
  String get username => _user?.username ?? '';
  String get fullName => '${firstName} ${lastName}'.trim();

  // Set user data
  Future<void> setUser(UserModel user) async {
    _user = user;
    _birthdate = user.birthdate ?? _birthdate;
    _gender = user.gender ?? _gender;
    _height = user.height ?? _height;
    _dailyCalories = user.dailyCalories ?? _dailyCalories;
    notifyListeners();
  }

  // Update methods
  Future<void> updateBirthdate(String date) async {
    _birthdate = date;
    if (_user != null) {
      _user = _user!.copyWith(birthdate: date);
      await _firestoreService.createUser(_user!);
    }
    notifyListeners();
  }

  Future<void> updateName(String firstName, String lastName) async {
    if (_user != null) {
      _user = _user!.copyWith(firstName: firstName, lastName: lastName);
      await _firestoreService.createUser(_user!);
      notifyListeners();
    }
  }

  Future<void> updateUsername(String username) async {
    if (_user != null) {
      _user = _user!.copyWith(username: username);
      await _firestoreService.createUser(_user!);
      notifyListeners();
    }
  }

  Future<void> updateDailyCalories(String calories) async {
    _dailyCalories = int.tryParse(calories) ?? 0;
    if (_user != null) {
      _user = _user!.copyWith(dailyCalories: _dailyCalories);
      await _firestoreService.createUser(_user!);
    }
    notifyListeners();
  }

  Future<void> updateGender(String newGender) async {
    _gender = newGender;
    if (_user != null) {
      _user = _user!.copyWith(gender: newGender);
      await _firestoreService.createUser(_user!);
    }
    notifyListeners();
  }

  Future<void> updateHeight(String newHeight) async {
    _height = double.tryParse(newHeight) ?? 0;
    if (_user != null) {
      _user = _user!.copyWith(height: _height);
      await _firestoreService.createUser(_user!);
    }
    notifyListeners();
  }

  Future<void> clearUserInfo() async {
    _birthdate = '';
    _gender = '';
    _height = 0;
    _dailyCalories = 0;
    _user = null;
    notifyListeners();
  }
} 