import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_outlined_button.dart';

class BlurEditScreenDialog extends StatelessWidget {
  const BlurEditScreenDialog({
    Key? key,
    required this.mealName,
  }) : super(key: key);

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 24),
                Text(
                  mealName,
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
            SizedBox(height: 4.h),
            Row(
              children: [
                Text(
                  "🔥",
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  " 69 kcal -100g",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMacroItem("69g", "Protein", Colors.green),
                _buildMacroItem("69g", "Fats", Colors.orange),
                _buildMacroItem("69g", "Carbs", Colors.yellow),
              ],
            ),
            SizedBox(height: 16.h),
            _buildEditButton("Change portion size"),
            SizedBox(height: 8.h),
            _buildEditButton("Edit calories"),
            SizedBox(height: 8.h),
            _buildEditButton("Edit Protein content"),
            SizedBox(height: 8.h),
            _buildEditButton("Edit Fat content"),
            SizedBox(height: 8.h),
            _buildEditButton("Edit Carb content"),
            SizedBox(height: 16.h),
            Center(
              child: SizedBox(
                width: 160.h,
                height: 36.h,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3B82F6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.h),
                    ),
                  ),
                  child: Text(
                    "Save and Exit",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroItem(String value, String label, Color color) {
    return Row(
      children: [
        Container(
          height: 80.h,
          width: 6.h,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(16.h),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 6.h,
                height: 48.h,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(16.h),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 6.h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEditButton(String text) {
    return Container(
      width: double.infinity,
      height: 40.h,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: const Color(0xFFB2D7FF)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.h),
          ),
          padding: EdgeInsets.symmetric(vertical: 8.h),
          backgroundColor: Colors.white,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
          ),
        ),
      ),
    );
  }

  static Widget builder(BuildContext context, String mealName) {
    return BlurEditScreenDialog(mealName: mealName);
  }
}
