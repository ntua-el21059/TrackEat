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

  void updateNumericValue(String title, double value) {
    final item = profileModelObj.profileItemList.firstWhere(
      (item) => item.title == title,
      orElse: () => ProfileItemModel(),
    );

    if (title == "Weekly Goal") {
      item.value = "${value.toStringAsFixed(1)} kg";
    } else if (title == "Goal Weight" || title == "Cur. Weight") {
      item.value = "${value.toStringAsFixed(1)} kg";
    } else if (title == "Calories Goal") {
      item.value = "${value.toInt()} kcal";
    } else if (title == "Carbs Goal" || title == "Protein Goal" || title == "Fat Goal") {
      item.value = "${value.toInt()} g";
    } else {
      item.value = value.toString();
    }
    notifyListeners();
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

        // Update local UI with space before kcal
        updateCalories("$cleanValue kcal");
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
    
    // Clean the input value
    String cleanValue = calories.replaceAll(' ', '').replaceAll('kcal', '');
    caloriesItem.value = "$cleanValue kcal";
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
        value: "",
        icon: ImageConstant.imgWeeklyGoal,
      ),
      ProfileItemModel(
        title: "Weekly Goal",
        value: "0.0 kg",
        icon: ImageConstant.imgGoalWeight,
      ),
      ProfileItemModel(
        title: "Goal Weight",
        value: "0.0 kg",
        icon: ImageConstant.imgCaloriesGoal,
      ),
      ProfileItemModel(
        title: "Calories Goal",
        value: "0 kcal",
        icon: ImageConstant.imgCurrentWeight,
      ),
      ProfileItemModel(
        title: "Cur. Weight",
        value: "0.0 kg",
        icon: ImageConstant.imgDiet,
      ),
      ProfileItemModel(
        title: "Diet",
        value: "",
        icon: ImageConstant.imgCarbsGoal,
      ),
      ProfileItemModel(
        title: "Carbs Goal",
        value: "0 g",
        icon: ImageConstant.imgProteinGoal,
      ),
      ProfileItemModel(
        title: "Protein Goal",
        value: "0 g",
        icon: ImageConstant.imgFatGoal,
      ),
      ProfileItemModel(
        title: "Fat Goal",
        value: "0 g",
        icon: ImageConstant.imgFatGoal,
      ),
    ];
  }
}