import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../theme/custom_button_style.dart';
import '../../../widgets/custom_elevated_button.dart';
import 'provider/welcome_provider.dart';
import '../login_screen/provider/login_provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

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
    _checkLoginState();
  }

  Future<void> _checkLoginState() async {
    final isLoggedIn = await LoginProvider.isUserLoggedIn();
    
    if (mounted && isLoggedIn) {
      // User is logged in, go directly to home screen
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.homeScreen,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.onErrorContainer,
      body: SafeArea(
        child: Container(
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
                "Welcome to TrackEat!",
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 84.h),
              CustomElevatedButton(
                height: 48.h,
                text: "Login",
                buttonStyle: CustomButtonStyles.fillPrimary,
                buttonTextStyle: theme.textTheme.titleMedium!,
                onPressed: () {
                  NavigatorService.pushNamed(AppRoutes.loginScreen);
                },
              ),
              SizedBox(height: 16.h),
              Text(
                "or",
                style: CustomTextStyles.bodyMediumBlack900,
              ),
              SizedBox(height: 6.h),
              GestureDetector(
                onTap: () {
                  NavigatorService.pushNamed(AppRoutes.createAccountScreen);
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 12.9.h),
                  child: Text(
                    "Create an account",
                    style: CustomTextStyles.bodyLarge18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}