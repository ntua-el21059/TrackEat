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
  String get firstName => _user?.firstName ?? 'User';
  String get lastName => _user?.lastName ?? '';
  String get username => _user?.username ?? 'user';
  String get fullName => '${firstName} ${lastName}'.trim();

  // Update methods
  Future<void> updateBirthdate(String date) async {
    _birthdate = date;
    if (_user != null) {
      _user = _user!.copyWith(birthdate: date);
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

  Future<void> updateDailyCalories(String calories) async {
    _dailyCalories = int.tryParse(calories) ?? 0;
    if (_user != null) {
      _user = _user!.copyWith(dailyCalories: _dailyCalories);
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

  Future<void> updateUsername(String newUsername) async {
    if (_user != null) {
      _user = _user!.copyWith(username: newUsername);
      await _firestoreService.createUser(_user!);
      notifyListeners();
    }
  }

  Future<void> clearUserInfo() async {
    _birthdate = '';
    _gender = '';
    _height = 0;
    _dailyCalories = 0;
    _user = null;
    notifyListeners();
  }

  Future<void> setUser(UserModel user) async {
    _user = user;
    _birthdate = user.birthdate ?? '';
    _gender = user.gender ?? '';
    _height = user.height ?? 0;
    _dailyCalories = user.dailyCalories ?? 0;
    notifyListeners();
  }
} 