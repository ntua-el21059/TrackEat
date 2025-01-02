import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/firebase/firestore/firestore_service.dart';

class UserProvider extends ChangeNotifier {
  UserModel _user = UserModel();
  final FirestoreService _firestoreService = FirestoreService();

  UserModel get user => _user;

  // Create Account Screen
  void setAccountInfo({
    required String username,
    required String email,
    required String password,
  }) {
    _user.username = username;
    _user.email = email;
    _user.password = password;
    notifyListeners();
  }

  // Profile 1/3
  void setProfile1Info({
    required String firstName,
    required String lastName,
    required String birthdate,
    required String gender,
  }) {
    _user.firstName = firstName;
    _user.lastName = lastName;
    _user.birthdate = birthdate;
    _user.gender = gender;
    notifyListeners();
  }

  // Profile 2/3
  void setProfile2Info({
    required String activity,
    String? diet,
    required String goal,
    required double height,
    required double weight,
  }) {
    _user.activity = activity;
    _user.diet = diet;
    _user.goal = goal;
    _user.height = height;
    _user.weight = weight;
    notifyListeners();
  }

  // Profile 3/3
  void setDailyCalories(int calories) {
    if (_user.dailyCalories != calories) {
      _user.dailyCalories = calories;
      notifyListeners();
      // Save to Firestore
      saveToFirestore();
    }
  }

  void setMacronutrientGoals({
    double? carbsGoal,
    double? proteinGoal,
    double? fatGoal,
  }) {
    bool changed = false;
    if (carbsGoal != null && _user.carbsGoal != carbsGoal) {
      _user.carbsGoal = carbsGoal;
      changed = true;
    }
    if (proteinGoal != null && _user.proteinGoal != proteinGoal) {
      _user.proteinGoal = proteinGoal;
      changed = true;
    }
    if (fatGoal != null && _user.fatGoal != fatGoal) {
      _user.fatGoal = fatGoal;
      changed = true;
    }
    if (changed) {
      notifyListeners();
      // Save to Firestore
      saveToFirestore();
    }
  }

  // Save to Firestore
  Future<void> saveToFirestore() async {
    if (_user.email == null) {
      throw Exception('Cannot save to Firestore: email is null');
    }
    
    try {
      await _firestoreService.createUser(_user);
    } catch (e) {
      print('Error saving user to Firestore: $e');
      rethrow;
    }
  }

  void clear() {
    _user = UserModel();
    notifyListeners();
  }
} 