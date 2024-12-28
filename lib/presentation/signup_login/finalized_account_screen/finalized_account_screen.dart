import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../theme/custom_button_style.dart';
import '../../../widgets/custom_elevated_button.dart';
import 'models/finalized_account_model.dart';
import 'provider/finalized_account_provider.dart';

class FinalizedAccountScreen extends StatefulWidget {
  const FinalizedAccountScreen({Key? key}) : super(key: key);

  @override
  FinalizedAccountScreenState createState() => FinalizedAccountScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FinalizedAccountProvider(),
      child: FinalizedAccountScreen(),
    );
  }
}

class FinalizedAccountScreenState extends State<FinalizedAccountScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.onErrorContainer,
      body: SafeArea(
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(
            left: 24.h,
            top: 148.h,
            right: 24.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgLogo,
                height: 212.h,
                width: double.maxFinite,
                margin: EdgeInsets.only(
                  left: 36.h,
                  right: 34.h,
                ),
              ),
              SizedBox(height: 70.h),
              Text(
                "Congratulations!",
                style: CustomTextStyles.displaySmall36,
              ),
              SizedBox(height: 10.h),
              Text(
                "Thank you for joining our community!",
                style: CustomTextStyles.titleMediumGray50003,
              ),
              SizedBox(height: 30.h),
              CustomElevatedButton(
                height: 48.h,
                text: "Press to get started",
                buttonStyle: CustomButtonStyles.fillPrimary,
                buttonTextStyle: theme.textTheme.titleMedium!,
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.homeScreen,
                    (route) => false,
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
