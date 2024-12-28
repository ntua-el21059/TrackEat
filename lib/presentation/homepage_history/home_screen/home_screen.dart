import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_bottom_bar.dart';
import '../../../widgets/app_bar/appbar_subtitle_one.dart';
import '../../../widgets/app_bar/appbar_title.dart';
import '../../../widgets/app_bar/appbar_trailing_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import 'models/cards_item_model.dart';
import 'models/home_model.dart';
import 'provider/home_provider.dart';
import 'widgets/cards_item_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeProvider(),
      child: HomeScreen(),
    );
  }
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.onErrorContainer,
      appBar: _buildAppbar(context),
      body: Container(
        width: double.maxFinite,
        decoration: AppDecoration.graysWhite,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.only(
                    left: 4.h,
                    top: 22.h,
                    right: 4.h,
                  ),
                  child: Column(
                    children: [
                      _buildCalories(context),
                      SizedBox(height: 16.h),
                      _buildSuggestionsone(context),
                      SizedBox(height: 14.h)
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: _buildBottombar(context),
    );
  }

  /// Common widget
  Widget _buildNumberandunit(
    BuildContext context, {
    required String p45seventyOne,
    required String gOne,
  }) {
    return Row(
      children: [
        Text(
          p45seventyOne,
          style: CustomTextStyles.titleLargeLimeA700.copyWith(
            color: appTheme.limeA700,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            gOne,
            style: CustomTextStyles.titleMediumLimeA700.copyWith(
              color: appTheme.limeA700,
            ),
          ),
        )
      ],
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      title: Padding(
        padding: EdgeInsets.only(left: 19.h),
        child: Column(
          children: [
            AppbarSubtitleOne(
              text: "WELCOME".toUpperCase(),
              margin: EdgeInsets.only(right: 162.h),
            ),
            AppbarTitle(
              text: "John Appleseed",
            )
          ],
        ),
      ),
      actions: [
        AppbarTrailingImage(
          imagePath: ImageConstant.imgBoy1,
          height: 42.h,
          width: 42.h,
          margin: EdgeInsets.only(right: 16.h),
        )
      ],
    );
  }

  /// Section Widget
  Widget _buildCalories(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 6.h,
        vertical: 22.h,
      ),
      decoration: AppDecoration.lightBlueLayoutPadding.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
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
                    width: double.maxFinite,
                    decoration: AppDecoration.graysWhite.copyWith(
                      borderRadius: BorderRadiusStyle.circleBorder4,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 8.h,
                          width: 174.h,
                          decoration: BoxDecoration(
                            color: appTheme.green500,
                            borderRadius: BorderRadius.circular(4.h),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(horizontal: 14.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomLeft,
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsone(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 6.h,
        vertical: 22.h,
      ),
      decoration: AppDecoration.lightBlueLayoutPadding.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Today's Suggestions",
            style: CustomTextStyles.titleMediumGray90001Bold,
          ),
          SizedBox(height: 16.h),
          Consumer<HomeProvider>(
            builder: (context, provider, child) {
              return ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 16.h);
                },
                itemCount: provider.homeInitialModelObj.cardsItemList.length,
                itemBuilder: (context, index) {
                  CardsItemModel model = provider.homeInitialModelObj.cardsItemList[index];
                  return CardsItemWidget(model);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottombar(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: CustomBottomBar(
        onChanged: (BottomBarEnum type) {
          switch (type) {
            case BottomBarEnum.Home:
              break;
            case BottomBarEnum.Leaderboard:
              Navigator.pushNamed(context, "/leaderboard");
              break;
          }
        },
      ),
    );
  }
}
