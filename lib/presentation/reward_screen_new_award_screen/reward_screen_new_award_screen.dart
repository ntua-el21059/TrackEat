import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'models/reward_screen_new_award_model.dart';
import 'provider/reward_screen_new_award_provider.dart';

class RewardScreenNewAwardScreen extends StatefulWidget {
  const RewardScreenNewAwardScreen({Key? key}) : super(key: key);

  @override
  RewardScreenNewAwardScreenState createState() =>
      RewardScreenNewAwardScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RewardScreenNewAwardProvider(),
      child: const RewardScreenNewAwardScreen(),
    );
  }
}

class RewardScreenNewAwardScreenState
    extends State<RewardScreenNewAwardScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.onErrorContainer,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: 860.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: _buildTopContent(context),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildBottomContent(context),
                ),
                _buildColumnArrowDown(context),
                _buildCenterContent(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopContent(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 24.h),
              child: Text(
                "Congratulations!",
                style: theme.textTheme.displayMedium,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 174.h),
              child: Text(
                "New award unlocked!",
                style: CustomTextStyles.headlineSmallSFPro,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomContent(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomImageView(
              imagePath: ImageConstant.imgClose,
              height: 38.h,
              width: 42.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColumnArrowDown(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.only(bottom: 126.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomImageView(
              imagePath: ImageConstant.imgArrowDown,
              height: 12.h,
              width: 14.h,
              margin: EdgeInsets.only(right: 52.h),
            ),
            SizedBox(height: 58.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 12.h,
                  width: 12.h,
                  decoration: BoxDecoration(
                    color: appTheme.lightBlue600,
                    borderRadius: BorderRadius.circular(6.h),
                  ),
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgTelevisionBlue10012x14,
                  height: 12.h,
                  width: 14.h,
                  margin: EdgeInsets.only(left: 110.h),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildRowSettings(context),
        _buildRowStarOne(context),
        _buildRowThumbsUp(context),
      ],
    );
  }

  Widget _buildRowSettings(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 288.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgSettingsBlue10022x20,
            height: 22.h,
            width: 20.h,
          ),
          SizedBox(width: 20.h),
          Container(
            width: 20.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowStarOne(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 262.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10.h,
            decoration: BoxDecoration(
              color: appTheme.lightBlue600,
            ),
          ),
          Spacer(),
          CustomImageView(
            imagePath: ImageConstant.imgTelevisionBlue10018x20,
            height: 18.h,
            width: 22.h,
          ),
          Spacer(),
          CustomImageView(
            imagePath: ImageConstant.imgTelevisionLightBlue600,
            height: 14.h,
            width: 14.h,
          ),
        ],
      ),
    );
  }

  Widget _buildRowThumbsUp(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 34.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgThumbsUpBlue1008x8,
            height: 8.h,
            width: 10.h,
          ),
          Spacer(),
          Container(
            height: 6.h,
            width: 6.h,
            decoration: BoxDecoration(
              color: appTheme.lightBlue600,
              borderRadius: BorderRadius.circular(3.h),
            ),
          ),
        ],
      ),
    );
  }
}
