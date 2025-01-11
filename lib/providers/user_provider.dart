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
    required double height,
  }) {
    _user.firstName = firstName;
    _user.lastName = lastName;
    _user.birthdate = birthdate;
    _user.gender = gender;
    _user.height = height;
    notifyListeners();
  }

  // Profile 2/3
  void setProfile2Info({
    required String activity,
    String? diet,
    required String goal,
    required double weight,
    required double weeklygoal,
    required double weightgoal,
  }) {
    _user.activity = activity;
    _user.diet = diet;
    _user.goal = goal;
    _user.weight = weight;
    _user.weeklygoal = weeklygoal;
    _user.weightgoal = weightgoal;
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
    double? carbsgoal,
    double? proteingoal,
    double? fatgoal,
  }) {
    bool changed = false;
    if (carbsgoal != null && _user.carbsgoal != carbsgoal) {
      _user.carbsgoal = carbsgoal;
      changed = true;
    }
    if (proteingoal != null && _user.proteingoal != proteingoal) {
      _user.proteingoal = proteingoal;
      changed = true;
    }
    if (fatgoal != null && _user.fatgoal != fatgoal) {
      _user.fatgoal = fatgoal;
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