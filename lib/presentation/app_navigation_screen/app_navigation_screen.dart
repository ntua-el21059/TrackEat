import 'package:flutter/material.dart';
import '../../core/app_export.dart';
//import '../avocado_challenge_dialog/avocado_challenge_dialog.dart';
//import '../banana_challenge_dialog/banana_challenge_dialog.dart';
//import '../beatles_challenge_dialog/beatles_challenge_dialog.dart';
//import '../blur_choose_action_screen_dialog/blur_choose_action_screen_dialog.dart';
//import '../blur_edit_screen_dialog/blur_edit_screen_dialog.dart';
//import '../brocolli_challenge_dialog/brocolli_challenge_dialog.dart';
//import '../carnivore_challenge_dialog/carnivore_challenge_dialog.dart';
//import '../wrap_challenge_dialog/wrap_challenge_dialog.dart';
import 'models/app_navigation_model.dart';
import 'provider/app_navigation_provider.dart';

class AppNavigationScreen extends StatefulWidget {
  const AppNavigationScreen({Key? key}) : super(key: key);

  @override
  AppNavigationScreenState createState() => AppNavigationScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppNavigationProvider(),
      child: AppNavigationScreen(),
    );
  }
}

class AppNavigationScreenState extends State<AppNavigationScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFFFFFFF),
      body: SafeArea(
        child: SizedBox(
          width: 375.h,
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Color(0XFFFFFFFF),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 10.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.h),
                      child: const Text(
                        "App Navigation",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0XFF000000),
                          fontSize: 20,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Padding(
                      padding: EdgeInsets.only(left: 20.h),
                      child: const Text(
                        "Check your app's UI from the below demo screens of your app.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0XFF888888),
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0XFF000000),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0XFFFFFFFF),
                    ),
                    child: Column(
                      children: [
                        _buildScreenTitle(
                          context,
                          screenTitle: "Create account",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.createAccountScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Create profile (1/2)",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.createProfile12Screen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Create profile (2/2)",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.createProfile22Screen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Calorie calculator",
                          onTapScreenTitle: () => onTapScreenTitle(
                              AppRoutes.calorieCalculatorScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Home",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.homeScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "History: Today Tab",
                          onTapScreenTitle: () =>
                              onTapScreenTitle(AppRoutes.historyTodayTabScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "History: Empty breakfast",
                          onTapScreenTitle: () => onTapScreenTitle(
                              AppRoutes.historyEmptyBreakfastScreen),
                        ),
                        // _buildScreenTitle(
                        //   context,
                        //   screenTitle: "Blur - choose_action_screen - Dialog",
                        //   onTapScreenTitle: () => onTapDialogTitle(
                        //     context,
                        //     BlurChooseActionScreenDialog.builder(context),
                        //   ),
                        // ),
                        // _buildScreenTitle(
                        //   context,
                        //   screenTitle: "Blur - Edit screen - Dialog",
                        //   onTapScreenTitle: () => onTapDialogTitle(
                        //     context,
                        //     BlurEditScreenDialog.builder(context),
                        //   ),
                        // ),
                        // Add remaining screen titles here following the same pattern...
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Common click event for dialog
  void onTapDialogTitle(
    BuildContext context,
    Widget className,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: className,
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
        );
      },
    );
  }

  /// Common widget for building screen titles
  Widget _buildScreenTitle(
    BuildContext context, {
    required String screenTitle,
    Function? onTapScreenTitle,
  }) {
    return GestureDetector(
      onTap: () {
        onTapScreenTitle?.call();
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0XFFFFFFFF),
        ),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Text(
                screenTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0XFF000000),
                  fontSize: 20,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            SizedBox(height: 5.h),
            const Divider(
              height: 1,
              thickness: 1,
              color: Color(0XFF888888),
            ),
          ],
        ),
      ),
    );
  }

  /// Common click event
  void onTapScreenTitle(String routeName) {
    NavigatorService.pushNamed(routeName);
  }
}