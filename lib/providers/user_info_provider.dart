import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/firebase/firestore/firestore_service.dart';

class UserInfoProvider with ChangeNotifier {
  UserModel? _user;
  final FirestoreService _firestoreService = FirestoreService();
  StreamSubscription<DocumentSnapshot>? _userSubscription;

  UserInfoProvider() {
    _initializeUserListener();
  }

  void _initializeUserListener() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // Set up real-time listener for user document
      _userSubscription = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.email)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists) {
          final userData = snapshot.data() as Map<String, dynamic>;
          _user = UserModel.fromJson(userData);
          notifyListeners();
        }
      });
    }
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    super.dispose();
  }

  String get firstName => _user?.firstName ?? '';
  String get lastName => _user?.lastName ?? '';
  String get fullName => '${_user?.firstName ?? ''} ${_user?.lastName ?? ''}'.trim();
  String get email => _user?.email ?? '';
  String get username => _user?.username ?? '';
  String get birthdate => _user?.birthdate ?? '';
  String get gender => _user?.gender ?? '';
  String get activity => _user?.activity ?? '';
  double get height => _user?.height ?? 0.0;
  double get weight => _user?.weight ?? 0.0;
  int get dailyCalories => _user?.dailyCalories ?? 0;

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
        await _firestoreService.createUser(_user!);
      } else {
        _user = user;
        await _firestoreService.createUser(_user!);
      }
    } else {
      _user = user;
      await _firestoreService.createUser(_user!);
    }
    notifyListeners();
  }

  Future<void> fetchCurrentUser() async {
    if (_user?.email != null) {
      final currentUser = await _firestoreService.getUser(_user!.email!);
      if (currentUser != null) {
        await setUser(currentUser);
      }
    }
  }

  Future<void> updateName(String firstName, String lastName) async {
    if (_user != null) {
      final currentUser = await _firestoreService.getUser(_user!.email!);
      if (currentUser != null) {
        _user = currentUser.copyWith(firstName: firstName, lastName: lastName);
        await _firestoreService.createUser(_user!);
        notifyListeners();
      }
    }
  }

  Future<void> updateUsername(String username) async {
    if (_user != null) {
      final currentUser = await _firestoreService.getUser(_user!.email!);
      if (currentUser != null) {
        _user = currentUser.copyWith(username: username);
        await _firestoreService.createUser(_user!);
        notifyListeners();
      }
    }
  }

  Future<void> updateBirthdate(String date) async {
    if (_user != null) {
      final currentUser = await _firestoreService.getUser(_user!.email!);
      if (currentUser != null) {
        _user = currentUser.copyWith(birthdate: date);
        await _firestoreService.createUser(_user!);
        notifyListeners();
      }
    }
  }

  Future<void> updateGender(String newGender) async {
    if (_user != null) {
      final currentUser = await _firestoreService.getUser(_user!.email!);
      if (currentUser != null) {
        _user = currentUser.copyWith(gender: newGender);
        await _firestoreService.createUser(_user!);
        notifyListeners();
      }
    }
  }

  Future<void> updateHeight(String newHeight) async {
    if (_user != null) {
      final currentUser = await _firestoreService.getUser(_user!.email!);
      if (currentUser != null) {
        _user = currentUser.copyWith(height: double.tryParse(newHeight) ?? 0.0);
        await _firestoreService.createUser(_user!);
        notifyListeners();
      }
    }
  }

  Future<void> updateDailyCalories(String calories) async {
    if (_user != null) {
      final currentUser = await _firestoreService.getUser(_user!.email!);
      if (currentUser != null) {
        _user = currentUser.copyWith(dailyCalories: int.tryParse(calories) ?? 0);
        await _firestoreService.createUser(_user!);
        notifyListeners();
      }
    }
  }

  Future<void> clearUserInfo() async {
    _user = null;
    notifyListeners();
  }
} 