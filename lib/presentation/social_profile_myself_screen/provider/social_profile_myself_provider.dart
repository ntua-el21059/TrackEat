import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/social_profile_myself_model.dart';
import '../../profile_screen/provider/profile_provider.dart';

class SocialProfileMyselfProvider extends ChangeNotifier {
  SocialProfileMyselfModel _socialProfileMyselfModelObj = SocialProfileMyselfModel();
  int _weightGoalProgress = 50; // Changed from 70 to 50

  SocialProfileMyselfModel get socialProfileMyselfModelObj => _socialProfileMyselfModelObj;
  int get weightGoalProgress => _weightGoalProgress;

  void updateWeightGoalProgress(int progress) {
    _weightGoalProgress = progress;
    notifyListeners();
  }

  void updateDietBox(String diet) {
    String dietText = '';
    switch (diet.toLowerCase()) {
      case 'vegan':
        dietText = 'Vegan🌱';
        break;
      case 'carnivore':
        dietText = 'Carnivore🥩';
        break;
      case 'vegetarian':
        dietText = 'Vegetarian🥗';
        break;
      case 'pescatarian':
        dietText = 'Pescatarian🐟';
        break;
      case 'keto':
        dietText = 'Keto🥑';
        break;
      case 'fruitarian':
        dietText = 'Fruitarian🍎';
        break;
      default:
        dietText = diet;
    }
    
    if (_socialProfileMyselfModelObj.listveganItemList.isNotEmpty) {
      _socialProfileMyselfModelObj.listveganItemList[0].title = dietText;
      notifyListeners();
    }
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