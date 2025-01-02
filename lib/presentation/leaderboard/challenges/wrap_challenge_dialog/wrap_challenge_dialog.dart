import 'package:flutter/material.dart';
import '../../../../../core/app_export.dart';
import 'provider/wrap_challenge_provider.dart';

// This directive indicates that the widget is intentionally mutable to manage state
// ignore_for_file: must_be_immutable
class WrapChallengeDialog extends StatefulWidget {
  // Constructor accepting an optional key for widget identification
  const WrapChallengeDialog({Key? key})
      : super(
          key: key,
        );

  @override
  WrapChallengeDialogState createState() => WrapChallengeDialogState();

  // Factory method that creates the widget with its state management provider
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WrapChallengeProvider(),
      child: WrapChallengeDialog(),
    );
  }
}

class WrapChallengeDialogState extends State<WrapChallengeDialog> {
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
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(
            horizontal: 18.h,
            vertical: 16.h,
          ),
          decoration: AppDecoration.purplewrapchallenge,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildRowvectorone(context),
              SizedBox(height: 2.h),
              // Interesting stacked text effect for the challenge title
              SizedBox(
                height: 30.h,
                width: 64.h,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // The title appears twice to create a special visual effect
                    Text(
                      "Wrap \nchallenge",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelLarge,
                    ),
                    Text(
                      "Wrap \nchallenge",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelLarge,
                    )
                  ],
                ),
              ),
              SizedBox(height: 14.h),
              // Challenge description with emojis for visual appeal
              Text(
                "Enjoy a healthy burrito—full of\n flavor and goodness! 🌯✨",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelLarge,
              ),
              SizedBox(height: 40.h),
              // Timer display
              Text(
                "Time left: 6:30:00",
                style: theme.textTheme.labelLarge,
              )
            ],
          ),
        )
      ],
    );
  }

  /// Helper method to build the top section with vector image and close button
  Widget _buildRowvectorone(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vector image (likely a wrap/burrito graphic)
          CustomImageView(
            imagePath: ImageConstant.imgVector60x72,
            height: 60.h,
            width: 72.h,
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(top: 6.h),
          ),
          // Close button
          CustomImageView(
            imagePath: ImageConstant.imgXButton,
            height: 20.h,
            width: 20.h,
            margin: EdgeInsets.only(left: 96.h),
          )
        ],
      ),
    );
  }
}
