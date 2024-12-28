import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../theme/custom_button_style.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_outlined_button.dart';
import 'models/blur_edit_item_model.dart';
import 'models/blur_edit_screen_model.dart';
import 'provider/blur_edit_screen_provider.dart';
import 'widgets/blur_edit_item_widget.dart';

// ignore_for_file: must_be_immutable
class BlurEditScreenDialog extends StatefulWidget {
  const BlurEditScreenDialog({Key? key}) : super(key: key);

  @override
  BlurEditScreenDialogState createState() => BlurEditScreenDialogState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BlurEditScreenProvider(),
      child: BlurEditScreenDialog(),
    );
  }
}

class BlurEditScreenDialogState extends State<BlurEditScreenDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [_buildRowveganbacon(context)],
    );
  }

  /// Section Widget
  Widget _buildChangeportion(BuildContext context) {
    return CustomOutlinedButton(
      height: 24.h,
      width: 226.h,
      text: "Change portion size",
      margin: EdgeInsets.only(right: 20.h),
      buttonTextStyle: CustomTextStyles.bodyLargeGray50003,
    );
  }

  /// Section Widget
  Widget _buildEditcalories(BuildContext context) {
    return CustomOutlinedButton(
      height: 24.h,
      width: 226.h,
      text: "Edit calories",
      margin: EdgeInsets.only(right: 20.h),
      buttonTextStyle: CustomTextStyles.bodyLargeGray50003,
    );
  }

  /// Section Widget
  Widget _buildEditprotein(BuildContext context) {
    return CustomOutlinedButton(
      height: 24.h,
      width: 226.h,
      text: "Edit Protein content",
      margin: EdgeInsets.only(right: 20.h),
      buttonTextStyle: CustomTextStyles.bodyLargeGray50003,
    );
  }

  /// Section Widget
  Widget _buildEditfat(BuildContext context) {
    return CustomOutlinedButton(
      height: 24.h,
      width: 226.h,
      text: "Edit Fat content",
      margin: EdgeInsets.only(right: 20.h),
      buttonTextStyle: CustomTextStyles.bodyLargeGray50003,
    );
  }

  /// Section Widget
  Widget _buildEditcarb(BuildContext context) {
    return CustomOutlinedButton(
      height: 24.h,
      width: 226.h,
      text: "Edit Carb content",
      margin: EdgeInsets.only(right: 20.h),
      buttonTextStyle: CustomTextStyles.bodyLargeGray50003,
    );
  }

  /// Section Widget
  Widget _buildSaveandexit(BuildContext context) {
    return CustomElevatedButton(
      height: 30.h,
      width: 118.h,
      text: "Save and Exit",
      margin: EdgeInsets.only(right: 72.h),
      buttonStyle: CustomButtonStyles.fillPrimaryTL14,
      buttonTextStyle: CustomTextStyles.labelLargeMedium,
    );
  }

  /// Section Widget
  Widget _buildRowveganbacon(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 10.h),
                      child: Text(
                        "Vegan bacon cheeseburger",
                        style: CustomTextStyles.titleMediumBlack900,
                      ),
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      child: Row(
                        children: [
                          CustomImageView(
                            imagePath: ImageConstant.imgDownload1,
                            height: 20.h,
                            width: 20.h,
                          ),
                          Text(
                            "69 kcal -100g",
                            style: theme.textTheme.bodySmall,
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 22.h),
                    Container(
                      margin: EdgeInsets.only(left: 18.h),
                      width: double.maxFinite,
                      child: Consumer<BlurEditScreenProvider>(
                        builder: (context, provider, child) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Wrap(
                              direction: Axis.horizontal,
                              spacing: 62.h,
                              children: List.generate(
                                provider.blurEditScreenModelObj.blurEditItemList
                                    .length,
                                (index) {
                                  BlurEditItemModel model = provider
                                      .blurEditScreenModelObj
                                      .blurEditItemList[index];
                                  return BlurEditItemWidget(
                                    model,
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _buildChangeportion(context),
                    SizedBox(height: 12.h),
                    _buildEditcalories(context),
                    SizedBox(height: 12.h),
                    _buildEditprotein(context),
                    SizedBox(height: 12.h),
                    _buildEditfat(context),
                    SizedBox(height: 12.h),
                    _buildEditcarb(context),
                    SizedBox(height: 18.h),
                    _buildSaveandexit(context)
                  ],
                ),
              ),
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgClose,
            height: 30.h,
            width: 32.h,
          )
        ],
      ),
    );
  }
}
