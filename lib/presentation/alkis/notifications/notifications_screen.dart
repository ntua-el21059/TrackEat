import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import '../../../../theme/custom_button_style.dart';
import '../../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../../widgets/app_bar/appbar_subtitle.dart';
import '../../../../widgets/app_bar/custom_app_bar.dart';
import '../../../../widgets/custom_elevated_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'models/notifications_model.dart';
import 'provider/notifications_provider.dart';
import 'widgets/read_two_item_widget.dart';

enum NotificationScreenState { empty, unread, read }

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  NotificationsScreenState createState() => NotificationsScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NotificationsProvider(),
      child: NotificationsScreen(),
    );
  }
}

class NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationsProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: theme.colorScheme.onErrorContainer,
          appBar: _buildAppbar(context),
          body: SafeArea(
            top: false,
            child: _buildBody(context, provider),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 38.h,
      leadingWidth: 20.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftPrimary,
        margin: EdgeInsets.only(left: 4.h),
        onTap: () => Navigator.pop(context),
      ),
      title: AppbarSubtitle(
        text: "Leaderboard",
        margin: EdgeInsets.only(left: 7.h),
        onTap: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context, NotificationsProvider provider) {
    switch (provider.screenState) {
      case NotificationScreenState.empty:
        return _buildEmptyState(context);
      case NotificationScreenState.unread:
        return _buildUnreadState(context, provider);
      case NotificationScreenState.read:
        return _buildReadState(context, provider);
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 14.h),
              child: Text(
                "Notifications",
                style: theme.textTheme.displaySmall,
              ),
            ),
          ),
          Spacer(flex: 45),
          Text(
            "No notifications yet.",
            style: CustomTextStyles.headlineSmallBluegray400,
          ),
          Spacer(flex: 54),
          Center(
            child: CustomElevatedButton(
              height: 30.h,
              width: 164.h,
              text: "Clear Notifications",
              buttonStyle: CustomButtonStyles.fillBlueGrayTL16,
              buttonTextStyle: CustomTextStyles.bodyLargeOnErrorContainer,
            ),
          ),
          SizedBox(height: 50.h)
        ],
      ),
    );
  }

  Widget _buildUnreadState(
      BuildContext context, NotificationsProvider provider) {
    return SingleChildScrollView(
      child: SizedBox(
        width: double.maxFinite,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 14.h),
                child: Text(
                  "Notifications",
                  style: theme.textTheme.displaySmall,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            _buildUnreadSection(context, provider),
            SizedBox(height: 10.h),
            _buildReadSection(context, provider),
            SizedBox(height: 62.h),
            Center(
              child: _buildClearButton(context, provider),
            ),
            SizedBox(height: 50.h),
          ],
        ),
      ),
    );
  }

  Widget _buildReadState(BuildContext context, NotificationsProvider provider) {
    return SingleChildScrollView(
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 6.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10.h),
              child: Text(
                "Notifications",
                style: theme.textTheme.displaySmall,
              ),
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.only(left: 14.h),
              child: Text(
                "UNREAD",
                style: CustomTextStyles.labelLargeBluegray400,
              ),
            ),
            SizedBox(height: 16.h),
            Center(
              child: Text(
                "You are all caught up!",
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 14.h),
                  child: Text(
                    "READ",
                    style: CustomTextStyles.labelLargeBluegray400,
                  ),
                ),
                SizedBox(height: 10.h),
                ...provider.readNotifications.map((notification) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 6.h),
                    child: ReadTwoItemWidget(notification),
                  );
                }).toList(),
              ],
            ),
            SizedBox(height: 14.h),
            Center(
              child: _buildClearButton(context, provider),
            ),
            SizedBox(height: 50.h)
          ],
        ),
      ),
    );
  }

  Widget _buildUnreadSection(
      BuildContext context, NotificationsProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 14.h),
          child: Text(
            "UNREAD",
            style: CustomTextStyles.labelLargeSFProTextBluegray400,
          ),
        ),
        SizedBox(height: 10.h),
        ...provider.unreadNotifications.map((notification) {
          return Padding(
            padding: EdgeInsets.only(bottom: 6.h),
            child: ReadTwoItemWidget(notification),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildReadSection(
      BuildContext context, NotificationsProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 14.h),
          child: Text(
            "READ",
            style: CustomTextStyles.labelLargeBluegray400,
          ),
        ),
        SizedBox(height: 10.h),
        ...provider.readNotifications.map((notification) {
          return Padding(
            padding: EdgeInsets.only(bottom: 6.h),
            child: ReadTwoItemWidget(notification),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildClearButton(
      BuildContext context, NotificationsProvider provider) {
    return CustomElevatedButton(
      height: 30.h,
      width: 164.h,
      text: "Clear Notifications",
      buttonStyle: CustomButtonStyles.fillBlue,
      buttonTextStyle: CustomTextStyles.bodyLargeOnErrorContainer,
      onPressed: () => provider.clearNotifications(),
    );
  }
}
