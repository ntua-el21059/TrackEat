import 'package:flutter/material.dart';
import '../core/app_export.dart';

LightCodeColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();

/// Helper class for managing themes and colors.
// ignore_for_file: must_be_immutable
class ThemeHelper {
  // The current app theme
  var _appTheme = PrefUtils().getThemeData();

  // A map of custom color themes supported by the app
  Map<String, LightCodeColors> _supportedCustomColor = {
    'lightCode': LightCodeColors()
  };

  // A map of color schemes supported by the app
  Map<String, ColorScheme> _supportedColorScheme = {
    'lightCode': ColorSchemes.lightCodeColorScheme
  };

  /// Returns the lightCode colors for the current theme.
  LightCodeColors _getThemeColors() {
    return _supportedCustomColor[_appTheme] ?? LightCodeColors();
  }

  /// Returns the current theme data.
  ThemeData _getThemeData() {
    var colorScheme =
        _supportedColorScheme[_appTheme] ?? ColorSchemes.lightCodeColorScheme;
    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
      textTheme: TextThemes.textTheme(colorScheme),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: appTheme.gray40002,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.h),
          ),
          elevation: 0,
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: colorScheme.onErrorContainer,
          side: BorderSide(
            color: appTheme.blue100,
            width: 1.h,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.h),
          ),
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return Colors.transparent;
        }),
        side: BorderSide(
          color: appTheme.gray300,
          width: 1,
        ),
        visualDensity: const VisualDensity(
          vertical: -4,
          horizontal: -4,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
      ),
      dividerTheme: DividerThemeData(
        thickness: 1,
        space: 1,
        color: colorScheme.onErrorContainer,
      ),
    );
  }

  /// Returns the lightCode colors for the current theme.
  LightCodeColors themeColor() => _getThemeColors();

  /// Returns the current theme data.
  ThemeData themeData() => _getThemeData();
}

/// Class containing the supported text theme styles.
class TextThemes {
  static TextTheme textTheme(ColorScheme colorScheme) => TextTheme(
        bodyLarge: TextStyle(
          color: colorScheme.primary,
          fontSize: 17.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: colorScheme.onErrorContainer,
          fontSize: 15.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          color: appTheme.gray50002,
          fontSize: 12.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
        displayMedium: TextStyle(
          color: appTheme.black900,
          fontSize: 40.fSize,
          fontFamily: 'SF Pro',
          fontWeight: FontWeight.w400,
        ),
        displaySmall: TextStyle(
          color: appTheme.black900,
          fontSize: 34.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
        ),
        headlineLarge: TextStyle(
          color: colorScheme.onErrorContainer,
          fontSize: 32.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          color: appTheme.black900,
          fontSize: 28.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
        ),
        headlineSmall: TextStyle(
          color: appTheme.black900,
          fontSize: 24.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
        labelLarge: TextStyle(
          color: colorScheme.onErrorContainer,
          fontSize: 13.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
        ),
        labelMedium: TextStyle(
          color: appTheme.gray50001,
          fontSize: 10.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
        ),
        titleLarge: TextStyle(
          color: colorScheme.onErrorContainer,
          fontSize: 22.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          color: colorScheme.onErrorContainer,
          fontSize: 16.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          color: colorScheme.onErrorContainer,
          fontSize: 14.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
        ),
      );
}

/// Class containing the supported color schemes.
class ColorSchemes {
  static final lightCodeColorScheme = ColorScheme.light(
    primary: Color(0XFF007AFF),
    primaryContainer: Color(0XFF171E04),
    errorContainer: Color(0XFF99223A),
    onErrorContainer: Color(0XFFFFFFFF),
    onPrimary: Color(0XFF0D0D0D),
    onPrimaryContainer: Color(0XFF00D6DA),
  );
}

/// Class containing custom colors for a lightCode theme.
class LightCodeColors {
  // Blue
  Color get blue100 => Color(0XFFB2D7FF);
  Color get blue400 => Color(0XFF3CA3FF);
  Color get blue800 => Color(0XFF065FB8);
  Color get blueA200 => Color(0XFF428FFF);

  // BlueGray
  Color get blueGray100 => Color(0XFFD0D5DD);
  Color get blueGray10001 => Color(0XFFD9D9D9);
  Color get blueGray400 => Color(0XFF8E8E93);
  Color get blueGray500 => Color(0XFF6D7E8C);
  Color get blueGray700 => Color(0XFF4B5768);
  Color get blueGray900 => Color(0XFF0B2840);
  Color get blueGray90001 => Color(0XFF303030);

  // Cyan
  Color get cyan900 => Color(0XFF12436A);
  Color get cyanA200 => Color(0XFF00FFF6);

  // DeepOrange
  Color get deepOrange100 => Color(0XFFFFBAB2);

  // DeepPurple
  Color get deepPurpleA100 => Color(0XFFBC82F3);
  Color get deepPurpleA10001 => Color(0XFFAA6EEE);
  Color get deepPurpleA10002 => Color(0XFFC686FF);

  // Gray
  Color get gray100 => Color(0XFFF3F4F9);
  Color get gray300 => Color(0XFFE3E4E8);
  Color get gray30001 => Color(0XFFE4E6EA);
  Color get gray30002 => Color(0XFFE3E6EA);
  Color get gray400 => Color(0XFFB6B6B7);
  Color get gray40001 => Color(0XFFBEBEBE);
  Color get gray40002 => Color(0XFFAFB0B4);
  Color get gray50 => Color(0XFFFBFBFB);
  Color get gray500 => Color(0XFF999DA3);
  Color get gray50001 => Color(0XFF999999);
  Color get gray50002 => Color(0XFF9A9999);
  Color get gray50003 => Color(0XFF928FA6);
  Color get gray50004 => Color(0XFF909093);
  Color get gray5001 => Color(0XFFF7F8FA);
  Color get gray5002 => Color(0XFFFFFAFA);
  Color get gray600 => Color(0XFF808080);
  Color get gray60028 => Color(0X28787880);
  Color get gray60066 => Color(0X66767680);
  Color get gray700 => Color(0XFF606060);
  Color get gray800 => Color(0XFF4F4F4F);
  Color get gray80099 => Color(0X993C3C43);
  Color get gray900 => Color(0XFF191D23);
  Color get gray90001 => Color(0XFF262626);
  Color get gray90002 => Color(0XFF243010);
  Color get gray90003 => Color(0XFF1E1E1E);
  Color get gray90004 => Color(0XFF001E2F);
  Color get gray90005 => Color(0XFF181818);

  // Green
  Color get green500 => Color(0XFF34C759);
  Color get green600 => Color(0XFF34A853);
  Color get green800 => Color(0XFF109320);

  // Indigo
  Color get indigo200 => Color(0XFF96B8DD);
  Color get indigoA100 => Color(0XFF8D98FF);

  // LightBlue
  Color get lightBlue300 => Color(0XFF5EC6F5);
  Color get lightBlue600 => Color(0XFF00A3D7);
  Color get lightBlueA700 => Color(0XFF0A84FF);

  // LightGreen
  Color get lightGreen500 => Color(0XFF87D63A);
  Color get lightGreenA700 => Color(0XFF60E700);

  // Lime
  Color get limeA400 => Color(0XFFB7FF00);
  Color get limeA700 => Color(0XFFA6FF00);

  // Orange
  Color get orange200 => Color(0XFFFFBA71);
  Color get orange600 => Color(0XFFE89700);

  // Pink
  Color get pinkA200 => Color(0XFFFF3288);

  // Purple
  Color get purple100 => Color(0XFFF4B9EA);
  Color get purple300 => Color(0XFFAF52DE);

  // Red
  Color get red300 => Color(0XFFFF6777);
  Color get red500 => Color(0XFFFF3B30);
  Color get red900 => Color(0XFFBE1818);
  Color get red90001 => Color(0XFFB5160A);
  Color get redA400 => Color(0XFFFA114F);
  Color get redA700 => Color(0XFFE2021A);
  Color get redA70001 => Color(0XFFFF0011);

  // Teal
  Color get teal200 => Color(0XFF78D9B9);
  Color get tealA400 => Color(0XFF00FAD0);

  // Yellow
  Color get yellow600 => Color(0XFFFFD336);

  // Amber
  Color get amberA400 => Color(0XFFFFCC00);
  Color get amber300 => Color(0XFFF8CB58);

  // Black
  Color get black900 => Color(0XFF000000);

  // Add additional colors as required
}