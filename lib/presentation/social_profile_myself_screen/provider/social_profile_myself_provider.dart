import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/social_profile_myself_model.dart';
import '../models/listvegan_item_model.dart';
import '../../profile_screen/provider/profile_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SocialProfileMyselfProvider extends ChangeNotifier {
  SocialProfileMyselfModel _socialProfileMyselfModelObj = SocialProfileMyselfModel();
  int _weightGoalProgress = 50; // Changed from 70 to 50
  String selectedDiet = '';
  Color dietBoxColor = Colors.grey;
  String dietEmoji = '🍽️';

  Map<String, Color> dietColors = {
    'Balanced': const Color(0xFF90CAF9),  // Light blue color for balanced
    'Keto': const Color(0xFFA726),      // Orange for keto
    'Vegan': const Color(0xFF81C784),     // Green for vegan
    'Vegetarian': const Color(0xFF4CAF50), // Darker green for vegetarian
    'Carnivore': const Color(0xFFEF5350), // Red for carnivore
    'Fruitarian': const Color(0xFFFF4081), // Pink for fruitarian
  };

  Map<String, String> dietEmojis = {
    'Balanced': '⚖️',  // Balance scale emoji for balanced diet
    'Keto': '🥑',      // Avocado for keto
    'Vegan': '🌱',     // Sprout for vegan
    'Vegetarian': '🥗', // Salad for vegetarian
    'Carnivore': '🥩', // Meat for carnivore
    'Fruitarian': '🍎', // Apple for fruitarian
  };

  SocialProfileMyselfModel get socialProfileMyselfModelObj => _socialProfileMyselfModelObj;
  int get weightGoalProgress => _weightGoalProgress;

  void updateWeightGoalProgress(int progress) {
    _weightGoalProgress = progress;
    notifyListeners();
  }

  void updateDietBox(String diet) {
    selectedDiet = diet;
    dietBoxColor = dietColors[diet] ?? Colors.grey;
    dietEmoji = dietEmojis[diet] ?? '🍽️';
    
    // Update the list item with the new diet text while preserving the username
    if (_socialProfileMyselfModelObj.listveganItemList.isNotEmpty) {
      _socialProfileMyselfModelObj.listveganItemList[0] = ListveganItemModel(
        title: '$diet${dietEmojis[diet] ?? ''}',
        count: '',
      );
      
      // Preserve the second item with the current user's email
      if (_socialProfileMyselfModelObj.listveganItemList.length > 1) {
        _socialProfileMyselfModelObj.listveganItemList[1] = ListveganItemModel(
          title: "'s been thriving \nwith us for a year!",
          count: "⭐️",
          username: FirebaseAuth.instance.currentUser?.email,
        );
      }
    }
    
    notifyListeners();
  }

  void init(BuildContext context) {
    try {
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      final currentDiet = profileProvider.profileModelObj.profileItemList
          .firstWhere((item) => item.title == "Diet")
          .value;
      updateDietBox(currentDiet ?? 'Carnivore');
    } catch (e) {
      print('Error initializing diet: $e');
    }
  }
}