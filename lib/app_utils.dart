import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_theme.dart';

final Map<String, String> enUs = {
  "lbl_email": "Email",
  "lbl_password": "Password ",
  "lbl_timapple": "timapple",
  "lbl_trackeat": "TrackEat",
  "lbl_username": "Username",
  "msg_appleseed_mail_com": "Appleseed@mail.com",
  "msg_re_enter_your_password": "Re-enter your password",
  "msg_we_are_tremendously": "We are tremendously happy to \nsee you joining our community",
  "lbl_01_01_2000": "01/01/2000",
  "lbl_appleseed": "Appleseed",
  "lbl_birthdate": "Birthdate ",
  "lbl_first_name": "First name",
  "lbl_gender": "Gender",
  "lbl_john": "John",
  "lbl_last_name": "Last name",
  "lbl_male": "Male",
  "msg_let_s_complete_your": "Let’s complete your profile (1/3)",
  "msg_please_fill_in_your": "Please fill in your details. ",
  "lbl_180": "180",
  "lbl_80": "80",
  "lbl_activity": "Activity",
  "lbl_diet_optional": "Diet (Optional)",
  "lbl_goal": "Goal",
  "lbl_height_cm": "Height (cm)",
  "lbl_lose_weight": "Lose weight",
  "lbl_vegan": "Vegan",
  "msg_current_weight_kg": "Current weight (Kg)",
  "msg_daily_6_7_times": "Daily(6/7 times a week)",
  "msg_let_s_complete_your2": "Let’s complete your profile (2/3)",
  "lbl_2500": "2500",
  "lbl_finish": "Finish",
  "msg_calories_per_day": "Calories per day ",
  "msg_let_s_complete_your3": "Let’s complete your profile (3/3)",
  "msg_our_calorie_calculator":
      "Our calorie calculator made a personalized\nestimation for your calorie consumption \nat 2400 kcal daily. \nWould you like to set it as your daily goal \nor input your own calorie choice?",
  "lbl_login": "Login",
  "lbl_or": "or",
  "msg_create_an_account": "Create an account",
  "msg_welcome_to_trackeat": "Welcome to TrackEat!",
  "lbl_next": "Next",
  "err_msg_field_cannot_be_empty": "Field cannot be empty",
  "err_msg_please_enter_valid_email": "Please enter valid email",
  "msg_network_err": "Network Error",
  "msg_something_went_wrong": "Something Went Wrong!"
};

const num FIGMA_DESIGN_WIDTH = 393;
const num FIGMA_DESIGN_HEIGHT = 852;
const num FIGMA_DESIGN_STATUS_BAR = 0;
const String dateTimeFormatPattern = 'dd/MM/yyyy';
const String D_M_Y = 'd/M/y';

bool isValidEmail(String? inputString, {bool isRequired = false}) {
  bool isInputStringValid = false;
  if (!isRequired && (inputString == null || inputString.isEmpty)) {
    isInputStringValid = true;
  }
  if (inputString != null && inputString.isNotEmpty) {
    const pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final regExp = RegExp(pattern);
    isInputStringValid = regExp.hasMatch(inputString);
  }
  return isInputStringValid;
}

extension LocalizationExtension on String {
  String get tr => AppLocalization.of().getString(this);
}

extension ResponsiveExtension on num {
  double get _width => SizeUtils.width;
  double get h => ((this * _width) / FIGMA_DESIGN_WIDTH);
  double get fSize => ((this * _width) / FIGMA_DESIGN_WIDTH);
}

extension FormatExtension on double {
  double toDoubleValue({int fractionDigits = 2}) {
    return double.parse(this.toStringAsFixed(fractionDigits));
  }

  double isNonZero({num defaultValue = 0.0}) {
    return this > 0 ? this : defaultValue.toDouble();
  }
}

extension DateTimeExtension on DateTime {
  String format({
    String pattern = dateTimeFormatPattern,
    String? locale,
  }) {
    if (locale != null && locale.isNotEmpty) {
      initializeDateFormatting(locale);
    }
    return DateFormat(pattern, locale).format(this);
  }
}

enum DeviceType { mobile, tablet, desktop }

typedef ResponsiveBuild = Widget Function(
    BuildContext context, Orientation orientation, DeviceType deviceType);

class ImageConstant {
  static String imagePath = 'assets/images';

  static String imgIconEye = '$imagePath/img_icon_eye.png';
  static String imgArrowLeft = '$imagePath/img_arrow_left.svg';
  static String imgLogo = '$imagePath/img_logo.png';
  static String img = '$imagePath/img_.png';
  static String imageNotFound = 'assets/images/image_not_found.png';
}

class AppLocalization {
  AppLocalization(this.locale);
  Locale locale;

  static final Map<String, Map<String, String>> _localizedValues = {'en': enUs};

  static AppLocalization of() {
    return Localizations.of<AppLocalization>(
        NavigatorService.navigatorKey.currentContext!, AppLocalization)!;
  }

  static List<String> languages() => _localizedValues.keys.toList();

  String getString(String text) =>
      _localizedValues[locale.languageCode]![text] ?? text;
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalization.languages().contains(locale.languageCode);

  @override
  Future<AppLocalization> load(Locale locale) {
    return SynchronousFuture<AppLocalization>(AppLocalization(locale));
  }

  @override
  bool shouldReload(AppLocalizationDelegate old) => false;
}

class PrefUtils {
  PrefUtils() {
    SharedPreferences.getInstance().then((value) {
      _sharedPreferences = value;
    });
  }

  static SharedPreferences? _sharedPreferences;

  Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    print('SharedPreference Initialized');
  }

  void clearPreferencesData() async {
    _sharedPreferences!.clear();
  }

  Future<void> setThemeData(String value) {
    return _sharedPreferences!.setString('themeData', value);
  }

  String getThemeData() {
    try {
      return _sharedPreferences!.getString('themeData')!;
    } catch (e) {
      return 'primary';
    }
  }
}

class Sizer extends StatelessWidget {
  const Sizer({Key? key, required this.builder}) : super(key: key);

  final ResponsiveBuild builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeUtils.setScreenSize(constraints, orientation);
        return builder(context, orientation, SizeUtils.deviceType);
      });
    });
  }
}

class SizeUtils {
  static late BoxConstraints boxConstraints;
  static late Orientation orientation;
  static late DeviceType deviceType;
  static late double height;
  static late double width;

  static void setScreenSize(
    BoxConstraints constraints,
    Orientation currentOrientation,
  ) {
    boxConstraints = constraints;
    orientation = currentOrientation;
    if (orientation == Orientation.portrait) {
      width =
          boxConstraints.maxWidth.isNonZero(defaultValue: FIGMA_DESIGN_WIDTH);
      height = boxConstraints.maxHeight.isNonZero();
    } else {
      width =
          boxConstraints.maxHeight.isNonZero(defaultValue: FIGMA_DESIGN_WIDTH);
      height = boxConstraints.maxWidth.isNonZero();
    }
    deviceType = DeviceType.mobile;
  }
}

class NavigatorService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future<dynamic> pushNamed(
    String routeName, {
    dynamic arguments,
  }) async {
    return navigatorKey.currentState
        ?.pushNamed(routeName, arguments: arguments);
  }

  static void goBack() {
    return navigatorKey.currentState?.pop();
  }

  static Future<dynamic> pushNamedAndRemoveUntil(
    String routeName, {
    bool routePredicate = false,
    dynamic arguments,
  }) async {
    return navigatorKey.currentState?.pushNamedAndRemoveUntil(
        routeName, (route) => routePredicate,
        arguments: arguments);
  }

  static Future<dynamic> popAndPushNamed(
    String routeName, {
    dynamic arguments,
  }) async {
    return navigatorKey.currentState
        ?.popAndPushNamed(routeName, arguments: arguments);
  }
}