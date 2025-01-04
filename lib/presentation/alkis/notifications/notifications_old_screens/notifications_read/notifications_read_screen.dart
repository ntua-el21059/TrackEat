import 'package:flutter/material.dart';
import '../../../../../../core/app_export.dart';
import '../../../../../../theme/custom_button_style.dart';
import '../../../../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../../../../widgets/app_bar/appbar_subtitle.dart';
import '../../../../../../widgets/app_bar/custom_app_bar.dart';
import '../../../../../../widgets/custom_elevated_button.dart';
import '../../../../../../widgets/custom_text_form_field.dart';
import 'models/notifications_read_model.dart';
import 'models/read_two_item_model.dart';
import 'provider/notifications_read_provider.dart';
import 'widgets/read_two_item_widget.dart';

// The main screen widget for displaying notifications
class NotificationsReadScreen extends StatefulWidget {
  const NotificationsReadScreen({Key? key})
      : super(
          key: key,
        );

  @override
  NotificationsReadScreenState createState() => NotificationsReadScreenState();

  // Builder method that sets up the ChangeNotifierProvider
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NotificationsReadProvider(),
      child: NotificationsReadScreen(),
    );
  }
}

// The state class for the notifications screen
class NotificationsReadScreenState extends State<NotificationsReadScreen> {
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
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(horizontal: 6.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title section
                  Padding(
                    padding: EdgeInsets.only(left: 10.h),
                    child: Text(
                      "Notifications",
                      style: theme.textTheme.displaySmall,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Unread notifications section
                  Padding(
                    padding: EdgeInsets.only(left: 10.h),
                    child: Text(
                      "UNREAD".toUpperCase(),
                      style: CustomTextStyles.labelLargeBluegray400,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // "All caught up" message
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "You are all caught up!",
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Read notifications section
                  Padding(
                    padding: EdgeInsets.only(left: 14.h),
                    child: Text(
                      "READ".toUpperCase(),
                      style: CustomTextStyles.labelLargeBluegray400,
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // Stack of notification items
                  _buildStackfirstone(context),
                  SizedBox(height: 6.h),
                  SizedBox(
                    height: 442.h,
                    width: double.maxFinite,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        _buildStackfirst(context),
                        _buildReadtwo(context)
                      ],
                    ),
                  ),

                  // Clear notifications button at the bottom
                  SizedBox(height: 14.h),
                  _buildClear(context),
                  SizedBox(height: 50.h)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 20.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftPrimary,
        margin: EdgeInsets.only(left: 4.h),
      ),
      title: AppbarSubtitle(
        text: "Notifications",
        margin: EdgeInsets.only(left: 7.h),
      ),
    );
  }

  Widget _buildStackfirstone(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 12.h,
      ),
      decoration: AppDecoration.lightBlueLayoutPadding.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Consumer<NotificationsReadProvider>(
        builder: (context, provider, child) {
          return ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) => SizedBox(height: 8.h),
            itemCount:
                provider.notificationsReadModelObj.readTwoItemList.length,
            itemBuilder: (context, index) {
              ReadTwoItemModel model =
                  provider.notificationsReadModelObj.readTwoItemList[index];
              return ReadTwoItemWidget(model);
            },
          );
        },
      ),
    );
  }

  Widget _buildStackfirst(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 12.h,
      ),
      decoration: AppDecoration.lightBlueLayoutPadding.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Consumer<NotificationsReadProvider>(
        builder: (context, provider, child) {
          return ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) => SizedBox(height: 8.h),
            itemCount:
                provider.notificationsReadModelObj.readTwoItemList.length,
            itemBuilder: (context, index) {
              ReadTwoItemModel model =
                  provider.notificationsReadModelObj.readTwoItemList[index];
              return ReadTwoItemWidget(model);
            },
          );
        },
      ),
    );
  }

  Widget _buildReadtwo(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 12.h,
      ),
      decoration: AppDecoration.lightBlueLayoutPadding.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Consumer<NotificationsReadProvider>(
        builder: (context, provider, child) {
          return ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) => SizedBox(height: 8.h),
            itemCount:
                provider.notificationsReadModelObj.readTwoItemList.length,
            itemBuilder: (context, index) {
              ReadTwoItemModel model =
                  provider.notificationsReadModelObj.readTwoItemList[index];
              return ReadTwoItemWidget(model);
            },
          );
        },
      ),
    );
  }

  Widget _buildClear(BuildContext context) {
    return CustomElevatedButton(
      text: "Clear all notifications",
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      buttonStyle: CustomButtonStyles.fillGray,
      onPressed: () {
        // Add clear notifications logic here
      },
    );
  }
}
