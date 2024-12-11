import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../routes/app_routes.dart';
import '../widgets.dart';
import 'app_navigation_provider.dart';

class AppNavigationScreen extends StatefulWidget {
  const AppNavigationScreen({Key? key}) : super(key: key);

  @override
  AppNavigationScreenState createState() => AppNavigationScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppNavigationProvider(),
      child: const AppNavigationScreen(),
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0XFFFFFFFF),
        body: SizedBox(
          width: 375.h,
          child: Column(
            children: [
              _buildHeader(),
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
                              _onTapScreenTitle(context, AppRoutes.createAccountScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Create profile (1/2)",
                          onTapScreenTitle: () =>
                              _onTapScreenTitle(context, AppRoutes.createProfile12Screen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Create profile (2/2)",
                          onTapScreenTitle: () =>
                              _onTapScreenTitle(context, AppRoutes.createProfile22Screen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Calorie calculator",
                          onTapScreenTitle: () =>
                              _onTapScreenTitle(context, AppRoutes.calorieCalculatorScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Welcome Screen",
                          onTapScreenTitle: () =>
                              _onTapScreenTitle(context, AppRoutes.welcomeScreen),
                        ),
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

  Widget _buildHeader() {
    return Container(
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
          Divider(
            height: 1.h,
            thickness: 1.h,
            color: const Color(0XFF000000),
          ),
        ],
      ),
    );
  }

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
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: 5.h),
          ],
        ),
      ),
    );
  }

  void _onTapScreenTitle(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }
}
