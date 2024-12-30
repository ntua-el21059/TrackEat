import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../theme/custom_button_style.dart';
import '../../../widgets/custom_outlined_button.dart';
import '../carnivore_challenge_dialog/blur_edit_screen_dialog.dart';
import '../wrap_challenge_dialog/provider/wrap_challenge_provider.dart';
import 'package:provider/provider.dart';

class BlurChooseActionScreenDialog extends StatelessWidget {
  const BlurChooseActionScreenDialog({
    Key? key,
    required this.mealType,
    required this.onDelete,
    required this.mealName,
  }) : super(key: key);

  final String mealType;
  final VoidCallback onDelete;
  final String mealName;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.h),
      ),
      backgroundColor: Colors.white,
      child: Container(
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.h),
          border: Border.all(color: const Color(0xFFB2D7FF)),
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
                  child: Icon(Icons.close, size: 24),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            CustomOutlinedButton(
              height: 48.h,
              text: "Edit",
              buttonStyle: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.h),
                    side: BorderSide(color: const Color(0xFFB2D7FF)),
                  ),
                ),
              ),
              buttonTextStyle: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
              onPressed: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) =>
                      BlurEditScreenDialog.builder(context, mealName),
                );
              },
            ),
            SizedBox(height: 16.h),
            CustomOutlinedButton(
              height: 48.h,
              text: "Delete",
              buttonStyle: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.h),
                    side: BorderSide(color: const Color(0xFFB2D7FF)),
                  ),
                ),
              ),
              buttonTextStyle: TextStyle(
                fontSize: 16,
                color: Colors.red,
              ),
              onPressed: onDelete,
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  static Widget builder(BuildContext context, String mealType,
      VoidCallback onDelete, String mealName) {
    return BlurChooseActionScreenDialog(
        mealType: mealType, onDelete: onDelete, mealName: mealName);
  }
}
