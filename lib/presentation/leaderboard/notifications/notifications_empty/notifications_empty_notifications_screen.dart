import 'package:flutter/material.dart';
import '../../../../../core/app_export.dart';
import '../../../../../theme/custom_button_style.dart';
import '../../../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../../../widgets/app_bar/appbar_subtitle.dart';
import '../../../../../widgets/app_bar/custom_app_bar.dart';
import '../../../../../widgets/custom_elevated_button.dart';
import 'models/notifications_empty_notifications_model.dart';
import 'provider/notifications_empty_notifications_provider.dart';

// Screen widget that handles the empty notifications state
class NotificationsEmptyNotificationsScreen extends StatefulWidget {
  const NotificationsEmptyNotificationsScreen({Key? key})
      : super(
          key: key,
        );

  @override
  NotificationsEmptyNotificationsScreenState createState() =>
      NotificationsEmptyNotificationsScreenState();

  // Builder method to create the screen with its provider
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NotificationsEmptyNotificationsProvider(),
      child: NotificationsEmptyNotificationsScreen(),
    );
  }
}

class NotificationsEmptyNotificationsScreenState
    extends State<NotificationsEmptyNotificationsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.onErrorContainer,
      appBar: _buildAppbar(context),
      body: SafeArea(
        top: false,
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Notifications",
                  style: theme.textTheme.displaySmall,
                ),
              ),
              Spacer(
                flex: 45,
              ),
              Text(
                "No notifications yet.",
                style: CustomTextStyles.headlineSmallBluegray400,
              ),
              Spacer(
                flex: 54,
              ),
              CustomElevatedButton(
                height: 30.h,
                width: 164.h,
                text: "Clear Notifications",
                buttonStyle: CustomButtonStyles.fillBlueGrayTL16,
                buttonTextStyle: CustomTextStyles.bodyLargeOnErrorContainer,
              ),
              SizedBox(height: 50.h)
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget for building the custom app bar
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 38.h,
      leadingWidth: 20.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftPrimary,
        margin: EdgeInsets.only(left: 4.h),
      ),
      title: AppbarSubtitle(
        text: "Leaderboard",
        margin: EdgeInsets.only(left: 7.h),
      ),
    );
  }
}
