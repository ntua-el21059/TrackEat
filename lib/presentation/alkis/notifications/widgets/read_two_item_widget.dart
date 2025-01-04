import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/app_export.dart';
import '../../../../theme/custom_text_style.dart';
import '../../../../widgets/custom_elevated_button.dart';
import '../../../../theme/custom_button_style.dart';
import '../models/notifications_model.dart';

class ReadTwoItemWidget extends StatelessWidget {
  ReadTwoItemWidget(this.notification, {Key? key}) : super(key: key);

  final NotificationItem notification;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.h),
      padding: EdgeInsets.all(8.h),
      decoration: (notification.isRead
              ? AppDecoration.lightGreyButtonsPadding
              : AppDecoration.lightBlueLayoutPadding)
          .copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder20,
      ),
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 4.h),
              child: Text(
                notification.message,
                style: CustomTextStyles.titleSmallBold,
              ),
            ),
          ),
          _buildButton(context),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    final message = notification.message.toLowerCase();

    if (message.contains("added you")) {
      return CustomElevatedButton(
        width: 74.h,
        text: "Add",
        rightIcon: Container(
          margin: EdgeInsets.only(left: 6.h),
          child: SvgPicture.asset(
            "assets/images/add_friends.svg",
            height: 20.h,
            width: 20.h,
            fit: BoxFit.contain,
          ),
        ),
        buttonStyle: CustomButtonStyles.fillBlue,
      );
    } else if (message.contains("sent a message")) {
      return CustomElevatedButton(
        width: 74.h,
        text: "Open",
        rightIcon: Container(
          margin: EdgeInsets.only(left: 4.h),
          child: SvgPicture.asset(
            "assets/images/message_bubble.svg",
            height: 14.h,
            width: 16.h,
            fit: BoxFit.contain,
          ),
        ),
        buttonStyle: CustomButtonStyles.fillBlue,
      );
    } else {
      return CustomElevatedButton(
        width: 74.h,
        text: "View",
        rightIcon: Container(
          margin: EdgeInsets.only(left: 4.h),
          child: SvgPicture.asset(
            "assets/images/imgArrowRight.svg",
            height: 16.h,
            width: 12.h,
            fit: BoxFit.contain,
          ),
        ),
        buttonStyle: CustomButtonStyles.fillBlue,
      );
    }
  }
}
