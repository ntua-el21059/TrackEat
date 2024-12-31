import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase/auth/auth_service.dart';
import '../services/firebase/firestore/firestore_service.dart';
import '../models/user_model.dart';

class UserInfoProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  UserModel? _user;

  String _birthdate = '';
  String _gender = '';
  double _height = 0;
  int _dailyCalories = 0;

  UserInfoProvider() {
    _loadUserInfo();
    // Listen to auth state changes
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        _loadUserInfo();
      } else {
        _user = null;
        notifyListeners();
      }
    });
  }

  String get firstName => _user?.firstName ?? 'User';
  String get lastName => _user?.lastName ?? '';
  String get username => _user?.username ?? 'user';
  String get fullName => '${firstName} ${lastName}'.trim();

  String get birthdate => _birthdate;
  String get gender => _gender;
  String get height => _height.toString();
  int get dailyCalories => _dailyCalories;

  Future<void> _loadUserInfo() async {
    try {
      final currentUser = _authService.currentUser;
      if (currentUser?.email != null) {
        print('Loading user info for email: ${currentUser!.email}');
        _user = await _firestoreService.getUser(currentUser.email!);
        print('Loaded user info: ${_user?.toJson()}');
        notifyListeners();
      }
    } catch (e) {
      print('Error loading user info: $e');
    }
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

  Future<void> updateBirthdate(String date) async {
    _birthdate = date;
    notifyListeners();
  }

  Future<void> updateGender(String newGender) async {
    _gender = newGender;
    notifyListeners();
  }

  Future<void> updateHeight(String newHeight) async {
    String cleanHeight = newHeight.replaceAll(' cm', '');
    _height = double.tryParse(cleanHeight) ?? 0;
    notifyListeners();
  }

  Future<void> updateDailyCalories(String calories) async {
    _dailyCalories = int.tryParse(calories) ?? 0;
    notifyListeners();
  }

  Future<void> clearUserInfo() async {
    _birthdate = '';
    _gender = '';
    _height = 0;
    _dailyCalories = 0;
    notifyListeners();
  }
} 