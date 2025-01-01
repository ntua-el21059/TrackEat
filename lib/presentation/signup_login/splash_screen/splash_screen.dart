import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import 'models/splash_model.dart';
import 'provider/splash_provider.dart';
import '../login_screen/provider/login_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SplashProvider(),
      child: SplashScreen(),
    );
  }
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginState();
  }

  Future<void> _checkLoginState() async {
    final isLoggedIn = await LoginProvider.isUserLoggedIn();
    
    if (mounted) {
      if (isLoggedIn) {
        // User is logged in, go directly to home screen
        NavigatorService.popAndPushNamed(AppRoutes.homeScreen);
      } else {
        // User is not logged in, go to welcome screen
        NavigatorService.popAndPushNamed(AppRoutes.welcomeScreen);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.onErrorContainer,
      body: SafeArea(
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgLogo,
                height: 212.h,
                width: 274.h,
              ),
              SizedBox(height: 2.h),
              Text(
                "TrackEat",
                style: CustomTextStyles.displayMediumInter,
              ),
            ],
          ),
        ),
      ),
    );
  }
}