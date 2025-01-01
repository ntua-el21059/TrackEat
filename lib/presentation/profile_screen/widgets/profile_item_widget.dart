import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/profile_item_model.dart';
import '../provider/profile_provider.dart';
import '../../social_profile_myself_screen/provider/social_profile_myself_provider.dart';

// ignore_for_file: must_be_immutable
class ProfileItemWidget extends StatelessWidget {
  final ProfileItemModel model;
  final VoidCallback? onArrowTap;

  ProfileItemWidget(this.model, {this.onArrowTap, Key? key}) : super(key: key);

  static const List<String> activityLevels = ['Light', 'Moderate', 'Vigorous'];
  static const List<String> dietTypes = [
    'Keto',
    'Vegan',
    'Vegetarian',
    'Carnivore',
    'Fruitarian',
    'Pescatarian'
  ];
  
  final TextEditingController _numberController = TextEditingController();

  String _shortenText(String text) {
    if (text.length > 8) {
      return text.substring(0, 6) + "...";
    }
    return text;
  }

  void _showActivityLevelPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white.withOpacity(0.9),
      builder: (BuildContext context) {
        return Consumer<ProfileProvider>(
          builder: (context, provider, child) {
            return Container(
              height: 250.h,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8.h),
                    width: 40.h,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2.h),
                    ),
                  ),
                  // Options
                  Expanded(
                    child: ListView.builder(
                      itemCount: activityLevels.length,
                      itemBuilder: (context, index) {
                        final level = activityLevels[index];
                        final isSelected = level == provider.profileModelObj.profileItemList[0].value;
                        
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              provider.updateActivityLevel(level);
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 50.h,
                              alignment: Alignment.center,
                              child: Text(
                                level,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: isSelected ? Colors.blue : Colors.black,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Cancel button
                  SafeArea(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showDietPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white.withOpacity(0.9),
      builder: (BuildContext context) {
        return Consumer<ProfileProvider>(
          builder: (context, provider, child) {
            return Container(
              height: 350.h,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8.h),
                    width: 40.h,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2.h),
                    ),
                  ),
                  // Options
                  Expanded(
                    child: ListView.builder(
                      itemCount: dietTypes.length,
                      itemBuilder: (context, index) {
                        final diet = dietTypes[index];
                        final isSelected = diet == provider.profileModelObj.profileItemList
                            .firstWhere((item) => item.title == "Diet")
                            .value;
                        
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              provider.updateDiet(diet);
                              Provider.of<SocialProfileMyselfProvider>(context, listen: false)
                                  .updateDietBox(diet);
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 50.h,
                              alignment: Alignment.center,
                              child: Text(
                                diet,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: isSelected ? Colors.blue : Colors.black,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Cancel button
                  SafeArea(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showNumberPicker(BuildContext context, String title, String currentValue) {
    // Extract current number and unit
    final RegExp numRegex = RegExp(r'([0-9.-]+)([a-zA-Z\s]+)');
    final match = numRegex.firstMatch(currentValue);
    final currentNumber = match?.group(1) ?? "0";
    final unit = match?.group(2)?.trim() ?? "";
    
    _numberController.text = currentNumber;

    // List of fields that should only accept positive numbers
    final positiveOnlyFields = [
      "Goal Weight",
      "Calories Goal",
      "Cur. Weight",
      "Carbs Goal",
      "Protein Goal",
      "Fat Goal"
    ];
    final isPositiveOnly = positiveOnlyFields.contains(title);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white.withOpacity(0.9),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            height: 200.h,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8.h),
                  width: 40.h,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.h),
                  ),
                ),
                // Title
                Text(
                  "Enter new value for $title",
                  style: theme.textTheme.titleMedium,
                ),
                // Number input
                Padding(
                  padding: EdgeInsets.all(16.h),
                  child: TextField(
                    controller: _numberController,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                      signed: !isPositiveOnly, // Only allow negative for Weekly Goal
                    ),
                    textAlign: TextAlign.center,
                    autofocus: true,
                    decoration: InputDecoration(
                      suffix: Text(unit),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final newValue = double.tryParse(_numberController.text);
                        if (newValue != null) {
                          if (isPositiveOnly && newValue < 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please enter a positive number')),
                            );
                            return;
                          }

                          // Special handling for Calories Goal
                          if (title == "Calories Goal") {
                            await Provider.of<ProfileProvider>(context, listen: false)
                                .updateCaloriesInFirebase(newValue.toInt().toString());
                          } else {
                            Provider.of<ProfileProvider>(context, listen: false)
                                .updateNumericValue(title, newValue);
                          }
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        'Save',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isActivityLevel = model.title == "Activity Level";
    bool isWeeklyGoal = model.title == "Weekly Goal";
    bool isGoalWeight = model.title == "Goal Weight";
    bool isCaloriesGoal = model.title == "Calories Goal";
    bool isCurWeight = model.title == "Cur. Weight";
    bool isDiet = model.title == "Diet";
    bool isNumericField = [
      "Weekly Goal",
      "Goal Weight",
      "Calories Goal",
      "Cur. Weight",
      "Carbs Goal",
      "Protein Goal",
      "Fat Goal"
    ].contains(model.title);

    // Calculate fixed position for icons
    final double basePosition = _getTextWidth(context, "Activity Level") + 5.h;
    final double activityLevelPosition = basePosition + 5.h;
    final double weeklyGoalPosition = basePosition + 1.h;
    final double goalWeightAdjustedPosition = basePosition + 1.h;
    final double caloriesAdjustedPosition = basePosition + 3.h;
    final double fatGoalPosition = 127.h;
    final double dietPosition = 140.h;
    final double carbsGoalPosition = 138.h;

    return Column(
      children: [
        if (!isActivityLevel)
          Container(
            height: 1.h,
            color: Colors.white,
            margin: EdgeInsets.symmetric(horizontal: 16.h),
          ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left side with text and icon
              SizedBox(
                width: 180.h,  // Increased from 160.h to 180.h to prevent icon cutoff
                child: Stack(
                  children: [
                    // Text
                    Text(
                      model.title ?? "",
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    // Icon positioning
                    if (isActivityLevel || isWeeklyGoal)
                      Positioned(
                        left: isActivityLevel ? activityLevelPosition : weeklyGoalPosition + 2.h,
                        top: isWeeklyGoal ? 2.h : 0,
                        child: CustomImageView(
                          imagePath: isActivityLevel 
                              ? ImageConstant.imgActivityLevel
                              : model.icon,
                          height: isWeeklyGoal ? 23.h : 25.h,
                          width: isWeeklyGoal ? 23.h : 25.h,
                          color: Colors.white,
                          fit: BoxFit.contain,
                        ),
                      ),
                    if (isCaloriesGoal)
                      Positioned(
                        left: caloriesAdjustedPosition + 1.h,
                        top: 0,
                        child: CustomImageView(
                          imagePath: model.icon,
                          height: 26.h,
                          width: 26.h,
                          color: Colors.white,
                          fit: BoxFit.contain,
                        ),
                      ),
                    if (isGoalWeight)
                      Positioned(
                        left: goalWeightAdjustedPosition + 2.h,
                        top: 2.h,
                        child: CustomImageView(
                          imagePath: model.icon,
                          height: 22.h,
                          width: 22.h,
                          color: Colors.white,
                          fit: BoxFit.contain,
                        ),
                      ),
                    if (isCurWeight)
                      Positioned(
                        left: caloriesAdjustedPosition - 1.h,
                        top: 3.h,
                        child: CustomImageView(
                          imagePath: model.icon,
                          height: 22.h,
                          width: 22.h,
                          color: Colors.white,
                          fit: BoxFit.contain,
                        ),
                      ),
                    // For other icons, keep original positioning
                    if (!isActivityLevel && !isWeeklyGoal && !isGoalWeight && !isCaloriesGoal && !isCurWeight)
                      Positioned(
                        left: model.title == "Fat Goal" 
                            ? caloriesAdjustedPosition - 11.h  // Fat goal icon position
                            : model.title == "Diet"
                                ? caloriesAdjustedPosition + 1.h  // Diet icon moved 2.h right (from -1.h to +1.h)
                                : caloriesAdjustedPosition - 1.h,  // Other icons remain at the same position
                        top: 0,
                        child: CustomImageView(
                          imagePath: model.icon,
                          height: model.title == "Fat Goal" ? 27.h : 25.h,
                          width: model.title == "Fat Goal" ? 27.h : 25.h,
                          color: Colors.white,
                          fit: BoxFit.contain,
                        ),
                      ),
                  ],
                ),
              ),
              // Right side with value and arrow
              GestureDetector(
                onTap: onArrowTap,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      model.value ?? "",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8.h),
                    CustomImageView(
                      imagePath: ImageConstant.imgArrowRight,
                      height: 14.h,
                      width: 14.h,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Add this helper method to calculate text width
  double _getTextWidth(BuildContext context, String text) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: theme.textTheme.titleLarge?.copyWith(
          color: Colors.white,
        ),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    
    return textPainter.width;
  }
}