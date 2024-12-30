import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'models/brocolli_challenge_model.dart';
import 'provider/brocolli_challenge_provider.dart';

// This directive is used because the widget needs to be mutable to manage its state
// ignore_for_file: must_be_immutable
class BrocolliChallengeDialog extends StatefulWidget {
  // Constructor that accepts an optional key for widget identification
  const BrocolliChallengeDialog({Key? key})
      : super(
          key: key,
        );

  @override
  BrocolliChallengeDialogState createState() => BrocolliChallengeDialogState();

  // A factory method that creates the widget with its state management provider
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BrocolliChallengeProvider(),
      child: BrocolliChallengeDialog(),
    );
  }
}

class BrocolliChallengeDialogState extends State<BrocolliChallengeDialog> {
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
            horizontal: 14.h,
            vertical: 10.h,
          ),
          decoration: AppDecoration.blackbrocollichallenge,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildRowvectorone(context),
              SizedBox(height: 14.h),
              // Challenge title with multi-line support
              Text(
                "Brocolli\nchallenge",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelLarge,
              ),
              SizedBox(height: 14.h),
              // Challenge description text
              Text(
                "Enjoy crispy roasted broccoli every day for 7 days\n"
                "—crunch your way to better health! 🥦✨",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelLarge,
              ),
              SizedBox(height: 40.h),
              // Time remaining indicator
              Text(
                "Time left: 15 days",
                style: theme.textTheme.labelLarge,
              )
            ],
          ),
        )
      ],
    );
  }

  /// Builds the top section of the dialog containing the broccoli vector and close button
  Widget _buildRowvectorone(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Broccoli vector image
          CustomImageView(
            imagePath: ImageConstant.imgVector60x60,
            height: 60.h,
            width: 62.h,
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 124.h),
          ),
          // Close button
          CustomImageView(
            imagePath: ImageConstant.imgXButton,
            height: 20.h,
            width: 22.h,
            margin: EdgeInsets.only(top: 4.h),
          )
        ],
      ),
    );
  }
}
