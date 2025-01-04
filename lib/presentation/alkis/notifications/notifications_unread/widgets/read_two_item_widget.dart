import 'package:flutter/material.dart';
import '../../../../../core/app_export.dart';
import '../models/read_two_item_model.dart';
import '../../../../../theme/custom_text_style.dart';
import '../../../../../widgets/custom_elevated_button.dart';
import '../../../../../theme/custom_button_style.dart';

class ReadTwoItemWidget extends StatelessWidget {
  ReadTwoItemWidget(this.readTwoItemModelObj, {Key? key})
      : super(
          key: key,
        );

  final ReadTwoItemModel readTwoItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.h),
      padding: EdgeInsets.all(8.h),
      decoration: AppDecoration.lightGreyButtonsPadding.copyWith(
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
                readTwoItemModelObj.miabrooksier!,
                style: CustomTextStyles.titleSmallBold,
              ),
            ),
          ),
          _buildAdd(context),
        ],
      ),
    );
  }

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
}
