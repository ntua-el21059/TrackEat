import '../../../core/app_export.dart';
import 'profile_item_model.dart';

// ignore_for_file: must_be_immutable
class ProfileModel {
  List<ProfileItemModel> profileItemList = [
    ProfileItemModel(
      title: "Activity Level",
      value: "Moderate",
      icon: ImageConstant.imgTelevision,
    ),
    ProfileItemModel(
      title: "Weekly Goal",
      value: "-0.5kg",
      icon: ImageConstant.imgWeeklyGoal,
    ),
    ProfileItemModel(
      title: "Goal Weight",
      value: "70kg",
      icon: ImageConstant.imgGoalWeight,
    ),
    ProfileItemModel(
      title: "Calories Goal",
      value: "3000 kcal",
      icon: ImageConstant.imgCaloriesGoal,
    ),
    ProfileItemModel(
      title: "Cur. Weight",
      value: "100 g",
      icon: ImageConstant.imgCurrentWeight,
    ),
    ProfileItemModel(
      title: "Diet",
      value: "Frutarian",
      icon: ImageConstant.imgDiet,
    ),
    ProfileItemModel(
      title: "Carbs Goal",
      value: "350 g",
      icon: ImageConstant.imgCarbsGoal,
    ),
    ProfileItemModel(
      title: "Protein Goal",
      value: "140 g",
      icon: ImageConstant.imgProteinGoal,
    ),
    ProfileItemModel(
      title: "Fat Goal",
      value: "93 g",
      icon: ImageConstant.imgFatGoal,
    ),
  ];
}