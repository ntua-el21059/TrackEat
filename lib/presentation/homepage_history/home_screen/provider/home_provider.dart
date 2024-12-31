import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/home_initial_model.dart';

/// A provider class for the HomeScreen.
///
/// This provider manages the state of the HomeScreen, including the
/// current homeModelObj
// ignore_for_file: must_be_immutable
class HomeProvider extends ChangeNotifier {
  HomeInitialModel homeInitialModelObj = HomeInitialModel();
  int _dailyCalories = 2000; // Default value
  
  int get dailyCalories => _dailyCalories;

  HomeProvider() {
    listenToDailyCalories();
  }

  void listenToDailyCalories() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists) {
          _dailyCalories = snapshot.data()?['dailyCalories'] ?? 2000;
          notifyListeners();
        }
      });
    }
  }
}
