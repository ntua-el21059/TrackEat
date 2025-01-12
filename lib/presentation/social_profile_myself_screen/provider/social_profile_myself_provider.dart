import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/social_profile_myself_model.dart';
import '../models/listvegan_item_model.dart';
import '../../profile_screen/provider/profile_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class SocialProfileMyselfProvider extends ChangeNotifier {
  SocialProfileMyselfModel _socialProfileMyselfModelObj = SocialProfileMyselfModel();
  int _weightGoalProgress = 50;
  String selectedDiet = '';
  Color dietBoxColor = Colors.grey;
  String dietEmoji = '🍽️';
  StreamSubscription<DocumentSnapshot>? _userSubscription;

  Map<String, Color> dietColors = {
    'Balanced': const Color(0xFF90CAF9),
    'Keto': const Color(0xFFA726),
    'Vegan': const Color(0xFF81C784),
    'Vegetarian': const Color(0xFF4CAF50),
    'Carnivore': const Color(0xFFEF5350),
    'Fruitarian': const Color(0xFF4081),
  };

  Map<String, String> dietEmojis = {
    'Balanced': '⚖️',
    'Keto': '🥑',
    'Vegan': '🌱',
    'Vegetarian': '🥗',
    'Carnivore': '🥩',
    'Fruitarian': '🍎',
  };

  SocialProfileMyselfModel get socialProfileMyselfModelObj => _socialProfileMyselfModelObj;
  int get weightGoalProgress => _weightGoalProgress;

  void updateWeightGoalProgress(int progress) {
    _weightGoalProgress = progress;
    notifyListeners();
  }

  String _calculateTimeDifference(String createdDate) {
    try {
      final parts = createdDate.split('/');
      if (parts.length != 3) return "some time";

      final createdDateTime = DateTime(
        int.parse(parts[2]), // year
        int.parse(parts[1]), // month
        int.parse(parts[0]), // day
      );
      
      final now = DateTime.now();
      final difference = now.difference(createdDateTime);
      final days = difference.inDays;
      
      if (days >= 365) {
        final years = days ~/ 365;
        return "$years year${years > 1 ? 's' : ''}";
      } else if (days >= 30) {
        final months = (days / 30.44).floor();
        return "$months month${months > 1 ? 's' : ''}";
      } else {
        return "$days day${days > 1 ? 's' : ''}";
      }
    } catch (e) {
      return "some time";
    }
  }

  void updateDietBox(String diet) {
    selectedDiet = diet;
    dietBoxColor = dietColors[diet] ?? Colors.grey;
    dietEmoji = dietEmojis[diet] ?? '🍽️';
    
    // Update the diet item
    if (_socialProfileMyselfModelObj.listveganItemList.isNotEmpty) {
      _socialProfileMyselfModelObj.listveganItemList[0] = ListveganItemModel(
        title: '$diet${dietEmojis[diet] ?? ''}',
        count: '',
      );
    }
    
    notifyListeners();
  }

  void _setupUserListener() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser?.email == null) return;

    _userSubscription?.cancel();
    _userSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.email)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data()!;
        final firstName = data['firstName']?.toString() ?? '';
        final createdDate = data['create']?.toString();
        
        String timeDifference = "some time";
        if (createdDate != null && createdDate.isNotEmpty) {
          timeDifference = _calculateTimeDifference(createdDate);
        }

        // Update the thriving message with the user's name
        if (_socialProfileMyselfModelObj.listveganItemList.length > 1) {
          _socialProfileMyselfModelObj.listveganItemList[1] = ListveganItemModel(
            title: "$firstName has been thriving \nwith us for $timeDifference!",
            count: "⭐️",
            username: currentUser.email,
          );
          notifyListeners();
        }
      }
    });
  }

  void init(BuildContext context) {
    try {
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      final currentDiet = profileProvider.profileModelObj.profileItemList
          .firstWhere((item) => item.title == "Diet")
          .value;
      
      // Initialize the list with two items
      _socialProfileMyselfModelObj.listveganItemList = [
        ListveganItemModel(
          title: '${currentDiet ?? 'Balanced'}${dietEmojis[currentDiet] ?? '🍽️'}',
          count: '',
        ),
        ListveganItemModel(
          title: "Loading...",
          count: "⭐️",
          username: FirebaseAuth.instance.currentUser?.email,
        ),
      ];
      
      updateDietBox(currentDiet ?? 'Carnivore');
      _setupUserListener();
    } catch (e) {
      print('Error initializing diet: $e');
    }
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    super.dispose();
  }
}