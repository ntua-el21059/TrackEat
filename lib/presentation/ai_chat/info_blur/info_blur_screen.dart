import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

class InfoBlurScreen extends StatelessWidget {
  const InfoBlurScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          color: Colors.black.withOpacity(0.5),
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          child: SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 8.h, top: 8.h),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 24.h,
                        height: 24.h,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 24.h,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Some things you\ncan ask me:",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28.h,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        SizedBox(height: 48.h),
                        _buildFeatureItem(
                          "SnapEat",
                          "Snap your meal, and I'll count the calories for you!",
                          Icons.camera_alt_outlined,
                        ),
                        SizedBox(height: 32.h),
                        _buildFeatureItem(
                          "Recipe Finder",
                          "Got ingredients? Tell me, and I'll whip up a recipe!",
                          Icons.restaurant_menu_outlined,
                        ),
                        SizedBox(height: 32.h),
                        _buildFeatureItem(
                          "Calories Finder",
                          "Wondering about fruit or veggie calories? Just ask!",
                          Icons.kebab_dining_outlined,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String title, String description, IconData icon) {
    return Row(
      children: [
        Container(
          width: 48.h,
          height: 48.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.h),
          ),
          child: Icon(
            icon,
            color: Colors.black,
            size: 24.h,
          ),
        ),
        SizedBox(width: 16.h),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.h,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                description,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14.h,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 