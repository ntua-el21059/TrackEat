import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../theme/custom_button_style.dart';
import '../../../widgets/custom_outlined_button.dart';
import 'models/blur_choose_action_screen_model.dart';
import 'provider/blur_choose_action_screen_provider.dart';

// ignore_for_file: must_be_immutable
class BlurChooseActionScreenDialog extends StatefulWidget {
  const BlurChooseActionScreenDialog({Key? key}) : super(key: key);

  @override
  BlurChooseActionScreenDialogState createState() => BlurChooseActionScreenDialogState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BlurChooseActionScreenProvider(),
      child: BlurChooseActionScreenDialog(),
    );
  }
}

class BlurChooseActionScreenDialogState extends State<BlurChooseActionScreenDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [_buildRowEdit(context)],
    );
  }

  /// Section Widget
  Widget _buildRowEdit(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 2.h,
        vertical: 8.h,
      ),
      decoration: AppDecoration.outlineBlue100.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 226.h,
              margin: EdgeInsets.only(
                top: 18.h,
                bottom: 12.h,
              ),
              child: Column(
                children: [
                  CustomOutlinedButton(
                    height: 24.h,
                    text: "Edit",
                    buttonTextStyle: CustomTextStyles.bodyLargeGray50003,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    "or",
                    style: CustomTextStyles.bodyLargeBluegray10001,
                  ),
                  SizedBox(height: 12.h),
                  CustomOutlinedButton(
                    height: 24.h,
                    text: "Delete",
                    buttonTextStyle: CustomTextStyles.bodyLargeRedA70001,
                  )
                ],
              ),
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgClose,
            height: 30.h,
            width: 32.h,
            margin: EdgeInsets.only(left: 20.h),
          )
        ],
      ),
    );
  }
}
