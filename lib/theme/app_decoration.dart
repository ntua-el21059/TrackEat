import 'package:flutter/material.dart';
import '../core/app_export.dart';

class AppDecoration {
  // Blackbroccoli challenge decorations
  static BoxDecoration get blackbrocollichallenge => BoxDecoration(
        color: appTheme.black900,
      );

  // Dark decorations
  static BoxDecoration get darkBlueContrastwithLightBlue => BoxDecoration(
        color: theme.colorScheme.primary,
      );

  // Fill decorations
  static BoxDecoration get fillBlack => BoxDecoration(
        color: appTheme.black900.withOpacity(0.4),
      );
  static BoxDecoration get fillBlueGray => BoxDecoration(
        color: appTheme.blueGray900,
      );
  static BoxDecoration get fillCyan => BoxDecoration(
        color: appTheme.cyan900,
      );
  static BoxDecoration get fillCyan900 => BoxDecoration(
        color: appTheme.cyan900,
        image: DecorationImage(
          image: AssetImage(ImageConstant.imgSirianimationshaky),
          fit: BoxFit.fill,
        ),
      );
  static BoxDecoration get fillLightGreen => BoxDecoration(
        color: appTheme.lightGreen500,
      );
  static BoxDecoration get fillOnErrorContainer => BoxDecoration(
        color: theme.colorScheme.onErrorContainer,
        image: DecorationImage(
          image: AssetImage(ImageConstant.imgSirianimationshaky),
          fit: BoxFit.fill,
        ),
      );
  static BoxDecoration get fillRed => BoxDecoration(
        color: appTheme.red90001,
      );
  static BoxDecoration get fillYellow => BoxDecoration(
        color: appTheme.yellow600,
      );

  // Gradient decorations
  static BoxDecoration get gradientBlackToBlack => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.5, 0.5),
          end: Alignment(0.5, 1),
          colors: [
            appTheme.black900.withOpacity(0),
            appTheme.black900.withOpacity(0.4),
            appTheme.black900.withOpacity(0),
          ],
        ),
      );
  static BoxDecoration get gradientLimeAToLightGreenA => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.51, 0.51),
          end: Alignment(0.51, 1.02),
          colors: [appTheme.limeA400, appTheme.lightGreenA700],
        ),
      );
  static BoxDecoration get gradientPinkAToRedA => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.5, 0.5),
          end: Alignment(0.5, 1),
          colors: [appTheme.pinkA200, appTheme.redA700],
        ),
      );

  // Gray decorations
  static BoxDecoration get gray2 => BoxDecoration();
  static BoxDecoration get graysWhite => BoxDecoration(
        color: theme.colorScheme.onErrorContainer,
      );

  // Challenge-specific decorations
  static BoxDecoration get greenavocadochallenge => BoxDecoration(
        color: appTheme.green500,
      );
  static BoxDecoration get purplewrapchallenge => BoxDecoration(
        color: appTheme.purple300,
      );
  static BoxDecoration get redcarnivorechallenge => BoxDecoration(
        color: appTheme.red500,
      );
  static BoxDecoration get yellowbananachallenge => BoxDecoration(
        color: appTheme.amberA400,
      );

  // Light decorations
  static BoxDecoration get lightBlueLayoutPadding => BoxDecoration(
        color: appTheme.blue100,
      );
  static BoxDecoration get lightGreyButtonsPadding => BoxDecoration(
        color: appTheme.blueGray10001,
      );
  static BoxDecoration get lightThemePrimarySurface => BoxDecoration(
        color: appTheme.gray100,
      );

  // Navy decorations
  static BoxDecoration get navyBlueAIChatBackground => BoxDecoration(
        color: appTheme.cyan900,
      );

  // Outline decorations
  static BoxDecoration get outline => BoxDecoration(
        color: appTheme.black900.withOpacity(0.4),
      );
  static BoxDecoration get outlineBlack => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(54.h),
          topRight: Radius.circular(54.h),
        ),
      );
  static BoxDecoration get outlineBlue => BoxDecoration(
        color: appTheme.gray50,
        border: Border.all(
          color: appTheme.blue100,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineBlue100 => BoxDecoration(
        color: theme.colorScheme.onErrorContainer,
        border: Border.all(
          color: appTheme.blue100,
          width: 1.h,
        ),
      );

  // Social decorations
  static BoxDecoration get socialProfilecontrastwithlightblue => BoxDecoration(
        color: const Color(0xFFB2D7FF),
        borderRadius: BorderRadius.circular(20),
      );

  // Suggestions background decorations
  static BoxDecoration get suggestionsbackground => BoxDecoration(
        color: appTheme.deepOrange100,
      );

  // Column decorations with images
  static BoxDecoration get column11 => BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImageConstant.imgDotCyanA200),
          fit: BoxFit.fill,
        ),
      );
  static BoxDecoration get column12 => BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImageConstant.imgDot),
          fit: BoxFit.fill,
        ),
      );
  static BoxDecoration get column32 => BoxDecoration();
}

class BorderRadiusStyle {
  // Circle borders
  static BorderRadius get circleBorder16 => BorderRadius.circular(16.h);
  static BorderRadius get circleBorder38 => BorderRadius.circular(38.h);
  static BorderRadius get circleBorder4 => BorderRadius.circular(4.h);

  // Custom borders
  static BorderRadius get customBorderTL54 => BorderRadius.only(
        topLeft: Radius.circular(54.h),
        topRight: Radius.circular(54.h),
      );

  // Rounded borders
  static BorderRadius get roundedBorder10 => BorderRadius.circular(10.h);
  static BorderRadius get roundedBorder20 => BorderRadius.circular(20.h);
  static BorderRadius get roundedBorder48 => BorderRadius.circular(48.h);
  static BorderRadius get roundedBorder54 => BorderRadius.circular(54.h);
  static BorderRadius get roundedBorder68 => BorderRadius.circular(68.h);
  static BorderRadius get roundedBorder96 => BorderRadius.circular(96.h);
}