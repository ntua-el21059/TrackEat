import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import 'models/beatles_challenge_model.dart';
import 'provider/beatles_challenge_provider.dart';

// This directive indicates that we intentionally want this widget to be mutable
// ignore_for_file: must_be_immutable
class BeatlesChallengeDialog extends StatefulWidget {
  // Constructor with key parameter for widget identification
  const BeatlesChallengeDialog({Key? key})
      : super(
          key: key,
        );

  @override
  BeatlesChallengeDialogState createState() => BeatlesChallengeDialogState();

  // Factory method that sets up the widget with its state management provider
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BeatlesChallengeProvider(),
      child: BeatlesChallengeDialog(),
    );
  }
}

class BeatlesChallengeDialogState extends State<BeatlesChallengeDialog> {
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
          decoration: AppDecoration.darkBlueContrastwithLightBlue,
          width: double.maxFinite,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              // Vector image positioned at the top
              CustomImageView(
                imagePath: ImageConstant.imgVector78x72,
                height: 78.h,
                width: 74.h,
                margin: EdgeInsets.only(top: 4.h),
              ),
              // Main content column
              SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Close button
                    CustomImageView(
                      imagePath: ImageConstant.imgXButton,
                      height: 20.h,
                      width: 22.h,
                      alignment: Alignment.centerRight,
                    ),
                    SizedBox(height: 50.h),
                    // Challenge title
                    Text(
                      "Beatles \nchallenge",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelLarge,
                    ),
                    SizedBox(height: 14.h),
                    // Challenge description
                    Text(
                      "Try a beetle salad—crunchy, unique, and\n"
                      " packed with nutrients! 🥗✨",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelLarge,
                    ),
                    SizedBox(height: 42.h),
                    // Time remaining indicator
                    Text(
                      "Time left: 12:00:00",
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
