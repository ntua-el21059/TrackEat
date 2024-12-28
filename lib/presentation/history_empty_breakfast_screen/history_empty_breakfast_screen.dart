import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_icon_button.dart';
import 'models/history_empty_breakfast_model.dart';
import 'models/listview_item_model.dart';
import 'provider/history_empty_breakfast_provider.dart';
import 'widgets/listview_item_widget.dart';

class HistoryEmptyBreakfastScreen extends StatefulWidget {
  const HistoryEmptyBreakfastScreen({Key? key}) : super(key: key);

  @override
  HistoryEmptyBreakfastScreenState createState() =>
      HistoryEmptyBreakfastScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HistoryEmptyBreakfastProvider(),
      child: HistoryEmptyBreakfastScreen(),
    );
  }
}

class HistoryEmptyBreakfastScreenState extends State<HistoryEmptyBreakfastScreen> {
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
        child: SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 4.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 4.h),
                  child: Text(
                    "History",
                    style: theme.textTheme.headlineMedium,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "WED, SEPTEMBER 7".toUpperCase(),
                    style: CustomTextStyles.labelLargeBluegray400,
                  ),
                ),
                SizedBox(height: 12.h),
                _buildCalories(context),
                SizedBox(height: 34.h),
                Padding(
                  padding: EdgeInsets.only(left: 18.h),
                  child: Text(
                    "Breakfast",
                    style: CustomTextStyles.headlineSmall_1,
                  ),
                ),
                SizedBox(height: 4.h),
                _buildNologsyet(context),
                SizedBox(height: 24.h),
                Padding(
                  padding: EdgeInsets.only(left: 18.h),
                  child: Text(
                    "Lunch",
                    style: CustomTextStyles.headlineSmall_1,
                  ),
                ),
                SizedBox(height: 6.h),
                _buildColumnlinear(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 36.h,
      leadingWidth: 24.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftPrimary,
        margin: EdgeInsets.only(left: 8.h),
      ),
      title: AppbarSubtitle(
        text: "Home",
        margin: EdgeInsets.only(left: 7.h),
      ),
    );
  }

  Widget _buildCalories(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 18.h),
      decoration: AppDecoration.lightBlueLayoutPadding.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Text(
              "1500 Kcal Remaining...",
              style: CustomTextStyles.titleMediumGray90001Bold,
            ),
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              _buildNutrientInfo(context, "Protein", "78/98", "g"),
              _buildNutrientInfo(context, "Fats", "45/70", "g"),
              _buildNutrientInfo(context, "Carbs", "95/110", "g"),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildNutrientInfo(BuildContext context, String label, String value, String unit) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: CustomTextStyles.bodyLargeBlack90016_2),
          Row(
            children: [
              Text(value, style: CustomTextStyles.titleLargeLimeA700.copyWith(color: appTheme.limeA700)),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(unit, style: CustomTextStyles.titleMediumLimeA700.copyWith(color: appTheme.limeA700)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNologsyet(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 22.h),
      decoration: AppDecoration.outlineBlue.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Column(
        children: [
          Text(
            "You haven’t logged your breakfast yet.",
            style: CustomTextStyles.bodyLargeBlack90016,
          ),
          SizedBox(height: 6.h),
          CustomIconButton(
            height: 48.h,
            width: 48.h,
            child: CustomImageView(
              imagePath: ImageConstant.imgPlusCircle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumnlinear(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.h, vertical: 6.h),
      padding: EdgeInsets.all(8.h),
      decoration: AppDecoration.outlineBlue100.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Consumer<HistoryEmptyBreakfastProvider>(
        builder: (context, provider, child) {
          return Wrap(
            spacing: 16.h,
            children: provider.historyEmptyBreakfastModelObj.listviewItemList
                .map((model) => ListviewItemWidget(model))
                .toList(),
          );
        },
      ),
    );
  }
}
