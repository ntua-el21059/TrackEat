import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import 'models/carnivore_challenge_model.dart';
import 'provider/carnivore_challenge_provider.dart';

// This directive indicates that we intentionally want this widget to be mutable
// ignore_for_file: must_be_immutable
class CarnivoreChallengeDialog extends StatefulWidget {
  // Constructor with an optional key parameter for widget identification
  const CarnivoreChallengeDialog({Key? key})
      : super(
          key: key,
        );

  @override
  CarnivoreChallengeDialogState createState() =>
      CarnivoreChallengeDialogState();

  // Factory method that sets up the widget with its state management provider
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CarnivoreChallengeProvider(),
      child: CarnivoreChallengeDialog(),
    );
  }
}

class CarnivoreChallengeDialogState extends State<CarnivoreChallengeDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 314.h,
          padding: EdgeInsets.only(
            left: 18.h,
            top: 16.h,
            right: 18.h,
          ),
          decoration: AppDecoration.redcarnivorechallenge,
          width: double.maxFinite,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              // Vector image (likely a meat-themed graphic)
              CustomImageView(
                imagePath: ImageConstant.imgVector62x64,
                height: 62.h,
                width: 66.h,
                margin: EdgeInsets.only(top: 8.h),
              ),
              // Main content column containing text and buttons
              SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Close button in the top-right corner
                    CustomImageView(
                      imagePath: ImageConstant.imgXButton,
                      height: 20.h,
                      width: 22.h,
                      alignment: Alignment.centerRight,
                    ),
                    SizedBox(height: 48.h),
                    // Challenge title
                    Text(
                      "Carinvore\nchallenge",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelLarge,
                    ),
                    SizedBox(height: 14.h),
                    // Challenge description
                    Text(
                      "Eat only meat, fish, and eggs for 15 days—fuel \n"
                      "your body, embrace the challenge! 🥩🔥",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelLarge,
                    ),
                    SizedBox(height: 36.h),
                    // Time remaining indicator
                    Text(
                      "Time left: 20 days",
                      style: theme.textTheme.labelLarge,
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
