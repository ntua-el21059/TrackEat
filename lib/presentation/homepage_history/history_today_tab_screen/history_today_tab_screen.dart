import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/appbar_subtitle.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/custom_icon_button.dart';
import 'models/history_today_tab_model.dart';
import 'models/historytoday_item_model.dart';
import 'provider/history_today_tab_provider.dart';
import 'widgets/historytoday_item_widget.dart';

class HistoryTodayTabScreen extends StatefulWidget {
  const HistoryTodayTabScreen({Key? key}) : super(key: key);

  @override
  HistoryTodayTabScreenState createState() => HistoryTodayTabScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HistoryTodayTabProvider(),
      child: HistoryTodayTabScreen(),
    );
  }
}

class HistoryTodayTabScreenState extends State<HistoryTodayTabScreen> {
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
              height: 760.h,
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(horizontal: 4.h),
              child: Column(
                mainAxisSize: MainAxisSize.max,
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
                      style: CustomTextStyles.labelLargeSFProBluegray400,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _buildCalories(context),
                  SizedBox(height: 38.h),
                  Padding(
                    padding: EdgeInsets.only(left: 18.h),
                    child: Text(
                      "Breakfast",
                      style: CustomTextStyles.headlineSmallBold,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  _buildColumnlinear(context),
                  SizedBox(height: 24.h),
                  Padding(
                    padding: EdgeInsets.only(left: 18.h),
                    child: Text(
                      "Lunch",
                      style: CustomTextStyles.headlineSmallBold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  _buildColumnlinear1(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
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

  /// Section Widget
  Widget _buildCalories(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 8.h,
        vertical: 18.h,
      ),
      decoration: AppDecoration.lightBlueLayoutPadding.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 2.h),
          SizedBox(
            height: 32.h,
            width: 332.h,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 2.h),
                    child: Text(
                      "1500 Kcal Remaining...  ",
                      style: CustomTextStyles.titleMediumGray90001Bold,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 10.h),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: " 3000 kcal",
                            style: CustomTextStyles.labelMediumRed900,
                          ),
                          TextSpan(
                            text: "  ",
                          )
                        ],
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Container(
                  height: 8.h,
                  width: 330.h,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onErrorContainer,
                    borderRadius: BorderRadius.circular(
                      4.h,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      4.h,
                    ),
                    child: LinearProgressIndicator(
                      value: 0.53,
                      backgroundColor: theme.colorScheme.onErrorContainer,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        appTheme.green500,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 14.h),
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.only(
              left: 16.h,
              right: 12.h,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Protein",
                        style: CustomTextStyles.bodyLargeBlack90016_2,
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        child: _buildNumberandunit(
                          context,
                          p45seventyOne: "78/98",
                          gOne: "g",
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        "Fats",
                        style: CustomTextStyles.bodyLargeBlack90016_2,
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        child: _buildNumberandunit(
                          context,
                          p45seventyOne: "45/70",
                          gOne: "g",
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        "Carbs",
                        style: CustomTextStyles.bodyLargeBlack90016_2,
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        child: _buildNumberandunit(
                          context,
                          p45seventyOne: "95/110",
                          gOne: "g",
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 138.h,
                  width: 138.h,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 88.h,
                        width: 88.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            44.h,
                          ),
                          gradient: LinearGradient(
                            begin: Alignment(0.53, 0.53),
                            end: Alignment(0.53, 1.06),
                            colors: [
                              appTheme.tealA400,
                              theme.colorScheme.onPrimaryContainer
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: double.maxFinite,
                        decoration: AppDecoration.outlineBlue100,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              width: double.maxFinite,
                              decoration: AppDecoration
                                  .gradientLimeAToLightGreenA
                                  .copyWith(
                                borderRadius: BorderRadiusStyle.roundedBorder68,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: double.maxFinite,
                                    decoration: AppDecoration.outlineBlue100,
                                    child: Column(
                                      children: [
                                        Container(
                                          width: double.maxFinite,
                                          decoration: AppDecoration
                                              .gradientPinkAToRedA
                                              .copyWith(
                                            borderRadius: BorderRadiusStyle
                                                .roundedBorder68,
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                width: double.maxFinite,
                                                child: Card(
                                                  clipBehavior: Clip.antiAlias,
                                                  elevation: 0,
                                                  margin: EdgeInsets.zero,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadiusStyle
                                                            .roundedBorder68,
                                                  ),
                                                  child: Container(
                                                    height: 138.h,
                                                    width: double.maxFinite,
                                                    decoration: AppDecoration
                                                        .gradientBlackToBlack
                                                        .copyWith(
                                                      borderRadius:
                                                          BorderRadiusStyle
                                                              .roundedBorder68,
                                                    ),
                                                    child: Stack(
                                                      alignment:
                                                          Alignment.topCenter,
                                                      children: [
                                                        Container(
                                                          height: 14.h,
                                                          width: 14.h,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: appTheme
                                                                .redA400,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                              6.h,
                                                            ),
                                                          ),
                                                        ),
                                                        CustomImageView(
                                                          imagePath: ImageConstant
                                                              .imgNotification,
                                                          height: 48.h,
                                                          width: 16.h,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildColumnlinear(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(
        left: 18.h,
        right: 26.h,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 6.h,
        vertical: 8.h,
      ),
      decoration: AppDecoration.outlineBlue100.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.only(right: 14.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: _buildColumnveganbaco(
                      context,
                      veganbaconOne: "Salad",
                      weightOne: "69 kcal -100g",
                    ),
                  ),
                ),
                CustomIconButton(
                  height: 30.h,
                  width: 30.h,
                  padding: EdgeInsets.all(2.h),
                  decoration: IconButtonStyleHelper.outlineBlue,
                  child: CustomImageView(
                    imagePath: ImageConstant.imgLinearEssentional,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            margin: EdgeInsets.only(
              left: 16.h,
              right: 28.h,
            ),
            width: double.maxFinite,
            child: Consumer<HistoryTodayTabProvider>(
              builder: (context, provider, child) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    direction: Axis.horizontal,
                    spacing: 62.h,
                    children: List.generate(
                      provider
                          .historyTodayTabModelObj.historytodayItemList.length,
                      (index) {
                        HistorytodayItemModel model = provider
                            .historyTodayTabModelObj
                            .historytodayItemList[index];
                        return HistorytodayItemWidget(
                          model,
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildColumnlinear1(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(
        left: 18.h,
        right: 26.h,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 6.h,
        vertical: 8.h,
      ),
      decoration: AppDecoration.outlineBlue100.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.only(right: 14.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: _buildColumnveganbaco(
                      context,
                      veganbaconOne: "Vegan bacon cheeseburger",
                      weightOne: "69 kcal -100g",
                    ),
                  ),
                ),
                CustomIconButton(
                  height: 30.h,
                  width: 30.h,
                  padding: EdgeInsets.all(2.h),
                  decoration: IconButtonStyleHelper.outlineBlue,
                  child: CustomImageView(
                    imagePath: ImageConstant.imgLinearEssentional,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            margin: EdgeInsets.only(
              left: 16.h,
              right: 28.h,
            ),
            width: double.maxFinite,
            child: Consumer<HistoryTodayTabProvider>(
              builder: (context, provider, child) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    direction: Axis.horizontal,
                    spacing: 62.h,
                    children: List.generate(
                      provider
                          .historyTodayTabModelObj.historytodayItemList.length,
                      (index) {
                        HistorytodayItemModel model = provider
                            .historyTodayTabModelObj
                            .historytodayItemList[index];
                        return HistorytodayItemWidget(
                          model,
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildNumberandunit(BuildContext context, {
    required String p45seventyOne,
    required String gOne,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          p45seventyOne,
          style: CustomTextStyles.bodyLargeBlack900.copyWith(
            color: appTheme.black900.withAlpha(122),
          ),
        ),
        Text(
          gOne,
          style: CustomTextStyles.bodyLargeBlack900.copyWith(
            color: appTheme.black900.withAlpha(122),
          ),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildColumnveganbaco(BuildContext context, {
    required String veganbaconOne,
    required String weightOne,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          veganbaconOne,
          style: CustomTextStyles.titleMediumGray90001Bold,
        ),
        SizedBox(height: 4.h),
        Text(
          weightOne,
          style: CustomTextStyles.bodyLargeGray900,
        ),
      ],
    );
  }
}
