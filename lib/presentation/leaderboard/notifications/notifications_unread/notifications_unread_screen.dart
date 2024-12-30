import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import 'models/notifications_unread_model.dart';
import 'models/read_two_item_model.dart';
import 'provider/notifications_unread_provider.dart';
import 'widgets/read_two_item_widget.dart';

class NotificationsUnreadScreen extends StatefulWidget {
  const NotificationsUnreadScreen({Key? key}) : super(key: key);

  @override
  NotificationsUnreadScreenState createState() =>
      NotificationsUnreadScreenState();

  /// Widget builder with ChangeNotifierProvider for state management
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NotificationsUnreadProvider(),
      child: NotificationsUnreadScreen(),
    );
  }
}

class NotificationsUnreadScreenState extends State<NotificationsUnreadScreen> {
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
          child: SingleChildScrollView(
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                children: [
                  // Notifications title
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

                  // UNREAD section
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 14.h),
                      child: Text(
                        "UNREAD".toUpperCase(),
                        style: CustomTextStyles.labelLargeSFProTextBluegray400,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  _buildFirst(context),
                  SizedBox(height: 6.h),
                  _buildSecond(context),
                  SizedBox(height: 6.h),
                  _buildThird(context),
                  SizedBox(height: 10.h),

                  // READ section
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 14.h),
                      child: Text(
                        "READ".toUpperCase(),
                        style: CustomTextStyles.labelLargeBluegray400,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  _buildReadtwo(context),
                  SizedBox(height: 62.h),
                  _buildClear(context),
                  SizedBox(height: 50.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// AppBar widget
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

  /// "Add" button widget
  Widget _buildAdd(BuildContext context) {
    return CustomElevatedButton(
      width: 74.h,
      text: "Add",
      rightIcon: Container(
        margin: EdgeInsets.only(left: 6.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgPersonfillbadgeplus1,
          height: 20.h,
          width: 20.h,
          fit: BoxFit.contain,
        ),
      ),
      buttonStyle: CustomButtonStyles.fillBlue,
    );
  }

  /// First unread notification widget
  Widget _buildFirst(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.h),
      padding: EdgeInsets.all(8.h),
      decoration: AppDecoration.lightBlueLayoutPadding.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder20,
      ),
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4.h),
            child: Text(
              "@nancy_raegan added you",
              style: CustomTextStyles.titleSmallBold,
            ),
          ),
          _buildAdd(context),
        ],
      ),
    );
  }

  /// "Open" button widget
  Widget _buildOpen(BuildContext context) {
    return CustomElevatedButton(
      width: 74.h,
      text: "Open",
      rightIcon: Container(
        margin: EdgeInsets.only(left: 4.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgMessagefill1,
          height: 14.h,
          width: 16.h,
          fit: BoxFit.contain,
        ),
      ),
      buttonStyle: CustomButtonStyles.fillBlue,
    );
  }

  /// Second unread notification widget
  Widget _buildSecond(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.h),
      padding: EdgeInsets.all(8.h),
      decoration: AppDecoration.lightBlueLayoutPadding.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder20,
      ),
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                left: 4.h,
                bottom: 4.h,
              ),
              child: Text(
                "@tim_cook sent a message",
                style: CustomTextStyles.titleSmallBold,
              ),
            ),
          ),
          _buildOpen(context),
        ],
      ),
    );
  }

  /// "View" button widget
  Widget _buildView(BuildContext context) {
    return CustomElevatedButton(
      width: 74.h,
      text: "View",
      rightIcon: Container(
        margin: EdgeInsets.only(left: 4.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgArrowrightOnerrorcontainer16x12,
          height: 16.h,
          width: 12.h,
          fit: BoxFit.contain,
        ),
      ),
      buttonStyle: CustomButtonStyles.fillBlue,
    );
  }

  /// Third unread notification widget
  Widget _buildThird(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.h),
      decoration: AppDecoration.lightBlueLayoutPadding.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 2.h),
              child: Text(
                "@olie12 started carnivore challenge",
                style: CustomTextStyles.titleSmallBold,
              ),
            ),
          ),
          SizedBox(width: 18.h),
          _buildView(context),
        ],
      ),
    );
  }

  /// Read notifications list widget
  Widget _buildReadtwo(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8.h),
      child: Consumer<NotificationsUnreadProvider>(
        builder: (context, provider, child) {
          return ListView.separated(
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) => SizedBox(height: 6.h),
            itemCount:
                provider.notificationsUnreadModelObj.readTwoItemList.length,
            itemBuilder: (context, index) {
              ReadTwoItemModel model =
                  provider.notificationsUnreadModelObj.readTwoItemList[index];
              return ReadTwoItemWidget(model);
            },
          );
        },
      ),
    );
  }

  /// "Clear Notifications" button widget
  Widget _buildClear(BuildContext context) {
    return CustomElevatedButton(
      height: 30.h,
      width: 164.h,
      text: "Clear Notifications",
      buttonStyle: CustomButtonStyles.fillBlue,
      buttonTextStyle: CustomTextStyles.bodyLargeOnErrorContainer,
    );
  }
}
