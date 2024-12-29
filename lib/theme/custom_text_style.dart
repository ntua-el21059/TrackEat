import 'package:flutter/material.dart';
import '../core/app_export.dart';

/// Extension on [TextStyle] to easily apply specific font families.
extension TextStyleExtension on TextStyle {
  TextStyle get sFPro => copyWith(fontFamily: 'SF Pro');
  TextStyle get inter => copyWith(fontFamily: 'Inter');
  TextStyle get plusJakartaSans => copyWith(fontFamily: 'Plus Jakarta Sans');
  TextStyle get lato => copyWith(fontFamily: 'Lato');
  TextStyle get pacifico => copyWith(fontFamily: 'Pacifico');
  TextStyle get sFProDisplay => copyWith(fontFamily: 'SF Pro Display');
  TextStyle get sFProText => copyWith(fontFamily: 'SF Pro Text');
}

/// A collection of pre-defined text styles for customizing text appearance.
/// Categorized by different font families and weights.
/// This class includes extensions to easily apply specific font families.
class CustomTextStyles {
  // Body text styles
  static TextStyle get bodyLarge18 =>
      theme.textTheme.bodyLarge!.copyWith(fontSize: 18.fSize);

  static TextStyle get bodyLargeBlack900 =>
      theme.textTheme.bodyLarge!.copyWith(color: appTheme.black900);

  static TextStyle get bodyLargeBlack90016 =>
      theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.black900,
        fontSize: 16.fSize,
      );

  static TextStyle get bodyLargeBlack90018 =>
      theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.black900,
        fontSize: 18.fSize,
      );

  static TextStyle get bodyLargeBluegray10001 =>
      theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.blueGray10001,
        fontSize: 16.fSize,
      );

  static TextStyle get bodyLargeBluegray70018 =>
      theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.blueGray700,
        fontSize: 18.fSize,
      );

  static TextStyle get bodyLargeBluegray700 =>
      theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.blueGray700,
      );

  static TextStyle get bodyLargeGray900 =>
      theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.gray900,
        fontSize: 16.fSize,
        fontWeight: FontWeight.w300,
      );

  static TextStyle get bodyLargeOnErrorContainer =>
      theme.textTheme.bodyLarge!.copyWith(
        color: theme.colorScheme.onErrorContainer,
      );

  static TextStyle get bodyLargeSFProDisplayGray90005 =>
      theme.textTheme.bodyLarge!.sFProDisplay.copyWith(
        color: appTheme.gray90005.withAlpha(122),
        fontSize: 19.fSize,
      );

  static TextStyle get bodyLargeGray500 =>
      theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.gray500,
        fontSize: 16.fSize,
      );

  static TextStyle get bodyLargeGray50003 =>
      theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.gray50003,
        fontSize: 16.fSize,
      );

  static TextStyle get bodyLargeGray200 =>
      theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.gray500.withAlpha(153),
        fontSize: 16.fSize,
      );

  // Body Medium
  static TextStyle get bodyMediumBlack =>
      theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.black900,
      );

  static TextStyle get bodyMediumBlack900 =>
      theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.black900.withAlpha(64),
      );

  static TextStyle get bodyMediumPlusJakartaSansGray800 =>
      theme.textTheme.bodyMedium!.plusJakartaSans.copyWith(
        color: appTheme.gray800,
        fontSize: 14.fSize,
      );

  static TextStyle get bodyMediumPrimary =>
      theme.textTheme.bodyMedium!.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w300,
      );

  // Body Small
  static TextStyle get bodySmallBlack900 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.black900.withAlpha(64),
        fontSize: 11.fSize,
      );

  static TextStyle get bodySmallPacificoGray50004 =>
      theme.textTheme.bodySmall!.pacifico.copyWith(
        color: appTheme.gray50004,
        fontSize: 10.fSize,
      );

  static TextStyle get bodySmallPrimary => theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.primary,
        fontSize: 11.fSize,
      );

  // Display text styles
  static TextStyle get displayMediumInter =>
      theme.textTheme.displayMedium!.inter.copyWith(
        fontWeight: FontWeight.w700,
      );

  static TextStyle get displaySmall36 =>
      theme.textTheme.displaySmall!.copyWith(fontSize: 36.fSize);

  // Headline text styles
  static TextStyle get headlineLargeBlack900 =>
      theme.textTheme.headlineLarge!.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get headlineLargeGray900 =>
      theme.textTheme.headlineLarge!.copyWith(
        color: appTheme.gray900,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get headlineMediumGray800 =>
      theme.textTheme.headlineMedium!.copyWith(
        color: appTheme.gray800,
        fontSize: 29.fSize,
      );

  static TextStyle get headlineSmallBluegray400 =>
      theme.textTheme.headlineSmall!.copyWith(
        color: appTheme.blueGray400,
      );

  static TextStyle get headlineSmallBold =>
      theme.textTheme.headlineSmall!.copyWith(
        fontWeight: FontWeight.w700,
      );

  // Label text styles
  static TextStyle get labelLargeBlack900 =>
      theme.textTheme.labelLarge!.copyWith(
        color: appTheme.black900,
        fontSize: 12.fSize,
      );

  static TextStyle get labelLargeSFProBluegray400 =>
      theme.textTheme.labelLarge!.sFPro.copyWith(
        color: appTheme.blueGray400,
        fontWeight: FontWeight.w600,
      );

  // Title text styles
  static TextStyle get titleLargeBlack900 =>
      theme.textTheme.titleLarge!.copyWith(
        color: appTheme.black900,
        fontSize: 20.fSize,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get titleLargeLimeA700 =>
      theme.textTheme.titleLarge!.copyWith(
        color: appTheme.limeA700,
      );

  static TextStyle get titleMediumGray400 =>
      theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray400,
      );

  static TextStyle get titleMediumGray50003 =>
      theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray50003,
      );

  static TextStyle get titleMediumLimeA700 =>
      theme.textTheme.titleMedium!.copyWith(
        color: appTheme.limeA700,
      );

  static TextStyle get titleMediumLatoGray90001 =>
      theme.textTheme.titleMedium!.lato.copyWith(
        color: appTheme.gray90001,
        fontSize: 18.fSize,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get titleSmallPlusJakartaSansGray800 =>
      theme.textTheme.titleSmall!.plusJakartaSans.copyWith(
        color: appTheme.gray800,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get titleSmallSemiBold =>
      theme.textTheme.titleSmall!.copyWith(
        fontWeight: FontWeight.w600,
      );

  // Title Small text styles
  static TextStyle get titleSmallBlack90015 =>
      theme.textTheme.titleSmall!.copyWith(
        color: appTheme.black900,
        fontSize: 15.fSize,
      );

  static TextStyle get titleMediumGray90001Bold =>
      theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray90001,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get labelMediumRed900 =>
      theme.textTheme.labelMedium!.copyWith(
        color: appTheme.red900,
      );

  static TextStyle get bodyLargeBlack90016_2 =>
      theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.black900,
        fontSize: 16.fSize,
      );

  static TextStyle get labelMediumOnErrorContainer_1 =>
      theme.textTheme.labelMedium!.copyWith(
        color: theme.colorScheme.onErrorContainer,
      );

  static TextStyle get titleLargeSemiBold => theme.textTheme.titleLarge!.copyWith(
        fontWeight: FontWeight.w600,
      );
}