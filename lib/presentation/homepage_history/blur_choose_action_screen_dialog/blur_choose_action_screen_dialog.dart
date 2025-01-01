import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../blur_edit_screen_dialog/blur_edit_screen_dialog.dart';
import '../../../models/meal.dart';
import 'package:provider/provider.dart';
import '../history_today_tab_screen/provider/history_today_tab_provider.dart';

class BlurChooseActionScreenDialog extends StatelessWidget {
  const BlurChooseActionScreenDialog({
    Key? key, 
    required this.mealType,
    required this.onDelete,
    required this.meal,
  }) : super(key: key);
  
  final String mealType;
  final VoidCallback onDelete;
  final Meal meal;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.h),
      ),
      backgroundColor: const Color(0xFFB2D7FF),
      child: Container(
        margin: EdgeInsets.all(2.h),
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.h),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 24),
                Text(
                  "Choose Action",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB2D7FF).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, size: 20, color: Colors.black87),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: const Color(0xFFB2D7FF), width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.h),
                ),
                padding: EdgeInsets.symmetric(vertical: 8.h),
                minimumSize: Size(double.infinity, 40.h),
                fixedSize: Size.fromHeight(40.h),
              ),
              onPressed: () async {
                Navigator.pop(context);
                final wasUpdated = await showDialog<bool>(
                  context: context,
                  builder: (context) => BlurEditScreenDialog.builder(context, meal),
                );
                if (wasUpdated == true) {
                  Provider.of<HistoryTodayTabProvider>(context, listen: false).refreshMeals();
                }
              },
              child: Text(
                "Edit",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: const Color(0xFFB2D7FF), width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.h),
                ),
                padding: EdgeInsets.symmetric(vertical: 8.h),
                minimumSize: Size(double.infinity, 40.h),
                fixedSize: Size.fromHeight(40.h),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                onDelete();
              },
              child: Text(
                "Delete",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                ),
              ),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  static Widget builder(BuildContext context, String mealType, VoidCallback onDelete, Meal meal) {
    return BlurChooseActionScreenDialog(mealType: mealType, onDelete: onDelete, meal: meal);
  }
}

