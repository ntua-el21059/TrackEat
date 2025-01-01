import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../models/meal.dart';
import '../../../services/meal_service.dart';

class BlurEditScreenDialog extends StatefulWidget {
  const BlurEditScreenDialog({
    Key? key,
    required this.meal,
  }) : super(key: key);

  final Meal meal;

  @override
  State<BlurEditScreenDialog> createState() => _BlurEditScreenDialogState();

  static Widget builder(BuildContext context, Meal meal) {
    return BlurEditScreenDialog(meal: meal);
  }
}

class _BlurEditScreenDialogState extends State<BlurEditScreenDialog> {
  final MealService _mealService = MealService();
  late double servingSize;
  late int calories;
  late double protein;
  late double fats;
  late double carbs;

  @override
  void initState() {
    super.initState();
    // Initialize with current values
    servingSize = widget.meal.servingSize;
    calories = widget.meal.calories;
    protein = widget.meal.macros['protein'] ?? 0;
    fats = widget.meal.macros['fats'] ?? 0;
    carbs = widget.meal.macros['carbs'] ?? 0;
  }

  Future<void> _showEditDialog(String title, String value, Function(String) onSave) async {
    final controller = TextEditingController(text: value);
    
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: 'Enter new value',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              onSave(controller.text);
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveMeal() async {
    try {
      // Create updated meal object
      final updatedMeal = Meal(
        id: widget.meal.id,
        userEmail: widget.meal.userEmail,
        name: widget.meal.name,
        mealType: widget.meal.mealType,
        calories: calories,
        servingSize: servingSize,
        macros: {
          'protein': protein,
          'fats': fats,
          'carbs': carbs,
        },
        date: widget.meal.date,
      );

      // Update in Firestore
      await _mealService.updateMeal(updatedMeal);
      
      if (mounted) {
        Navigator.pop(context, true); // Return true to indicate successful update
      }
    } catch (e) {
      print('Error saving meal: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving changes')),
        );
      }
    }
  }

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
                  widget.meal.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context, false),
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
                  " $calories kcal -${servingSize.toInt()}g",
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
                _buildMacroItem("${protein.toInt()}g", "Protein", const Color(0xFFFA114F)),
                _buildMacroItem("${fats.toInt()}g", "Fats", const Color(0xFFA6FF00)),
                _buildMacroItem("${carbs.toInt()}g", "Carbs", const Color(0xFF00FFF6)),
              ],
            ),
            SizedBox(height: 16.h),
            _buildEditButton(
              "Change portion size",
              onPressed: () => _showEditDialog(
                "Edit Portion Size",
                servingSize.toString(),
                (value) => setState(() => servingSize = double.tryParse(value) ?? servingSize),
              ),
            ),
            SizedBox(height: 8.h),
            _buildEditButton(
              "Edit calories",
              onPressed: () => _showEditDialog(
                "Edit Calories",
                calories.toString(),
                (value) => setState(() => calories = int.tryParse(value) ?? calories),
              ),
            ),
            SizedBox(height: 8.h),
            _buildEditButton(
              "Edit Protein content",
              onPressed: () => _showEditDialog(
                "Edit Protein",
                protein.toString(),
                (value) => setState(() => protein = double.tryParse(value) ?? protein),
              ),
            ),
            SizedBox(height: 8.h),
            _buildEditButton(
              "Edit Fat content",
              onPressed: () => _showEditDialog(
                "Edit Fat",
                fats.toString(),
                (value) => setState(() => fats = double.tryParse(value) ?? fats),
              ),
            ),
            SizedBox(height: 8.h),
            _buildEditButton(
              "Edit Carb content",
              onPressed: () => _showEditDialog(
                "Edit Carbs",
                carbs.toString(),
                (value) => setState(() => carbs = double.tryParse(value) ?? carbs),
              ),
            ),
            SizedBox(height: 16.h),
            Center(
              child: SizedBox(
                width: 160.h,
                height: 36.h,
                child: ElevatedButton(
                  onPressed: _saveMeal,
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

  Widget _buildEditButton(String text, {required VoidCallback onPressed}) {
    return Container(
      width: double.infinity,
      height: 40.h,
      child: OutlinedButton(
        onPressed: onPressed,
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
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }
}
