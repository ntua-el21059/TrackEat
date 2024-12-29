import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import 'provider/accessibility_settings_provider.dart';

class AccessibilitySettingsScreen extends StatefulWidget {
  const AccessibilitySettingsScreen({Key? key}) : super(key: key);

  @override
  AccessibilitySettingsScreenState createState() => AccessibilitySettingsScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AccessibilitySettingsProvider(),
      child: AccessibilitySettingsScreen(),
    );
  }
}

class AccessibilitySettingsScreenState extends State<AccessibilitySettingsScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize settings after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AccessibilitySettingsProvider>(context, listen: false)
          .initializeSettings(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        height: 38.h,
        leadingWidth: 24.h,
        leading: AppbarLeadingImage(
          imagePath: ImageConstant.imgArrowLeftPrimary,
          margin: EdgeInsets.only(left: 8.h),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: AppbarSubtitle(
          text: "Profile",
          margin: EdgeInsets.only(left: 7.h),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.h),
              child: Text(
                "Accessibility Settings",
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.symmetric(horizontal: 8.h),
              padding: EdgeInsets.symmetric(
                horizontal: 10.h,
                vertical: 12.h,
              ),
              decoration: BoxDecoration(
                color: Color(0xFFB2D7FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSettingItem(
                    "VoiceOver",
                    context.watch<AccessibilitySettingsProvider>().voiceOver,
                    () => context.read<AccessibilitySettingsProvider>().toggleVoiceOver(),
                    isSwitch: false,
                  ),
                  Divider(height: 1, color: Colors.white.withOpacity(0.2)),
                  _buildSettingItem(
                    "Invert Colours",
                    context.watch<AccessibilitySettingsProvider>().invertColors,
                    () => context.read<AccessibilitySettingsProvider>().toggleInvertColors(context),
                    isSwitch: true,
                  ),
                  Divider(height: 1, color: Colors.white.withOpacity(0.2)),
                  _buildSettingItem(
                    "Larger Text",
                    context.watch<AccessibilitySettingsProvider>().largerText,
                    () => context.read<AccessibilitySettingsProvider>().toggleLargerText(context),
                    isSwitch: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(String title, bool value, VoidCallback onChanged, {bool isSwitch = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          isSwitch 
            ? CupertinoSwitch(
                value: value,
                onChanged: (_) => onChanged(),
                activeColor: Colors.blue,
              )
            : GestureDetector(
                onTap: onChanged,
                child: CustomImageView(
                  imagePath: ImageConstant.imgArrowRight,
                  height: 14.h,
                  width: 14.h,
                  color: Colors.white,
                ),
              ),
        ],
      ),
    );
  }
}