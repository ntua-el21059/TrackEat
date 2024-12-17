import 'package:flutter/material.dart';
import '../presentation/app_navigation_screen/app_navigation_screen.dart';
import '../presentation/calorie_calculator_screen/calorie_calculator_screen.dart';
import '../presentation/create_account_screen/create_account_screen.dart';
import '../presentation/create_profile_1_2_screen/create_profile_1_2_screen.dart';
import '../presentation/create_profile_2_2_screen/create_profile_2_2_screen.dart';
import '../presentation/welcome_screen/welcome_screen.dart';

class AppRoutes {
  static const String createAccountScreen = '/create_account_screen';
  static const String createProfile12Screen = '/create_profile_1_2_screen';
  static const String createProfile22Screen = '/create_profile_2_2_screen';
  static const String calorieCalculatorScreen = '/calorie_calculator_screen';
  static const String welcomeScreen = '/welcome_screen';
  static const String appNavigationScreen = '/app_navigation_screen';
  static const String initialRoute = '/initialRoute';

  static Map<String, WidgetBuilder> get routes => {
        createAccountScreen: CreateAccountScreen.builder,
        createProfile12Screen: CreateProfile12Screen.builder,
        createProfile22Screen: CreateProfile22Screen.builder,
        calorieCalculatorScreen: CalorieCalculatorScreen.builder,
        welcomeScreen: WelcomeScreen.builder,
        appNavigationScreen: AppNavigationScreen.builder,
        initialRoute: WelcomeScreen.builder,
      };
}