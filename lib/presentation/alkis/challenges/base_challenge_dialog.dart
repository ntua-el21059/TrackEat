import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';

abstract class BaseChallengeDialog extends StatefulWidget {
  const BaseChallengeDialog({Key? key}) : super(key: key);
}

abstract class BaseChallengeDialogState<T extends BaseChallengeDialog>
    extends State<T> {
  // Abstract getters that subclasses must implement
  String get title;
  String get description;
  String get timeLeft;
  String get iconPath;
  Color get backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(horizontal: 16.h),
            padding: EdgeInsets.all(16.h),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                // Challenge icon
                Positioned(
                  top: 24.h,
                  child: Image.asset(
                    iconPath,
                    width: 64.h,
                    height: 64.h,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Close button
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Image.asset(
                          'assets/images/x_button.svg',
                          width: 24.h,
                          height: 24.h,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 48.h),
                    // Title
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.h,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Description
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.h,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    // Time left
                    Text(
                      "Time left: $timeLeft",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.h,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
