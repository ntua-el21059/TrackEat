import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase/auth/auth_service.dart';
import '../services/firebase/firestore/firestore_service.dart';
import '../models/user_model.dart';

class UserInfoProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  UserModel? _user;

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
} 