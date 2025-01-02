import 'package:flutter/material.dart';
import '../../../../../core/app_export.dart';
import 'provider/avocado_challenge_provider.dart';

// ignore_for_file: must_be_immutable
class AvocadoChallengeDialog extends StatefulWidget {
  const AvocadoChallengeDialog({Key? key}) : super(key: key);

  @override
  AvocadoChallengeDialogState createState() => AvocadoChallengeDialogState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AvocadoChallengeProvider(),
      child: AvocadoChallengeDialog(),
    );
  }
}

class AvocadoChallengeDialogState extends State<AvocadoChallengeDialog> {
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
            left: 14.h,
            top: 16.h,
            right: 14.h,
          ),
          decoration: AppDecoration.greenavocadochallenge,
          width: double.maxFinite,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgVector76x86,
                height: 76.h,
                width: 88.h,
                margin: EdgeInsets.only(top: 6.h),
              ),
              SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.imgXButton,
                      height: 20.h,
                      width: 22.h,
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.only(right: 2.h),
                    ),
                    SizedBox(height: 52.h),
                    Text(
                      "Avocado \nchallenge",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelLarge,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      "Savor a slice of avocado toast every morning for 5 \n"
                      "days—creamy, crunchy, and oh-so-good! 🥑🍞✨",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelLarge,
                    ),
                    SizedBox(height: 34.h),
                    Text(
                      "Time left: 29 days",
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
