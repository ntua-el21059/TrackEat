import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/profile_item_model.dart';
import 'package:provider/provider.dart';
import '../provider/profile_provider.dart';
import '../../social_profile_myself_screen/provider/social_profile_myself_provider.dart';

// ignore_for_file: must_be_immutable
class ProfileItemWidget extends StatelessWidget {
  ProfileItemWidget(this.profileItemModelObj, {Key? key}) : super(key: key);

  ProfileItemModel profileItemModelObj;
  final List<String> activityLevels = ['Light', 'Moderate', 'Vigorous'];
  final List<String> dietTypes = [
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
                      onPressed: () {
                        final newValue = double.tryParse(_numberController.text);
                        if (newValue != null) {
                          // Only allow positive numbers for specified fields
                          if (isPositiveOnly && newValue < 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Please enter a positive number'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            return;
                          }
                          Provider.of<ProfileProvider>(context, listen: false)
                              .updateNumericValue(title, newValue);
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
    bool isActivityLevel = profileItemModelObj.title == "Activity Level";
    bool isWeeklyGoal = profileItemModelObj.title == "Weekly Goal";
    bool isGoalWeight = profileItemModelObj.title == "Goal Weight";
    bool isCaloriesGoal = profileItemModelObj.title == "Calories Goal";
    bool isDiet = profileItemModelObj.title == "Diet";
    bool isNumericField = [
      "Weekly Goal",
      "Goal Weight",
      "Calories Goal",
      "Cur. Weight",
      "Carbs Goal",
      "Protein Goal",
      "Fat Goal"
    ].contains(profileItemModelObj.title);

    // Calculate fixed position for icons
    final double iconPosition = _getTextWidth(context, "Activity Level") + 4.h;

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
                width: 160.h,  // Fixed width for text + icon area
                child: Stack(
                  children: [
                    // Text
                    Text(
                      profileItemModelObj.title ?? "",
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    // Icon - positioned at same horizontal position for specific items
                    if (isActivityLevel || isWeeklyGoal || isGoalWeight || isCaloriesGoal)
                      Positioned(
                        left: iconPosition,
                        top: 0,
                        child: CustomImageView(
                          imagePath: profileItemModelObj.icon,
                          height: isCaloriesGoal ? 28.h : 25.h,  // Bigger size for calories icon
                          width: isCaloriesGoal ? 28.h : 25.h,   // Bigger size for calories icon
                          color: Colors.white,
                          fit: BoxFit.contain,
                        ),
                      ),
                    // For other icons, keep original positioning
                    if (!isActivityLevel && !isWeeklyGoal && !isGoalWeight && !isCaloriesGoal)
                      Positioned(
                        left: 135.h,
                        top: 0,
                        child: CustomImageView(
                          imagePath: profileItemModelObj.icon,
                          height: 25.h,
                          width: 25.h,
                          color: Colors.white,
                          fit: BoxFit.contain,
                        ),
                      ),
                  ],
                ),
              ),
              // Right side with value and arrow
              GestureDetector(
                onTap: isActivityLevel 
                    ? () => _showActivityLevelPicker(context)
                    : isDiet 
                        ? () => _showDietPicker(context)
                        : isNumericField
                            ? () => _showNumberPicker(
                                context,
                                profileItemModelObj.title ?? "",
                                profileItemModelObj.value ?? "",
                              )
                            : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      profileItemModelObj.value ?? "",
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