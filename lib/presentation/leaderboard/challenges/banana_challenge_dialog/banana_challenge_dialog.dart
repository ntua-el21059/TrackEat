import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import 'models/banana_challenge_model.dart';
import 'provider/banana_challenge_provider.dart';

// This directive indicates that we intentionally want this widget to be mutable
// ignore_for_file: must_be_immutable
class BananaChallengeDialog extends StatefulWidget {
  // Constructor with an optional key parameter
  const BananaChallengeDialog({Key? key})
      : super(
          key: key,
        );

  @override
  BananaChallengeDialogState createState() => BananaChallengeDialogState();

  // Factory method to create the widget with its associated provider
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BananaChallengeProvider(),
      child: BananaChallengeDialog(),
    );
  }
}

class BananaChallengeDialogState extends State<BananaChallengeDialog> {
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
          decoration: AppDecoration.yellowbananachallenge,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildRowvectorone(context),
              SizedBox(height: 4.h),
              Text(
                "Banana \nchallenge",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelLarge,
              ),
              SizedBox(height: 12.h),
              Text(
                "Bake and enjoy a slice of homemade banana \n"
                "bread every day for a week—comfort and \n"
                "flavor in every bite! 🍌🍞✨",
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelLarge,
              ),
              SizedBox(height: 20.h),
              Text(
                "Time left: 10 days",
                style: theme.textTheme.labelLarge,
              )
            ],
          ),
        )
      ],
    );
  }

  /// Section Widget for the top row containing the banana vector and close button
  Widget _buildRowvectorone(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgVector58x56,
            height: 58.h,
            width: 58.h,
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(
              left: 126.h,
              top: 8.h,
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgXButton,
            height: 20.h,
            width: 22.h,
          )
        ],
      ),
    );
  }
}
