import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'models/reward_screen_rings_closed_model.dart';
import 'provider/reward_screen_rings_closed_provider.dart';

class RewardScreenRingsClosedScreen extends StatefulWidget {
  const RewardScreenRingsClosedScreen({Key? key}) : super(key: key);

  @override
  RewardScreenRingsClosedScreenState createState() =>
      RewardScreenRingsClosedScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RewardScreenRingsClosedProvider(),
      child: RewardScreenRingsClosedScreen(),
    );
  }
}

class RewardScreenRingsClosedScreenState
    extends State<RewardScreenRingsClosedScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.onErrorContainer,
      body: SafeArea(
        child: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Container(
              height: 860.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: 2.h,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              width: 134.h,
                              margin: EdgeInsets.only(top: 210.h),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 8.h),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomImageView(
                                          imagePath:
                                              ImageConstant.imgUserBlue100,
                                          height: 12.h,
                                          width: 14.h,
                                        ),
                                        SizedBox(height: 2.h),
                                        CustomImageView(
                                          imagePath:
                                              ImageConstant.imgSettingsBlue100,
                                          height: 12.h,
                                          width: 14.h,
                                        ),
                                        SizedBox(height: 2.h),
                                        CustomImageView(
                                          imagePath:
                                              ImageConstant.imgSettingsBlue100,
                                          height: 20.h,
                                          width: 22.h,
                                          margin: EdgeInsets.only(left: 4.h),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Container(
                                        width: double.maxFinite,
                                        padding: EdgeInsets.only(left: 6.h),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomImageView(
                                              imagePath: ImageConstant
                                                  .imgThumbsUpLightBlue600,
                                              height: 16.h,
                                              width: 18.h,
                                              margin: EdgeInsets.only(left: 8.h),
                                            ),
                                            SizedBox(height: 2.h),
                                            CustomImageView(
                                              imagePath: ImageConstant
                                                  .imgTelevisionBlue100,
                                              height: 14.h,
                                              width: 18.h,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
               Align(
  alignment: Alignment.bottomCenter,
  child: SizedBox(
    width: double.maxFinite,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [_buildRowsettings(context)],
    ),
  ),
),
Align(
  alignment: Alignment.topCenter,
  child: SizedBox(
    width: double.maxFinite,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [_buildRowstarone(context)],
    ),
  ),
),
_buildColumnarrowdown(context),
CustomImageView(
  imagePath: ImageConstant.imgRectangle,
  height: 8.h,
  width: 8.h,
  alignment: Alignment.topRight,
  margin: EdgeInsets.only(
    top: 184.h,
    right: 20.h,
  ),
),
CustomImageView(
  imagePath: ImageConstant.imgTelevisionLightBlue6008x14,
  height: 8.h,
  width: 16.h,
  alignment: Alignment.topLeft,
  margin: EdgeInsets.only(top: 60.h),
),
Align(
  alignment: Alignment.bottomCenter,
  child: SizedBox(
    width: 2.h,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 230.h,
            margin: EdgeInsets.only(bottom: 334.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgThumbsUpLightBlue6006x10,
                  height: 6.h,
                  width: 10.h,
                  alignment: Alignment.topCenter,
                ),
                Container(
                  width: 14.h,
                  margin: EdgeInsets.only(
                    left: 46.h,
                    bottom: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: appTheme.lightBlue600,
                  ),
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgThumbsUpLightBlue60022x22,
                  height: 22.h,
                  width: 22.h,
                  margin: EdgeInsets.only(
                    left: 54.h,
                    top: 2.h,
                  ),
                )
              ],
            ),
          ),
        )
      ],
    ),
  ),
),
CustomImageView(
  imagePath: ImageConstant.imgThumbsUpBlue100,
  height: 10.h,
  width: 12.h,
  alignment: Alignment.bottomRight,
  margin: EdgeInsets.only(
    right: 30.h,
    bottom: 36.h,
  ),
),
Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    SizedBox(
      width: 274.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgThumbsUpBlue10010x10,
            height: 10.h,
            width: 12.h,
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(left: 34.h),
          ),
          Container(
            height: 12.h,
            width: 12.h,
            margin: EdgeInsets.only(bottom: 4.h),
            decoration: BoxDecoration(
              color: appTheme.blue100,
              borderRadius: BorderRadius.circular(
                6.h,
              ),
            ),
          )
        ],
      ),
    )
  ],
),
_buildColumnviewtwo(context),
Align(
  alignment: Alignment.bottomCenter,
  child: Padding(
    padding: EdgeInsets.only(bottom: 326.h),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          height: 6.h,
          width: 6.h,
          margin: EdgeInsets.only(right: 2.h),
          decoration: BoxDecoration(
            color: appTheme.lightBlue600,
            borderRadius: BorderRadius.circular(
              3.h,
            ),
          ),
        ),
        SizedBox(height: 2.h),
        CustomImageView(
          imagePath: ImageConstant.imgTelevisionBlue1008x14,
          height: 8.h,
          width: 16.h,
        )
      ],
    ),
  ),
),
Align(
  alignment: Alignment.bottomCenter,
  child: SizedBox(
    width: double.maxFinite,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [_buildRowthumbsup(context)],
    ),
  ),
),
CustomImageView(
  imagePath: ImageConstant.imgThumbsUpLightBlue60014x10,
  height: 14.h,
  width: 12.h,
  alignment: Alignment.bottomLeft,
  margin: EdgeInsets.only(
    left: 166.h,
    bottom: 308.h,
  ),
),
Align(
  alignment: Alignment.bottomCenter,
  child: SizedBox(
    width: double.maxFinite,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [_buildRowthumbsup1(context)],
    ),
  ),
),
CustomImageView(
  imagePath: ImageConstant.imgSettingsPrimary,
  height: 16.h,
  width: 10.h,
  alignment: Alignment.bottomRight,
  margin: EdgeInsets.only(
    right: 32.h,
    bottom: 242.h,
  ),
),
CustomImageView(
  imagePath: ImageConstant.imgTelevisionLightBlue6008x18,
  height: 8.h,
  width: 20.h,
  alignment: Alignment.topLeft,
  margin: EdgeInsets.only(top: 334.h),
),
Align(
  alignment: Alignment.topCenter,
  child: SizedBox(
    width: double.maxFinite,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [_buildRowthumbsup2(context)],
    ),
  ),
),
Align(
  alignment: Alignment.topCenter,
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(top: 24.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 10.h,
                width: 10.h,
                margin: EdgeInsets.only(bottom: 2.h),
                decoration: BoxDecoration(
                  color: appTheme.blue100,
                  borderRadius: BorderRadius.circular(
                    4.h,
                  ),
                ),
              ),
              CustomImageView(
                imagePath: ImageConstant.imgTelevisionBlue1006x16,
                height: 6.h,
                width: 16.h,
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(left: 4.h),
              )
            ],
          ),
        ),
      )
    ],
  ),
),
Align(
  alignment: Alignment.bottomRight,
  child: Container(
    width: 52.h,
    margin: EdgeInsets.only(
      right: 124.h,
      bottom: 218.h,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomImageView(
          imagePath: ImageConstant.imgRectangleBlue10016x16,
          height: 16.h,
          width: 18.h,
        ),
        SizedBox(height: 4.h),
        SizedBox(
          width: double.maxFinite,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 4.h,
                  width: 4.h,
                  decoration: BoxDecoration(
                    color: appTheme.blue100,
                    borderRadius: BorderRadius.circular(
                      2.h,
                    ),
                  ),
                ),
              ),
              Container(
                height: 6.h,
                width: 6.h,
                decoration: BoxDecoration(
                  color: appTheme.lightBlue600,
                  borderRadius: BorderRadius.circular(
                    3.h,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    ),
  ),
),
Align(
  alignment: Alignment.topCenter,
  child: SizedBox(
    width: double.maxFinite,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [_buildRowspacerten(context)],
    ),
  ),
),
CustomImageView(
  imagePath: ImageConstant.imgRectangleBlue10018x3,
  height: 18.h,
  width: 5.h,
  alignment: Alignment.bottomLeft,
  margin: EdgeInsets.only(bottom: 22.h),
),
Align(
  alignment: Alignment.topCenter,
  child: SizedBox(
    width: double.maxFinite,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [_buildRowviewtwelve(context)],
    ),
  ),
),
Align(
  alignment: Alignment.topLeft,
  child: Container(
    height: 10.h,
    width: 10.h,
    margin: EdgeInsets.only(
      left: 94.h,
      top: 84.h,
    ),
    decoration: BoxDecoration(
      color: appTheme.blue100,
      borderRadius: BorderRadius.circular(
        4.h,
      ),
    ),
  ),
),
Align(
  alignment: Alignment.topRight,
  child: Container(
    height: 10.h,
    width: 10.h,
    margin: EdgeInsets.only(
      top: 170.h,
      right: 172.h,
    ),
    decoration: BoxDecoration(
      color: appTheme.lightBlue600,
      borderRadius: BorderRadius.circular(
        4.h,
      ),
    ),
  ),
),
Align(
  alignment: Alignment.topCenter,
  child: SizedBox(
    width: 2.h,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: 280.h,
            margin: EdgeInsets.only(top: 96.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 18.h,
                  margin: EdgeInsets.only(top: 6.h),
                  decoration: BoxDecoration(
                    color: appTheme.lightBlue600,
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 8.h,
                    width: 8.h,
                    margin: EdgeInsets.only(left: 62.h),
                    decoration: BoxDecoration(
                      color: appTheme.blue100,
                      borderRadius: BorderRadius.circular(
                        4.h,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 6.h,
                  width: 6.h,
                  margin: EdgeInsets.only(
                    left: 4.h,
                    bottom: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: appTheme.blue100,
                    borderRadius: BorderRadius.circular(
                      3.h,
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    ),
  ),
),
Align(
  alignment: Alignment.topLeft,
  child: Container(
    height: 10.h,
    width: 10.h,
    margin: EdgeInsets.only(
      left: 118.h,
      top: 62.h,
    ),
    decoration: BoxDecoration(
      color: appTheme.blue100,
      borderRadius: BorderRadius.circular(
        4.h,
      ),
    ),
  ),
),
Align(
  alignment: Alignment.topCenter,
  child: Container(
    width: 310.h,
    margin: EdgeInsets.only(top: 326.h),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: double.maxFinite,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(),
              Container(
                height: 6.h,
                width: 6.h,
                margin: EdgeInsets.only(top: 4.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(
                    3.h,
                  ),
                ),
              ),
              CustomImageView(
                imagePath: ImageConstant.imgArrowLeftBlue100,
                height: 8.h,
                width: 10.h,
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(left: 26.h),
              ),
              Container(
                width: 14.h,
                margin: EdgeInsets.only(
                  left: 8.h,
                  bottom: 4.h,
                ),
                decoration: BoxDecoration(
                  color: appTheme.blue100,
                ),
              )
            ],
          ),
        ),
        Container(
          height: 6.h,
          width: 6.h,
          margin: EdgeInsets.only(right: 14.h),
          decoration: BoxDecoration(
            color: appTheme.blue100,
            borderRadius: BorderRadius.circular(
              3.h,
            ),
          ),
        )
      ],
    ),
  ),
),
Align(
  alignment: Alignment.bottomRight,
  child: Container(
    height: 6.h,
    width: 6.h,
    margin: EdgeInsets.only(
      right: 28.h,
      bottom: 244.h,
    ),
    decoration: BoxDecoration(
      color: appTheme.lightBlue600,
      borderRadius: BorderRadius.circular(
        3.h,
      ),
    ),
  ),
),
Align(
  alignment: Alignment.topRight,
  child: Container(
    height: 10.h,
    width: 10.h,
    margin: EdgeInsets.only(
      top: 238.h,
      right: 122.h,
    ),
    decoration: BoxDecoration(
      color: appTheme.blue100,
      borderRadius: BorderRadius.circular(
        4.h,
      ),
    ),
  ),
),
Align(
  alignment: Alignment.topRight,
  child: Container(
    height: 6.h,
    width: 6.h,
    margin: EdgeInsets.only(
      top: 246.h,
      right: 126.h,
    ),
    decoration: BoxDecoration(
      color: appTheme.blue100,
      borderRadius: BorderRadius.circular(
        3.h,
      ),
    ),
  ),
),
Align(
  alignment: Alignment.bottomLeft,
  child: Container(
    height: 12.h,
    width: 12.h,
    margin: EdgeInsets.only(
      left: 42.h,
      bottom: 294.h,
    ),
    decoration: BoxDecoration(
      color: appTheme.lightBlue600,
      borderRadius: BorderRadius.circular(
        6.h,
      ),
    ),
  ),
),
Align(
  alignment: Alignment.bottomLeft,
  child: Container(
    height: 8.h,
    width: 8.h,
    margin: EdgeInsets.only(
      left: 164.h,
      bottom: 322.h,
    ),
    decoration: BoxDecoration(
      color: appTheme.blue100,
      borderRadius: BorderRadius.circular(
        4.h,
      ),
    ),
  ),
),
Align(
  alignment: Alignment.topLeft,
  child: Padding(
    padding: EdgeInsets.only(
      left: 14.h,
      top: 144.h,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 10.h,
          width: 10.h,
          margin: EdgeInsets.only(right: 2.h),
          decoration: BoxDecoration(
            color: appTheme.lightBlue600,
            borderRadius: BorderRadius.circular(
              4.h,
            ),
          ),
        ),
SizedBox(height: 32.h),
Align(
  alignment: Alignment.centerRight,
  child: Container(
    height: 4.h,
    width: 4.h,
    decoration: BoxDecoration(
      color: appTheme.lightBlue600,
      borderRadius: BorderRadius.circular(
        2.h,
      ),
    ),
  ),
),
Align(
  alignment: Alignment.bottomRight,
  child: Container(
    height: 6.h,
    width: 6.h,
    margin: EdgeInsets.only(
      right: 100.h,
      bottom: 2.h,
    ),
    decoration: BoxDecoration(
      color: appTheme.blue100,
      borderRadius: BorderRadius.circular(
        3.h,
      ),
    ),
  ),
),
CustomImageView(
  imagePath: ImageConstant.imgRectangleBlue100,
  height: 12.h,
  width: 14.h,
  alignment: Alignment.topRight,
  margin: EdgeInsets.only(
    top: 324.h,
    right: 4.h,
  ),
),
CustomImageView(
  imagePath: ImageConstant.imgThumbsUp1,
  height: 10.h,
  width: 12.h,
  alignment: Alignment.topRight,
  margin: EdgeInsets.only(
    top: 230.h,
    right: 96.h,
  ),
),
CustomImageView(
  imagePath: ImageConstant.imgPolygonLightBlue600,
  height: 12.h,
  width: 10.h,
  alignment: Alignment.centerRight,
),
CustomImageView(
  imagePath: ImageConstant.imgThumbsUpLightBlue60020x20,
  height: 20.h,
  width: 22.h,
  alignment: Alignment.bottomLeft,
  margin: EdgeInsets.only(
    left: 32.h,
    bottom: 194.h,
  ),
),
CustomImageView(
  imagePath: ImageConstant.imgUpload,
  height: 14.h,
  width: 16.h,
  alignment: Alignment.centerRight,
  margin: EdgeInsets.only(right: 72.h),
),
CustomImageView(
  imagePath: ImageConstant.imgPolygon,
  height: 12.h,
  width: 14.h,
  alignment: Alignment.topLeft,
  margin: EdgeInsets.only(
    left: 56.h,
    top: 220.h,
  ),
),
CustomImageView(
  imagePath: ImageConstant.imgUserBlue10020x20,
  height: 20.h,
  width: 22.h,
  alignment: Alignment.centerRight,
  margin: EdgeInsets.only(right: 88.h),
),
CustomImageView(
  imagePath: ImageConstant.imgUser20x20,
  height: 20.h,
  width: 22.h,
  alignment: Alignment.topLeft,
  margin: EdgeInsets.only(
    left: 106.h,
    top: 44.h,
  ),
),
CustomImageView(
  imagePath: ImageConstant.imgThumbsUp2,
  height: 10.h,
  width: 12.h,
  alignment: Alignment.topRight,
  margin: EdgeInsets.only(
    top: 132.h,
    right: 114.h,
  ),
),
CustomImageView(
  imagePath: ImageConstant.imgThumbsUpBlue10012x12,
  height: 12.h,
  width: 14.h,
  alignment: Alignment.bottomLeft,
  margin: EdgeInsets.only(
    left: 18.h,
    bottom: 186.h,
  ),
),
CustomImageView(
  imagePath: ImageConstant.imgContrast,
  height: 14.h,
  width: 16.h,
  alignment: Alignment.topLeft,
  margin: EdgeInsets.only(
    left: 44.h,
    top: 130.h,
  ),
),
CustomImageView(
  imagePath: ImageConstant.imgArrowUp,
  height: 14.h,
  width: 16.h,
  alignment: Alignment.topRight,
  margin: EdgeInsets.only(
    top: 184.h,
    right: 160.h,
  ),
),
Align(
  alignment: Alignment.bottomCenter,
  child: SizedBox(
    width: double.maxFinite,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [_buildRowstarnine(context)],
    ),
  ),
),
Align(
  alignment: Alignment.topLeft,
  child: Container(
    width: 12.h,
    margin: EdgeInsets.only(
      left: 170.h,
      top: 82.h,
    ),
    decoration: BoxDecoration(
      color: appTheme.blue100,
    ),
  ),
),
Align(
  alignment: Alignment.topLeft,
  child: Container(
    width: 20.h,
    margin: EdgeInsets.only(
      left: 44.h,
      top: 94.h,
    ),
    decoration: BoxDecoration(
      color: appTheme.blue100,
    ),
  ),
),

Align(
  alignment: Alignment.bottomLeft,
  child: Container(
    width: 20.h,
    margin: EdgeInsets.only(left: 162.h),
    decoration: BoxDecoration(
      color: appTheme.blue100,
    ),
  ),
),
Align(
  alignment: Alignment.bottomCenter,
  child: Container(
    width: 10.h,
    margin: EdgeInsets.only(bottom: 194.h),
    decoration: BoxDecoration(
      color: appTheme.blue100,
    ),
  ),
),
Align(
  alignment: Alignment.bottomLeft,
  child: Container(
    width: 16.h,
    margin: EdgeInsets.only(
      left: 40.h,
      bottom: 190.h,
    ),
    decoration: BoxDecoration(
      color: appTheme.lightBlue600,
    ),
  ),
),
Align(
  alignment: Alignment.bottomCenter,
  child: Container(
    width: 8.h,
    margin: EdgeInsets.only(bottom: 200.h),
    decoration: BoxDecoration(
      color: appTheme.blue100,
    ),
  ),
),
Align(
  alignment: Alignment.centerRight,
  child: Container(
    width: 20.h,
    margin: EdgeInsets.only(right: 80.h),
    decoration: BoxDecoration(
      color: appTheme.lightBlue600,
    ),
  ),
),
Align(
  alignment: Alignment.topLeft,
  child: Container(
    width: 18.h,
    margin: EdgeInsets.only(
      left: 88.h,
      top: 32.h,
    ),
    decoration: BoxDecoration(
      color: appTheme.lightBlue600,
    ),
  ),
),
Align(
  alignment: Alignment.topRight,
  child: Container(
    width: 12.h,
    margin: EdgeInsets.only(
      top: 334.h,
      right: 4.h,
    ),
    decoration: BoxDecoration(
      color: appTheme.lightBlue600,
    ),
  ),
),
Container(
  width: 14.h,
  decoration: BoxDecoration(
    color: appTheme.lightBlue600,
  ),
),
Align(
  alignment: Alignment.bottomCenter,
  child: Container(
    width: 12.h,
    margin: EdgeInsets.only(bottom: 270.h),
    decoration: BoxDecoration(
      color: appTheme.lightBlue600,
    ),
  ),
),
Align(
  alignment: Alignment.topCenter,
  child: Container(
    width: 10.h,
    margin: EdgeInsets.only(top: 124.h),
    decoration: BoxDecoration(
      color: appTheme.blue100,
    ),
  ),
),
Align(
  alignment: Alignment.topLeft,
  child: Container(
    width: 18.h,
    margin: EdgeInsets.only(
      left: 74.h,
      top: 92.h,
    ),
    decoration: BoxDecoration(
      color: appTheme.lightBlue600,
    ),
  ),
),
Align(
  alignment: Alignment.topLeft,
  child: Container(
    width: 14.h,
    margin: EdgeInsets.only(
      left: 50.h,
      top: 218.h,
    ),
    decoration: BoxDecoration(
      color: appTheme.blue100,
    ),
  ),
),
Align(
  alignment: Alignment.bottomRight,
  child: Container(
    width: 18.h,
    margin: EdgeInsets.only(
      right: 24.h,
      bottom: 40.h,
    ),
    decoration: BoxDecoration(
      color: appTheme.lightBlue600,
    ),
  ),
),
Align(
  alignment: Alignment.topCenter,
  child: Padding(
    padding: EdgeInsets.only(top: 134.h),
    child: Text(
      "Congratulations!",
      style: theme.textTheme.displayMedium,
    ),
  ),
),
Align(
  alignment: Alignment.topCenter,
  child: Padding(
    padding: EdgeInsets.only(top: 182.h),
    child: Text(
      "You closed your rings!",
      style: CustomTextStyles.headlineSmallSFPro,
    ),
  ),
),
Container(
  width: double.maxFinite,
  padding: EdgeInsets.only(
    top: 54.h,
    right: 16.h,
  ),
  decoration: AppDecoration.column32,
  child: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      CustomImageView(
        imagePath: ImageConstant.imgClose,
        height: 38.h,
        width: 42.h,
      ),
      SizedBox(height: 702.h),
    ],
  ),
),
],
),
),
),
),
),
);
  }
  ```dart
/// Section Widget
Widget _buildColumnarrowdown(BuildContext context) {
  return Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(
        left: 20.h,
        right: 20.h,
        bottom: 126.h,
      ),
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
          SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 12.h,
                  width: 12.h,
                  decoration: BoxDecoration(
                    color: appTheme.lightBlue600,
                    borderRadius: BorderRadius.circular(
                      6.h,
                    ),
                  ),
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgTelevisionBlue10012x14,
                  height: 12.h,
                  width: 14.h,
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(left: 110.h),
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}

/// Section Widget
Widget _buildColumnviewtwo(BuildContext context) {
  return Align(
    alignment: Alignment.topCenter,
    child: Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(
        left: 4.h,
        top: 254.h,
        right: 4.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 180.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 20.h,
                  width: 30.h,
                  margin: EdgeInsets.only(bottom: 8.h),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.imgRectangleBlue100,
                        height: 20.h,
                        width: double.maxFinite,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          height: 8.h,
                          width: 8.h,
                          margin: EdgeInsets.only(top: 2.h),
                          decoration: BoxDecoration(
                            color: appTheme.lightBlue600,
                            borderRadius: BorderRadius.circular(
                              4.h,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgClosePrimary,
                  height: 18.h,
                  width: 18.h,
                  alignment: Alignment.bottomCenter,
                )
              ],
            ),
          ),
          SizedBox(height: 8.h),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgTelevisionBlue10010x10,
                  height: 10.h,
                  width: 10.h,
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgTelevisionBlue10018x18,
                  height: 18.h,
                  width: 18.h,
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(
                    left: 86.h,
                    top: 2.h,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}
/// Section Widget
Widget _buildRowthumbsup(BuildContext context) {
  return SizedBox(
    width: double.maxFinite,
    child: Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(
          left: 4.h,
          right: 4.h,
          bottom: 34.h,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomImageView(
              imagePath: ImageConstant.imgThumbsUpBlue1008x8,
              height: 8.h,
              width: 10.h,
              margin: EdgeInsets.only(bottom: 48.h),
            ),
            Spacer(),
            Container(
              height: 6.h,
              width: 6.h,
              margin: EdgeInsets.only(bottom: 10.h),
              decoration: BoxDecoration(
                color: appTheme.lightBlue600,
                borderRadius: BorderRadius.circular(
                  3.h,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 300.h,
                margin: EdgeInsets.only(left: 18.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.maxFinite,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomImageView(
                            imagePath: ImageConstant.imgFavorite,
                            height: 12.h,
                            width: 14.h,
                            alignment: Alignment.bottomCenter,
                            margin: EdgeInsets.only(bottom: 2.h),
                          ),
                          Container(
                            width: 12.h,
                            margin: EdgeInsets.only(left: 4.h),
                            decoration: BoxDecoration(
                              color: appTheme.lightBlue600,
                            ),
                          ),
                          Spacer(
                            flex: 32,
                          ),
                          CustomImageView(
                            imagePath: ImageConstant.imgCheckmarkBlue100,
                            height: 20.h,
                            width: 30.h,
                            alignment: Alignment.center,
                          ),
                          Spacer(
                            flex: 67,
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 22.h),
                    Container(
                      height: 4.h,
                      width: 4.h,
                      margin: EdgeInsets.only(left: 42.h),
                      decoration: BoxDecoration(
                        color: appTheme.blue100,
                        borderRadius: BorderRadius.circular(
                          2.h,
                        ),
                      ),
                    ),
                    Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.symmetric(horizontal: 4.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomImageView(
                            imagePath:
                                ImageConstant.imgThumbsUpLightBlue60018x18,
                            height: 18.h,
                            width: 18.h,
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: 20.h,
                              margin: EdgeInsets.only(
                                left: 66.h,
                                top: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: appTheme.blue100,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 22.h),
                    Container(
                      height: 4.h,
                      width: 4.h,
                      margin: EdgeInsets.only(left: 48.h),
                      decoration: BoxDecoration(
                        color: appTheme.blue100,
                        borderRadius: BorderRadius.circular(
                          2.h,
                        ),
                      ),
                    ),
                    SizedBox(height: 28.h),
                    CustomImageView(
                      imagePath: ImageConstant.imgThumbsUp10x10,
                      height: 10.h,
                      width: 12.h,
                      margin: EdgeInsets.only(left: 32.h),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

/// Section Widget
Widget _buildRowthumbsup1(BuildContext context) {
  return SizedBox(
    width: double.maxFinite,
    child: Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.only(bottom: 370.h),
        padding: EdgeInsets.symmetric(horizontal: 2.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomImageView(
              imagePath: ImageConstant.imgThumbsUpBlue10016x16,
              height: 16.h,
              width: 18.h,
              margin: EdgeInsets.only(bottom: 10.h),
            ),
            Spacer(
              flex: 17,
            ),
            CustomImageView(
              imagePath: ImageConstant.imgTelevisionLightBlue60010x10,
              height: 10.h,
              width: 12.h,
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(bottom: 4.h),
            ),
            Spacer(
              flex: 20,
            ),
            Container(
              height: 12.h,
              width: 12.h,
              decoration: BoxDecoration(
                color: appTheme.lightBlue600,
                borderRadius: BorderRadius.circular(
                  6.h,
                ),
              ),
            ),
            Spacer(
              flex: 49,
            ),
            CustomImageView(
              imagePath: ImageConstant.imgTelevisionBlue10014x20,
              height: 14.h,
              width: 22.h,
              margin: EdgeInsets.only(top: 4.h),
            ),
            Spacer(
              flex: 12,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 14.h,
                decoration: BoxDecoration(
                  color: appTheme.blue100,
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

/// Section Widget
Widget _buildRowthumbsup2(BuildContext context) {
  return SizedBox(
    width: double.maxFinite,
    child: Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(
          left: 6.h,
          top: 354.h,
          right: 6.h,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomImageView(
              imagePath: ImageConstant.imgThumbsUpLightBlue60010x10,
              height: 10.h,
              width: 12.h,
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(
                left: 162.h,
                top: 4.h,
              ),
            ),
            CustomImageView(
              imagePath: ImageConstant.imgTelevisionPrimary,
              height: 10.h,
              width: 18.h,
              alignment: Alignment.topCenter,
            )
          ],
        ),
      ),
    ),
  );
}

/// Section Widget
Widget _buildRowspacerten(BuildContext context) {
  return SizedBox(
    width: double.maxFinite,
    child: Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(
          left: 24.h,
          top: 4.h,
          right: 24.h,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(
              flex: 42,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 20.h,
                decoration: BoxDecoration(
                  color: appTheme.blue100,
                ),
              ),
            ),
            Spacer(
              flex: 14,
            ),
            CustomImageView(
              imagePath: ImageConstant.imgTelevisionPrimary12x12,
              height: 12.h,
              width: 14.h,
              margin: EdgeInsets.only(top: 8.h),
            ),
            Container(
              height: 8.h,
              width: 8.h,
              margin: EdgeInsets.only(
                left: 6.h,
                top: 8.h,
              ),
              decoration: BoxDecoration(
                color: appTheme.lightBlue600,
                borderRadius: BorderRadius.circular(
                  4.h,
                ),
              ),
            ),
            CustomImageView(
              imagePath: ImageConstant.imgVideoCamera,
              height: 32.h,
              width: 10.h,
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(
                left: 18.h,
                top: 2.h,
              ),
            ),
            CustomImageView(
              imagePath: ImageConstant.imgThumbsUpBlue10020x20,
              height: 20.h,
              width: 22.h,
            ),
            Spacer(
              flex: 43,
            ),
            CustomImageView(
              imagePath: ImageConstant.imgThumbsUpBlue10018x18,
              height: 18.h,
              width: 20.h,
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(bottom: 4.h),
            )
          ],
        ),
      ),
    ),
  );
}

/// Section Widget
Widget _buildRowviewtwelve(BuildContext context) {
  return SizedBox(
    width: double.maxFinite,
    child: Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(
          left: 14.h,
          top: 378.h,
          right: 14.h,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 8.h,
                width: 8.h,
                decoration: BoxDecoration(
                  color: appTheme.blue100,
                  borderRadius: BorderRadius.circular(
                    4.h,
                  ),
                ),
              ),
            ),
            CustomImageView(
              imagePath: ImageConstant.imgRectangleLightBlue600,
              height: 14.h,
              width: 4.h,
              margin: EdgeInsets.only(
                left: 10.h,
                bottom: 6.h,
              ),
            )
          ],
        ),
      ),
    ),
  );
}

/// Section Widget
Widget _buildRowstarnine(BuildContext context) {
  return SizedBox(
    width: double.maxFinite,
    child: Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(
          left: 14.h,
          right: 14.h,
          bottom: 14.h,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 8.h,
              decoration: BoxDecoration(
                color: appTheme.blue100,
              ),
            ),
            Container(
              width: 12.h,
              margin: EdgeInsets.only(left: 80.h),
              decoration: BoxDecoration(
                color: appTheme.blue100,
              ),
            )
          ],
        ),
      ),
    ),
  );
}
