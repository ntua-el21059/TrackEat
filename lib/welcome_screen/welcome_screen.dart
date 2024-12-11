import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../routes/app_routes.dart';
import '../widgets.dart';
import 'welcome_provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key})
      : super(
          key: key,
        );

  @override
  WelcomeScreenState createState() => WelcomeScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WelcomeProvider(),
      child: WelcomeScreen(),
    );
  }
}

class WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(
            horizontal: 24.h,
            vertical: 70.h,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Spacer(),
              CustomImageView(
                imagePath: ImageConstant.imgLogo,
                height: 212.h,
                width: double.maxFinite,
                margin: EdgeInsets.only(
                  left: 36.h,
                  right: 34.h,
                ),
              ),
              SizedBox(height: 80.h),
              Text(
                "msg_welcome_to_trackeat".tr,
                style: theme.textTheme.headlineSmall,
              ),
              SizedBox(height: 84.h),
              CustomElevatedButton(
                text: "lbl_login".tr,
              ),
              SizedBox(height: 16.h),
              Text(
                "lbl_or".tr,
                style: CustomTextStyles.bodyMediumBlack900,
              ),
              SizedBox(height: 6.h),
              GestureDetector(
                onTap: () {
                  onTapTxtCreateanone(context);
                },
                child: Text(
                  "msg_create_an_account".tr,
                  style: CustomTextStyles.bodyLargePrimary,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Navigates to the createAccountScreen when the action is triggered.
  void onTapTxtCreateanone(BuildContext context) {
    NavigatorService.pushNamed(
      AppRoutes.createAccountScreen,
    );
  }
}
