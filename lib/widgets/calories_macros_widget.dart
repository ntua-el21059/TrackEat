import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:activity_ring/activity_ring.dart';
import 'package:rxdart/rxdart.dart';
import '../core/app_export.dart';
import '../services/meal_service.dart';
import '../presentation/homepage_history/home_screen/home_screen.dart';

class CaloriesMacrosWidget extends StatelessWidget {
  final bool isHomeScreen;
  final DateTime selectedDate;
  final bool isLoading;
  final double ringRadius;
  final double ringWidth;
  final EdgeInsets padding;
  final bool showHistoryButton;

  const CaloriesMacrosWidget({
    Key? key,
    this.isHomeScreen = true,
    required this.selectedDate,
    this.isLoading = false,
    this.ringRadius = 60,
    this.ringWidth = 15,
    this.padding = const EdgeInsets.all(22),
    this.showHistoryButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: padding,
      decoration: BoxDecoration(
        color: const Color(0xFFB2D7FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser?.email)
                .snapshots(),
            builder: (context, userSnapshot) {
              if (userSnapshot.hasData && userSnapshot.data != null && userSnapshot.data!.exists) {
                final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                final dailyCalories = userData['dailyCalories'] as int? ?? 0;
                final proteinGoal = double.tryParse(userData['proteingoal']?.toString() ?? '0') ?? 0.0;
                final fatGoal = double.tryParse(userData['fatgoal']?.toString() ?? '0') ?? 0.0;
                final carbsGoal = double.tryParse(userData['carbsgoal']?.toString() ?? '0') ?? 0.0;

                return StreamBuilder<List<dynamic>>(
                  stream: Rx.zip2(
                    MealService().getTotalCaloriesStreamForDate(
                      FirebaseAuth.instance.currentUser!.email!,
                      selectedDate,
                    ),
                    MealService().getTotalMacrosStreamForDate(
                      FirebaseAuth.instance.currentUser!.email!,
                      selectedDate,
                    ),
                    (int calories, Map<String, double> macros) => [calories, macros],
                  ),
                  builder: (context, macrosSnapshot) {
                    final consumedCalories = macrosSnapshot.data?[0] ?? 0;
                    final macros = macrosSnapshot.data?[1] as Map<String, double>? ?? {'protein': 0.0, 'fats': 0.0, 'carbs': 0.0};
                    final proteinConsumed = macros['protein'] ?? 0.0;
                    final fatConsumed = macros['fats'] ?? 0.0;
                    final carbsConsumed = macros['carbs'] ?? 0.0;

                    final proteinPercent = (proteinConsumed / proteinGoal * 100).clamp(0, 100);
                    final fatPercent = (fatConsumed / fatGoal * 100).clamp(0, 100);
                    final carbsPercent = (carbsConsumed / carbsGoal * 100).clamp(0, 100);
                    final caloriesPercent = ((consumedCalories / dailyCalories) * 100).clamp(0, 100);
                    final remainingCalories = (dailyCalories - consumedCalories).clamp(0, dailyCalories);

                    if (isHomeScreen) {
                      (context as Element).findAncestorStateOfType<HomeScreenState>()
                          ?.checkRingsAndShowReward(userData);
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "$remainingCalories Kcal Remaining...",
                              style: CustomTextStyles.titleMediumGray90001Bold,
                            ),
                            Text(
                              "$dailyCalories kcal",
                              style: TextStyle(
                                color: const Color(0xFFFF0000),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          width: double.maxFinite,
                          height: 8.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.h),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4.h),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return Row(
                                  children: [
                                    Container(
                                      width: (constraints.maxWidth * (caloriesPercent / 100)).clamp(0, constraints.maxWidth),
                                      decoration: BoxDecoration(
                                        color: consumedCalories > dailyCalories ? Colors.red : const Color(0xFF4CD964),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildMacronutrientText("Protein", proteinConsumed, proteinGoal, const Color(0xFFFA114F)),
                                  SizedBox(height: 16.h),
                                  _buildMacronutrientText("Fats", fatConsumed, fatGoal, const Color(0xFFA6FF00)),
                                  SizedBox(height: 16.h),
                                  _buildMacronutrientText("Carbs", carbsConsumed, carbsGoal, const Color(0xFF00FFF6)),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Ring(
                                percent: isLoading ? 0.0 : proteinPercent.toDouble(),
                                color: RingColorScheme(
                                  ringColor: Color(0xFFFA114F),
                                  backgroundColor: Colors.grey.withOpacity(0.2),
                                ),
                                radius: ringRadius,
                                width: ringWidth,
                                child: Ring(
                                  percent: isLoading ? 0.0 : fatPercent.toDouble(),
                                  color: RingColorScheme(
                                    ringColor: Color(0xFFA6FF00),
                                    backgroundColor: Colors.grey.withOpacity(0.2),
                                  ),
                                  radius: ringRadius - 15,
                                  width: ringWidth,
                                  child: Ring(
                                    percent: isLoading ? 0.0 : carbsPercent.toDouble(),
                                    color: RingColorScheme(
                                      ringColor: Color(0xFF00FFF6),
                                      backgroundColor: Colors.grey.withOpacity(0.2),
                                    ),
                                    radius: ringRadius - 30,
                                    width: ringWidth,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (showHistoryButton && isHomeScreen) ...[
                          Align(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, AppRoutes.historyTodayTabScreen);
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Show History",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                      Icon(Icons.chevron_right, color: Colors.white),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                );
              }
              return Container(); // Return empty container while loading
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMacronutrientText(String label, double consumed, double total, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: CustomTextStyles.bodyLargeBlack90016_2,
        ),
        Text(
          "${consumed.toInt()}/${total.toInt()}g",
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
} 