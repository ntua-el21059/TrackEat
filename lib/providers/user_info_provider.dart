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
    if (_user?.email != null) {
      // If we already have a user, get the current data from Firestore
      final currentUser = await _firestoreService.getUser(_user!.email!);
      if (currentUser != null) {
        // Preserve all existing values and only update non-null values from the new user
        _user = currentUser.copyWith(
          firstName: user.firstName ?? currentUser.firstName,
          lastName: user.lastName ?? currentUser.lastName,
          username: user.username ?? currentUser.username,
          birthdate: user.birthdate ?? currentUser.birthdate,
          gender: user.gender ?? currentUser.gender,
          height: user.height ?? currentUser.height,
          dailyCalories: user.dailyCalories ?? currentUser.dailyCalories,
          activity: user.activity ?? currentUser.activity,
          diet: user.diet ?? currentUser.diet,
          goal: user.goal ?? currentUser.goal,
          weight: user.weight ?? currentUser.weight,
        );
      } else {
        _user = user;
      }
    } else {
      _user = user;
    }
    
    // Update local state
    _birthdate = _user?.birthdate ?? _birthdate;
    _gender = _user?.gender ?? _gender;
    _height = _user?.height ?? _height;
    _dailyCalories = _user?.dailyCalories ?? _dailyCalories;
    
    notifyListeners();
  }

  // Fetch current user data
  Future<void> fetchCurrentUser() async {
    if (_user?.email != null) {
      final currentUser = await _firestoreService.getUser(_user!.email!);
      if (currentUser != null) {
        await setUser(currentUser);
      }
    }
  }

  // Update methods
  Future<void> updateBirthdate(String date) async {
    _birthdate = date;
    if (_user != null) {
      // Get current user data from Firestore
      final currentUser = await _firestoreService.getUser(_user!.email!);
      if (currentUser != null) {
        // Create new user model with updated birthdate but preserve all other fields
        _user = currentUser.copyWith(birthdate: date);
        await _firestoreService.createUser(_user!);
      }
    }
    notifyListeners();
  }

  Future<void> updateName(String firstName, String lastName) async {
    if (_user != null) {
      // Get current user data from Firestore
      final currentUser = await _firestoreService.getUser(_user!.email!);
      if (currentUser != null) {
        // Create new user model with updated name but preserve all other fields
        _user = currentUser.copyWith(firstName: firstName, lastName: lastName);
        await _firestoreService.createUser(_user!);
        notifyListeners();
      }
    }
  }

  Future<void> updateUsername(String username) async {
    if (_user != null) {
      // Get current user data from Firestore
      final currentUser = await _firestoreService.getUser(_user!.email!);
      if (currentUser != null) {
        // Create new user model with updated username but preserve all other fields
        _user = currentUser.copyWith(username: username);
        await _firestoreService.createUser(_user!);
        notifyListeners();
      }
    }
  }

  Future<void> updateDailyCalories(String calories) async {
    _dailyCalories = int.tryParse(calories) ?? 0;
    if (_user != null) {
      // Get current user data from Firestore
      final currentUser = await _firestoreService.getUser(_user!.email!);
      if (currentUser != null) {
        // Create new user model with updated calories but preserve all other fields
        _user = currentUser.copyWith(dailyCalories: _dailyCalories);
        await _firestoreService.createUser(_user!);
      }
    }
    notifyListeners();
  }

  Future<void> updateGender(String newGender) async {
    _gender = newGender;
    if (_user != null) {
      // Get current user data from Firestore
      final currentUser = await _firestoreService.getUser(_user!.email!);
      if (currentUser != null) {
        // Create new user model with updated gender but preserve all other fields
        _user = currentUser.copyWith(gender: newGender);
        await _firestoreService.createUser(_user!);
      }
    }
    notifyListeners();
  }

  Future<void> updateHeight(String newHeight) async {
    _height = double.tryParse(newHeight) ?? 0;
    if (_user != null) {
      // Get current user data from Firestore
      final currentUser = await _firestoreService.getUser(_user!.email!);
      if (currentUser != null) {
        // Create new user model with updated height but preserve all other fields
        _user = currentUser.copyWith(height: _height);
        await _firestoreService.createUser(_user!);
      }
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