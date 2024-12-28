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
    print('Setting account info - username: $username, email: $email');
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
    print('Setting profile 1 info - firstName: $firstName, lastName: $lastName');
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
    print('Setting profile 2 info - activity: $activity, goal: $goal');
    _user.activity = activity;
    _user.diet = diet;
    _user.goal = goal;
    _user.height = height;
    _user.weight = weight;
    notifyListeners();
  }

  // Profile 3/3
  void setDailyCalories(int calories) {
    print('Setting daily calories: $calories');
    _user.dailyCalories = calories;
    notifyListeners();
  }

  // Save to Firestore
  Future<void> saveToFirestore() async {
    print('Attempting to save user to Firestore');
    print('Current user data: ${_user.toJson()}');
    
    if (_user.email == null) {
      print('Error: Cannot save to Firestore - email is null');
      throw Exception('Cannot save to Firestore: email is null');
    }
    
    try {
      await _firestoreService.createUser(_user);
      print('Successfully saved user to Firestore');
    } catch (e) {
      print('Error saving user to Firestore: $e');
      rethrow;
    }
  }

  void clear() {
    print('Clearing user data');
    _user = UserModel();
    notifyListeners();
  }
} 