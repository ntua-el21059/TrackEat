import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/profile_item_model.dart';

// ignore_for_file: must_be_immutable
class ProfileItemWidget extends StatelessWidget {
  final ProfileItemModel model;
  final VoidCallback? onArrowTap;

  const ProfileItemWidget(this.model, {this.onArrowTap, super.key});

  @override
  Widget build(BuildContext context) {
    bool isActivityLevel = model.title == "Activity Level";
    bool isWeeklyGoal = model.title == "Weekly Goal";
    bool isGoalWeight = model.title == "Goal Weight";
    bool isCaloriesGoal = model.title == "Calories Goal";
    bool isCurWeight = model.title == "Cur. Weight";

    // Calculate fixed position for icons
    final double basePosition = _getTextWidth(context, "Activity Level") + 5.h;
    final double activityLevelPosition = basePosition + 5.h;
    final double weeklyGoalPosition = basePosition + 1.h;
    final double goalWeightAdjustedPosition = basePosition + 1.h;
    final double caloriesAdjustedPosition = basePosition + 3.h;

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