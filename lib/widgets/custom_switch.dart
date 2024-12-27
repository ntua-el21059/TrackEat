import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import '../core/app_export.dart';

// ignore_for_file: must_be_immutable
class CustomSwitch extends StatelessWidget {
  CustomSwitch({
    Key? key,
    required this.onChange,
    this.alignment,
    this.value,
    this.width,
    this.height,
    this.margin,
  }) : super(key: key);

  final Alignment? alignment;
  bool? value;
  final Function(bool) onChange;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      child: alignment != null
          ? Align(
              alignment: alignment ?? Alignment.center,
              child: switchWidget,
            )
          : switchWidget,
    );
  }

  Widget get switchWidget => FlutterSwitch(
        value: value ?? false,
        height: 30.h,
        width: 50.h,
        toggleSize: 26,
        borderRadius: 14.h,
        activeColor: theme.colorScheme.primary,
        activeToggleColor: theme.colorScheme.onErrorContainer,
        inactiveColor: appTheme.gray60028,
        inactiveToggleColor: theme.colorScheme.onErrorContainer,
        onToggle: (value) {
          onChange(value);
        },
      );
}