import 'package:flutter/material.dart';
/*
import '../presentation/accessibility_settings_screen/accessibility_settings_screen.dart';
import '../presentation/ai_chat_camera_flash_on_screen/ai_chat_camera_flash_on_screen.dart';
import '../presentation/ai_chat_camera_screen/ai_chat_camera_screen.dart';
import '../presentation/ai_chat_food_logging_as_screen/ai_chat_food_logging_as_screen.dart';
import '../presentation/ai_chat_food_logging_confirmation_screen/ai_chat_food_logging_confirmation_screen.dart';
import '../presentation/ai_chat_food_track_successful_screen/ai_chat_food_track_successful_screen.dart';
import '../presentation/ai_chat_info_screen/ai_chat_info_screen.dart';
import '../presentation/ai_chat_main_screen/ai_chat_main_screen.dart';
import '../presentation/ai_chat_photo_confirmation_screen/ai_chat_photo_confirmation_screen.dart';
import '../presentation/ai_chat_splash_screen/ai_chat_splash_screen.dart';
import '../presentation/app_navigation_screen/app_navigation_screen.dart';
import '../presentation/calorie_calculator_screen/calorie_calculator_screen.dart';
import '../presentation/challenge_award_screen/challenge_award_screen.dart';
import '../presentation/create_account_screen/create_account_screen.dart';
import '../presentation/create_profile_1_2_screen/create_profile_1_2_screen.dart';
import '../presentation/create_profile_2_2_screen/create_profile_2_2_screen.dart';
import '../presentation/finalized_account_screen/finalized_account_screen.dart';
import '../presentation/find_friends_screen/find_friends_screen.dart';
import '../presentation/find_friends_search_screen/find_friends_search_screen.dart';
import '../presentation/forgot_password_screen/forgot_password_screen.dart';
import '../presentation/history_empty_breakfast_screen/history_empty_breakfast_screen.dart';
import '../presentation/history_today_tab_screen/history_today_tab_screen.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/leaderboard_1_2_screen/leaderboard_1_2_screen.dart';
import '../presentation/leaderboard_2_2_screen/leaderboard_2_2_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/notifications_empty_notifications_screen/notifications_empty_notifications_screen.dart';
import '../presentation/notifications_read_screen/notifications_read_screen.dart';
import '../presentation/notifications_unread_screen/notifications_unread_screen.dart';
import '../presentation/profile_screen/profile_screen.dart';
import '../presentation/profile_static_calendar_open_screen/profile_static_calendar_open_screen.dart';
import '../presentation/profile_static_height_screen/profile_static_height_screen.dart';
import '../presentation/profile_static_keyboard_open_screen/profile_static_keyboard_open_screen.dart';
import '../presentation/profile_static_screen/profile_static_screen.dart';
import '../presentation/profile_static_sex_screen/profile_static_sex_screen.dart';
import '../presentation/reset_password_screen/reset_password_screen.dart';
import '../presentation/reward_screen_new_award_screen/reward_screen_new_award_screen.dart';
import '../presentation/reward_screen_rings_closed_screen/reward_screen_rings_closed_screen.dart';
import '../presentation/social_profile_message_from_profile_screen/social_profile_message_from_profile_screen.dart';
import '../presentation/social_profile_myself_screen/social_profile_myself_screen.dart';
import '../presentation/social_profile_others_screen/social_profile_others_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/welcome_screen/welcome_screen.dart';
*/
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
        //createAccountScreen: CreateAccountScreen.builder,
        //createProfile12Screen: CreateProfile12Screen.builder,
        //createProfile22Screen: CreateProfile22Screen.builder,
        //calorieCalculatorScreen: CalorieCalculatorScreen.builder,
        //homeScreen: HomeScreen.builder,
        //historyTodayTabScreen: HistoryTodayTabScreen.builder,
        //historyEmptyBreakfastScreen: HistoryEmptyBreakfastScreen.builder,
        //aiChatSplashScreen: AiChatSplashScreen.builder,
        //aiChatMainScreen: AiChatMainScreen.builder,
        //aiChatInfoScreen: AiChatInfoScreen.builder,
        //aiChatCameraScreen: AiChatCameraScreen.builder,
        //aiChatCameraFlashOnScreen: AiChatCameraFlashOnScreen.builder,
        //aiChatPhotoConfirmationScreen: AiChatPhotoConfirmationScreen.builder,
        //splashScreen: SplashScreen.builder,
        //welcomeScreen: WelcomeScreen.builder,
        //loginScreen: LoginScreen.builder,
        //forgotPasswordScreen: ForgotPasswordScreen.builder,
        //resetPasswordScreen: ResetPasswordScreen.builder,
        //finalizedAccountScreen: FinalizedAccountScreen.builder,
        //aiChatFoodLoggingConfirmationScreen: AiChatFoodLoggingConfirmationScreen.builder,
        //aiChatFoodLoggingAsScreen: AiChatFoodLoggingAsScreen.builder,
        //aiChatFoodTrackSuccessfulScreen: AiChatFoodTrackSuccessfulScreen.builder,
        //socialProfileOthersScreen: SocialProfileOthersScreen.builder,
        //socialProfileMessageFromProfileScreen: SocialProfileMessageFromProfileScreen.builder,
        //profileScreen: ProfileScreen.builder,
        //profileStaticScreen: ProfileStaticScreen.builder,
        //socialProfileMyselfScreen: SocialProfileMyselfScreen.builder,
        //challengeAwardScreen: ChallengeAwardScreen.builder,
        //accessibilitySettingsScreen: AccessibilitySettingsScreen.builder,
        //rewardScreenRingsClosedScreen: RewardScreenRingsClosedScreen.builder,
        //rewardScreenNewAwardScreen: RewardScreenNewAwardScreen.builder,
        //leaderboard12Screen: Leaderboard12Screen.builder,
        //leaderboard22Screen: Leaderboard22Screen.builder,
        //findFriendsScreen: FindFriendsScreen.builder,
        //findFriendsSearchScreen: FindFriendsSearchScreen.builder,
        //profileStaticSexScreen: ProfileStaticSexScreen.builder,
        //profileStaticHeightScreen: ProfileStaticHeightScreen.builder,
        //profileStaticKeyboardOpenScreen: ProfileStaticKeyboardOpenScreen.builder,
        //profileStaticCalendarOpenScreen: ProfileStaticCalendarOpenScreen.builder,
        //notificationsUnreadScreen: NotificationsUnreadScreen.builder,
        //notificationsEmptyNotificationsScreen: NotificationsEmptyNotificationsScreen.builder,
        //notificationsReadScreen: NotificationsReadScreen.builder,
        //appNavigationScreen: AppNavigationScreen.builder,
        //initialRoute: SplashScreen.builder,
      };
}
