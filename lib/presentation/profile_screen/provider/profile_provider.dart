import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/profile_item_model.dart';
import '../models/profile_model.dart';

/// A provider class for the ProfileScreen.
///
/// This provider manages the state of the ProfileScreen, including the
/// current profileModelObj
// ignore_for_file: must_be_immutable
class ProfileProvider extends ChangeNotifier {
  ProfileModel _profileModelObj = ProfileModel();
  String _profileImagePath = ImageConstant.imgBoy1;  // Default image

  ProfileModel get profileModelObj => _profileModelObj;
  String get profileImagePath => _profileImagePath;

  void updateActivityLevel(String newLevel) {
    // Find and update the activity level item
    for (var item in _profileModelObj.profileItemList) {
      if (item.title == "Activity Level") {
        item.value = newLevel;
        break;
      }
    }
    notifyListeners();
  }

  void updateDiet(String newDiet) {
    for (var item in _profileModelObj.profileItemList) {
      if (item.title == "Diet") {
        item.value = newDiet;
        break;
      }
    }
    notifyListeners();
  }

  void updateNumericValue(String title, double value) {
    for (var item in _profileModelObj.profileItemList) {
      if (item.title == title) {
        // Keep the unit (kg, g, kcal) while updating the number
        String unit = item.value!.replaceAll(RegExp(r'[0-9.-]+'), '').trim();
        
        // Format number: remove .0 if it's a whole number
        String formattedNumber;
        if (value == value.roundToDouble()) {
          formattedNumber = value.toInt().toString();
        } else {
          formattedNumber = value.toString();
        }
        
        item.value = "$formattedNumber$unit";
        break;
      }
    }
    notifyListeners();
  }

  void updateProfileImage(String imagePath) {
    _profileImagePath = imagePath;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onInit() {
    _profileModelObj.profileItemList = [
      ProfileItemModel(
        title: "Activity Level",
        value: "Moderate",
        icon: ImageConstant.imgWeeklyGoal,
      ),
      ProfileItemModel(
        title: "Weekly Goal",
        value: "-0.5 kg",
        icon: ImageConstant.imgGoalWeight,
      ),
      ProfileItemModel(
        title: "Goal Weight",
        value: "70 kg",
        icon: ImageConstant.imgCaloriesGoal,
      ),
      ProfileItemModel(
        title: "Calories Goal",
        value: "3000kcal",
        icon: ImageConstant.imgCurrentWeight,
      ),
      ProfileItemModel(
        title: "Cur. Weight",
        value: "100g",
        icon: ImageConstant.imgDiet,
      ),
      ProfileItemModel(
        title: "Diet",
        value: "Frutarian",
        icon: ImageConstant.imgCarbsGoal,
      ),
      ProfileItemModel(
        title: "Carbs Goal",
        value: "350g",
        icon: ImageConstant.imgProteinGoal,
      ),
      ProfileItemModel(
        title: "Protein Goal",
        value: "140g",
        icon: ImageConstant.imgFatGoal,
      ),
      ProfileItemModel(
        title: "Fat Goal",
        value: "93g",
        icon: ImageConstant.imgFatGoal,
      ),
    ];
  }
}