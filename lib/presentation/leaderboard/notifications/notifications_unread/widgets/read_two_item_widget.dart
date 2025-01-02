import 'package:flutter/material.dart';
import '../../../../../core/app_export.dart';
import '../models/read_two_item_model.dart';
import '../../../../../theme/custom_text_style.dart';
import '../../../../../widgets/custom_elevated_button.dart';
import '../../../../../theme/custom_button_style.dart';

class ReadTwoItemWidget extends StatelessWidget {
  // The constructor takes a model object that contains the notification data
  ReadTwoItemWidget(this.readTwoItemModelObj, {Key? key})
      : super(
          key: key,
        );

  // This holds the data for the notification being displayed
  final ReadTwoItemModel readTwoItemModelObj;

  @override
  Widget build(BuildContext context) {
    // The root container defines the overall shape and padding of the notification
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 4.h,
        vertical: 8.h,
      ),
      // This gives the notification a light grey background with rounded corners
      decoration: AppDecoration.lightGreyButtonsPadding.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder20,
      ),
      // The Row arranges the notification text and Add button side by side
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // The notification message text
          Padding(
            padding: EdgeInsets.only(left: 10.h),
            child: Text(
              readTwoItemModelObj.miabrooksier!,
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          // The Add button (built by a separate method)
          _buildAdd(context)
        ],
      ),
    );
  }

  Widget _buildAdd(BuildContext context) {
    return CustomElevatedButton(
      height: 24.h,
      width: 60.h,
      text: "Add",
      buttonStyle: CustomButtonStyles.fillPrimary,
      onPressed: () {
        // Add button action here
      },
    );
  }
}
