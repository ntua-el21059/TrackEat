import 'package:flutter/material.dart';
import '../core/app_export.dart';

extension IconButtonStyleHelper on CustomIconButton {
  static BoxDecoration get outlineBlue => BoxDecoration(
        borderRadius: BorderRadius.circular(14.h),
        border: Border.all(
          color: appTheme.blue100,
          width: 1.h,
        ),
      );

  static BoxDecoration get outlineGray => BoxDecoration(
        borderRadius: BorderRadius.circular(14.h),
        border: Border.all(
          color: appTheme.gray600,
          width: 1.h,
        ),
      );

  static BoxDecoration get outlineGrayTL14 => BoxDecoration(
        color: appTheme.orange600,
        borderRadius: BorderRadius.circular(14.h),
        border: Border.all(
          color: appTheme.gray600,
          width: 1.h,
        ),
      );

  static BoxDecoration get none => BoxDecoration();
}

class CustomIconButton extends StatelessWidget {
  CustomIconButton({
    Key? key,
    this.alignment,
    this.height,
    this.width,
    this.decoration,
    this.padding,
    this.onTap,
    this.child,
  }) : super(key: key);

  final Alignment? alignment;
  final double? height;
  final double? width;
  final BoxDecoration? decoration;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: iconButtonWidget,
          )
        : iconButtonWidget;
  }

  Widget get iconButtonWidget => SizedBox(
        height: height ?? 0,
        width: width ?? 0,
        child: DecoratedBox(
          decoration: decoration ??
              BoxDecoration(
                borderRadius: BorderRadius.circular(24.h),
                gradient: LinearGradient(
                  begin: Alignment(0.0, 0),
                  end: Alignment(1.0, 0),
                  colors: [
                    theme.colorScheme.primaryContainer,
                    appTheme.gray90002,
                  ],
                ),
              ),
          child: IconButton(
            padding: padding ?? EdgeInsets.zero,
            onPressed: onTap,
            icon: child ?? Container(),
          ),
        ),
      );
}