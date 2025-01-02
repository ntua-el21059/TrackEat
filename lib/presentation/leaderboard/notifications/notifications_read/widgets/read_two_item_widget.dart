import 'package:flutter/material.dart';
import '../../../../../core/app_export.dart';
import '../../../../../theme/custom_button_style.dart';
import '../../../../../widgets/custom_elevated_button.dart';
import '../models/read_two_item_model.dart';

// This widget represents a single notification item in the list
// The must_be_immutable annotation is needed since we'll be modifying the model
// ignore_for_file: must_be_immutable
class ReadTwoItemWidget extends StatelessWidget {
  // Constructor takes a ReadTwoItemModel object to display its data
  ReadTwoItemWidget(this.readTwoItemModelObj, {Key? key})
      : super(
          key: key,
        );

  // The model object containing the notification data to display
  ReadTwoItemModel readTwoItemModelObj;

  @override
  Widget build(BuildContext context) {
    // The root container that wraps the entire notification item
    return Container(
      // Adding symmetric padding for better spacing
      padding: EdgeInsets.symmetric(
        horizontal: 4.h,
        vertical: 8.h,
      ),
      // Applying custom decoration with rounded corners
      decoration: AppDecoration.lightGreyButtonsPadding.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder20,
      ),
      // Row layout to place notification text and action button side by side
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // The notification message text
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                left: 14.h,
                bottom: 4.h,
              ),
              child: Text(
                readTwoItemModelObj.timcookse1nt!,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ),
          // The "Open" button with an icon
          _buildOpen(context)
        ],
      ),
    );
  }

  /// Section Widget for building the "Open" button
  Widget _buildOpen(BuildContext context) {
    return CustomElevatedButton(
      width: 74.h,
      text: "Open",
      // Adding a custom icon to the right of the button text
      rightIcon: Container(
        margin: EdgeInsets.only(left: 4.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgMessagefill1,
          height: 14.h,
          width: 16.h,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
