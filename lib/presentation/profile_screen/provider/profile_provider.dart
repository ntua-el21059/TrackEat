import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/profile_item_model.dart';
import '../models/profile_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  void updateActivityLevel(String newLevel) async {
    // Find and update the activity level item
    for (var item in _profileModelObj.profileItemList) {
      if (item.title == "Activity Level") {
        item.value = newLevel;
        break;
      }
    }
    notifyListeners();

    // Update Firebase
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser?.email != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.email)
            .update({'activity': newLevel});
      } catch (e) {
        print("Error updating activity level in Firebase: $e");
      }
    }
  }

  void updateDiet(String newDiet) async {
    final dietItem = profileModelObj.profileItemList.firstWhere(
      (item) => item.title?.toLowerCase().contains('diet') ?? false,
      orElse: () => ProfileItemModel(),
    );
    
    if (dietItem != null) {
      dietItem.value = newDiet;
      notifyListeners();
      
      // Update Firebase
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser?.email != null) {
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser!.email)
              .update({'diet': newDiet});
        } catch (e) {
          print("Error updating diet in Firebase: $e");
        }
      }
    }
  }

  void updateNumericValue(String title, double value) {
    for (var item in _profileModelObj.profileItemList) {
      if (item.title == title) {
        // Format number: remove .0 if it's a whole number
        String formattedNumber;
        if (value == value.roundToDouble()) {
          formattedNumber = value.toInt().toString();
        } else {
          formattedNumber = value.toString();
        }
        
        // Add appropriate unit based on title without spaces
        if (title == "Cur. Weight" || title == "Goal Weight") {
          item.value = "${formattedNumber}kg";
        } else if (title == "Carbs Goal" || title == "Protein Goal" || title == "Fat Goal") {
          item.value = "${formattedNumber}g";
        } else {
          item.value = formattedNumber;
        }
        
        // Ensure UI is updated
        notifyListeners();
        break;
      }
    }
  }

  void updateProfileImage(String imagePath) {
    _profileImagePath = imagePath;
    notifyListeners();
  }

  Future<void> updateCaloriesInFirebase(String calories) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser?.email != null) {
      try {
        // Clean the input value
        String cleanValue = calories.replaceAll(' ', '').replaceAll('kcal', '');
        
        // Update Firestore with integer value
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.email)
            .update({'dailyCalories': int.parse(cleanValue)});

        // Update local UI with no space before kcal
        updateCalories("${cleanValue}kcal");
      } catch (e) {
        print("Error updating calories in Firebase: $e");
      }
    }
  }

  void updateCalories(String calories) {
    final caloriesItem = profileModelObj.profileItemList.firstWhere(
      (item) => item.title == "Calories Goal",
      orElse: () => ProfileItemModel(),
    );
    
    if (caloriesItem != null) {
      // Clean the input value
      String cleanValue = calories.replaceAll(' ', '').replaceAll('kcal', '');
      caloriesItem.value = "${cleanValue}kcal";
      notifyListeners();
    }
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
        value: "Balanced",
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