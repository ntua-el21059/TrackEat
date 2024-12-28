import 'package:flutter/material.dart';
//import '../presentation/accessibility_settings_screen/accessibility_settings_screen.dart';
//import '../presentation/ai_chat_camera_flash_on_screen/ai_chat_camera_flash_on_screen.dart';
//import '../presentation/ai_chat_camera_screen/ai_chat_camera_screen.dart';
//import '../presentation/ai_chat_food_logging_as_screen/ai_chat_food_logging_as_screen.dart';
//import '../presentation/ai_chat_food_logging_confirmation_screen/ai_chat_food_logging_confirmation_screen.dart';
//import '../presentation/ai_chat_food_track_successful_screen/ai_chat_food_track_successful_screen.dart';
//import '../presentation/ai_chat_info_screen/ai_chat_info_screen.dart';
//import '../presentation/ai_chat_main_screen/ai_chat_main_screen.dart';
//import '../presentation/ai_chat_photo_confirmation_screen/ai_chat_photo_confirmation_screen.dart';
//import '../presentation/ai_chat_splash_screen/ai_chat_splash_screen.dart';
//import '../presentation/app_navigation_screen/app_navigation_screen.dart';
import '../presentation/signup_login/calorie_calculator_screen/calorie_calculator_screen.dart';
//import '../presentation/challenge_award_screen/challenge_award_screen.dart';
import '../presentation/signup_login/create_account_screen/create_account_screen.dart';
import '../presentation/signup_login/create_profile_1_2_screen/create_profile_1_2_screen.dart';
import '../presentation/signup_login/create_profile_2_2_screen/create_profile_2_2_screen.dart';
import '../presentation/signup_login/finalized_account_screen/finalized_account_screen.dart';
import '../presentation/signup_login/forgot_password_screen/forgot_password_screen.dart';
import '../presentation/signup_login/login_screen/login_screen.dart';
import '../presentation/signup_login/reset_password_screen/reset_password_screen.dart';
import '../presentation/signup_login/splash_screen/splash_screen.dart';
import '../presentation/signup_login/welcome_screen/welcome_screen.dart';
import '../presentation/homepage_history/home_screen/home_screen.dart';

class AppRoutes {
  static const String createAccountScreen = '/create_account_screen';
  static const String createProfile12Screen = '/create_profile_1_2_screen';
  static const String createProfile22Screen = '/create_profile_2_2_screen';
  static const String calorieCalculatorScreen = '/calorie_calculator_screen';
  static const String homeScreen = '/home_screen';
  static const String homeInitialPage = '/home_initial_page';
  static const String historyTodayTabScreen = '/history_today_tab_screen';
  static const String historyEmptyBreakfastScreen = '/history_empty_breakfast_screen';
  static const String aiChatSplashScreen = '/ai_chat_splash_screen';
  static const String aiChatMainScreen = '/ai_chat_main_screen';
  static const String aiChatInfoScreen = '/ai_chat_info_screen';
  static const String aiChatCameraScreen = '/ai_chat_camera_screen';
  static const String aiChatCameraFlashOnScreen = '/ai_chat_camera_flash_on_screen';
  static const String aiChatPhotoConfirmationScreen = '/ai_chat_photo_confirmation_screen';
  static const String splashScreen = '/splash_screen';
  static const String welcomeScreen = '/welcome_screen';
  static const String loginScreen = '/login_screen';
  static const String forgotPasswordScreen = '/forgot_password_screen';
  static const String resetPasswordScreen = '/reset_password_screen';
  static const String finalizedAccountScreen = '/finalized_account_screen';
  static const String aiChatFoodLoggingConfirmationScreen = '/ai_chat_food_logging_confirmation_screen';
  static const String aiChatFoodLoggingAsScreen = '/ai_chat_food_logging_as_screen';
  static const String aiChatFoodTrackSuccessfulScreen = '/ai_chat_food_track_successful_screen';
  static const String socialProfileOthersScreen = '/social_profile_others_screen';
  static const String socialProfileMessageFromProfileScreen = '/social_profile_message_from_profile_screen';
  static const String profileScreen = '/profile_screen';
  static const String profileStaticScreen = '/profile_static_screen';
  static const String socialProfileMyselfScreen = '/social_profile_myself_screen';
  static const String challengeAwardScreen = '/challenge_award_screen';
  static const String accessibilitySettingsScreen = '/accessibility_settings_screen';
  static const String rewardScreenRingsClosedScreen = '/reward_screen_rings_closed_screen';
  static const String rewardScreenNewAwardScreen = '/reward_screen_new_award_screen';
  static const String leaderboard12Screen = '/leaderboard_1_2_screen';
  static const String leaderboard22Screen = '/leaderboard_2_2_screen';
  static const String findFriendsScreen = '/find_friends_screen';
  static const String findFriendsSearchScreen = '/find_friends_search_screen';
  static const String profileStaticSexScreen = '/profile_static_sex_screen';
  static const String profileStaticHeightScreen = '/profile_static_height_screen';
  static const String profileStaticKeyboardOpenScreen = '/profile_static_keyboard_open_screen';
  static const String profileStaticCalendarOpenScreen = '/profile_static_calendar_open_screen';
  static const String notificationsUnreadScreen = '/notifications_unread_screen';
  static const String notificationsEmptyNotificationsScreen = '/notifications_empty_notifications_screen';
  static const String notificationsReadScreen = '/notifications_read_screen';
  static const String appNavigationScreen = '/app_navigation_screen';
  static const String initialRoute = '/initialRoute';

  static Map<String, WidgetBuilder> get routes => {
        splashScreen: SplashScreen.builder,
        welcomeScreen: WelcomeScreen.builder,
        createAccountScreen: CreateAccountScreen.builder,
        createProfile12Screen: CreateProfile12Screen.builder,
        createProfile22Screen: CreateProfile22Screen.builder,
        calorieCalculatorScreen: CalorieCalculatorScreen.builder,
        loginScreen: LoginScreen.builder,
        forgotPasswordScreen: ForgotPasswordScreen.builder,
        resetPasswordScreen: ResetPasswordScreen.builder,
        finalizedAccountScreen: FinalizedAccountScreen.builder,
        homeScreen: HomeScreen.builder,
        initialRoute: SplashScreen.builder,
      };
}
