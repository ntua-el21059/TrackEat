// Core Flutter and third-party package imports
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../../core/app_export.dart';
import '../../../../../theme/custom_button_style.dart';
import '../../../../../widgets/app_bar/appbar_title.dart';
import '../../../../../widgets/app_bar/appbar_trailing_image.dart';
import '../../../../../widgets/app_bar/custom_app_bar.dart';
import '../../../../../widgets/custom_bottom_bar.dart';
import '../../../../../widgets/custom_elevated_button.dart';
import 'models/challenges1two_item_model.dart';
import 'models/leaderboard_1_2_model.dart';
import 'models/listfour_item_model.dart';
import 'provider/leaderboard_provider.dart';
import 'widgets/challenges1two_item_widget.dart';
import 'widgets/listfour_item_widget.dart';

// Main screen widget for the leaderboard feature
class Leaderboard12Screen extends StatefulWidget {
  const Leaderboard12Screen({Key? key})
      : super(
          key: key,
        );

  @override
  Leaderboard12ScreenState createState() => Leaderboard12ScreenState();

  // Factory builder method to create the screen with its provider
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Leaderboard12Provider(),
      child: Leaderboard12Screen(),
    );
  }
}

// ignore_for_file: must_be_immutable
class Leaderboard12ScreenState extends State<Leaderboard12Screen> {
  // Key for handling navigation within the screen
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  // Duplicate builder method - might be an error in the original code
  Leaderboard12ScreenState createState() => Leaderboard12ScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Leaderboard12Provider(),
      child: Leaderboard12Screen(),
    );
  }
}

// ignore_for_file: must_be_immutable
class Leaderboard12ScreenState extends State<Leaderboard12Screen> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Main screen scaffold with app bar, body, and bottom navigation
    return Scaffold(
      backgroundColor: theme.colorScheme.onErrorContainer,
      appBar: _buildAppbar(context),
      body: SafeArea(
        top: false,
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(
            left: 6.h,
            top: 22.h,
            right: 6.h,
          ),
          // Main column containing leaderboard, friend finder, and challenges sections
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildLeaderboard(context),
              SizedBox(height: 8.h),
              // Friend finder button with search icon
              CustomElevatedButton(
                height: 22.h,
                width: 100.h,
                text: "Find Friends",
                margin: EdgeInsets.only(right: 6.h),
                rightIcon: Container(
                  margin: EdgeInsets.only(left: 4.h),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgSearch,
                    height: 10.h,
                    width: 10.h,
                    fit: BoxFit.contain,
                  ),
                ),
                buttonStyle: CustomButtonStyles.fillPrimaryTL10,
                buttonTextStyle: CustomTextStyles.bodySmallOnErrorContainer,
                alignment: Alignment.centerRight,
              ),
              SizedBox(height: 10.h),
              // Challenges section header
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 12.h),
                  child: Text(
                    "Challenges",
                    style: CustomTextStyles.bodyLargeBlack90018,
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              _buildChallenges1two(context),
              SizedBox(height: 22.h),
              // Carousel indicator dots for challenges
              Consumer<Leaderboard12Provider>(
                builder: (context, provider, child) {
                  return SizedBox(
                    height: 24.h,
                    child: AnimatedSmoothIndicator(
                      activeIndex: provider.sliderIndex,
                      count: provider
                          .leaderboard12ModelObj.challenges1twoItemList.length,
                      axisDirection: Axis.horizontal,
                      effect: ScrollingDotsEffect(
                        spacing: 8,
                        activeDotColor: appTheme.black900,
                        dotColor: appTheme.black900.withOpacity(0.3),
                        dotHeight: 8.h,
                        dotWidth: 8.h,
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        width: double.maxFinite,
        child: _buildBottombar(context),
      ),
    );
  }

  /// Custom app bar with title and notification bell
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      title: AppbarTitle(
        text: "Leaderboard",
        margin: EdgeInsets.only(left: 18.h),
      ),
      actions: [
        AppbarTrailingImage(
          imagePath: ImageConstant.imgBell1,
          height: 32.h,
          width: 32.h,
          margin: EdgeInsets.only(right: 32.h),
        )
      ],
    );
  }

  /// Leaderboard section showing user rankings
  Widget _buildLeaderboard(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 12.h,
      ),
      decoration: AppDecoration.lightBlueLayoutPadding.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Consumer<Leaderboard12Provider>(
            builder: (context, provider, child) {
              return ListView.separated(
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 8.h,
                  );
                },
                itemCount:
                    provider.leaderboard12ModelObj.listfourItemList.length,
                itemBuilder: (context, index) {
                  ListfourItemModel model =
                      provider.leaderboard12ModelObj.listfourItemList[index];
                  return ListfourItemWidget(
                    model,
                  );
                },
              );
            },
          ),
          SizedBox(height: 8.h)
        ],
      ),
    );
  }

  /// Carousel of challenge items
  Widget _buildChallenges1two(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Consumer<Leaderboard12Provider>(
        builder: (context, provider, child) {
          return CarouselSlider.builder(
            options: CarouselOptions(
              height: 108.h,
              initialPage: 0,
              autoPlay: true,
              viewportFraction: 0.29,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index, reason) {
                context.read<Leaderboard12Provider>().changeSliderIndex(index);
              },
            ),
            itemCount:
                provider.leaderboard12ModelObj.challenges1twoItemList.length,
            itemBuilder: (context, index, realIndex) {
              Challenges1twoItemModel model =
                  provider.leaderboard12ModelObj.challenges1twoItemList[index];
              return Challenges1twoItemWidget(
                model,
              );
            },
          );
        },
      ),
    );
  }

  /// Bottom navigation bar
  Widget _buildBottombar(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: CustomBottomBar(
        onChanged: (BottomBarEnum type) {
          Navigator.pushNamed(
              navigatorKey.currentContext!, getCurrentRoute(type));
        },
      ),
    );
  }

  /// Route handling for bottom navigation
  String getCurrentRoute(BottomBarEnum type) {
    switch (type) {
      case BottomBarEnum.Home:
        return AppRoutes.homeInitialPage;
      case BottomBarEnum.Leaderboard:
        return "/";
      default:
        return "/";
    }
  }
}
