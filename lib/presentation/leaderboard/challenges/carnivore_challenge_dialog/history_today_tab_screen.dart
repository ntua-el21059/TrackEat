import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import '../../../../core/utils/date_time_utils.dart';
import '../../../../theme/app_decoration.dart';
import '../../../../theme/custom_text_style.dart';
import '../../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../../widgets/app_bar/appbar_subtitle.dart';
import '../../../../widgets/app_bar/custom_app_bar.dart';
import '../../../../widgets/custom_icon_button.dart';
import '../../../../widgets/custom_image_view.dart';
import '../../brocolli_challenge_dialog/blur_choose_action_screen_dialog.dart';
import '../../banana_challenge_dialog copy/models/history_today_tab_model.dart';
import '../../banana_challenge_dialog copy/models/historytoday_item_model.dart';
import '../../banana_challenge_dialog copy/provider/history_today_tab_provider.dart';
import '../../banana_challenge_dialog copy/widgets/historytoday_item_widget.dart';
import 'package:activity_ring/activity_ring.dart';

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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate loading delay
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
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
                      DateTimeUtils.getCurrentDate().toUpperCase(),
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
                  Consumer<HistoryTodayTabProvider>(
                      builder: (context, provider, child) {
                    return provider.hasBreakfast
                        ? _buildColumnlinear(context)
                        : _buildEmptyBreakfast(context);
                  }),
                  SizedBox(height: 24.h),
                  Padding(
                    padding: EdgeInsets.only(left: 18.h),
                    child: Text(
                      "Lunch",
                      style: CustomTextStyles.headlineSmallBold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Consumer<HistoryTodayTabProvider>(
                      builder: (context, provider, child) {
                    return provider.hasLunch
                        ? _buildColumnlinear1(context)
                        : _buildEmptyLunch(context);
                  }),
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
        onTap: () {
          Navigator.pop(context);
        },
      ),
      title: AppbarSubtitle(
        text: "Home",
        margin: EdgeInsets.only(left: 4.h),
      ),
    );
  }

  /// Section Widget
  Widget _buildCalories(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 8.h,
        vertical: 12.h,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFB2D7FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "1500 Kcal Remaining...",
                style: CustomTextStyles.titleMediumGray90001Bold,
              ),
              Text(
                "3000 kcal",
                style: TextStyle(
                  color: const Color(0xFFFF0000),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Container(
            width: double.maxFinite,
            height: 8.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.h),
            ),
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CD964),
                    borderRadius: BorderRadius.circular(4.h),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Protein",
                      style: CustomTextStyles.bodyLargeBlack90016_2,
                    ),
                    Text(
                      "78/98g",
                      style: TextStyle(
                        color: const Color(0xFFFA114F),
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "Fats",
                      style: CustomTextStyles.bodyLargeBlack90016_2,
                    ),
                    Text(
                      "45/70g",
                      style: TextStyle(
                        color: const Color(0xFFA6FF00),
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "Carbs",
                      style: CustomTextStyles.bodyLargeBlack90016_2,
                    ),
                    Text(
                      "95/110g",
                      style: TextStyle(
                        color: const Color(0xFF00FFF6),
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Ring(
                  percent: _isLoading ? 0 : 78 / 98 * 100,
                  color: RingColorScheme(
                    ringColor: Color(0xFFFA114F),
                    backgroundColor: Colors.grey.withOpacity(0.2),
                  ),
                  radius: 60,
                  width: 15,
                  child: Ring(
                    percent: _isLoading ? 0 : 45 / 70 * 100,
                    color: RingColorScheme(
                      ringColor: Color(0xFFA6FF00),
                      backgroundColor: Colors.grey.withOpacity(0.2),
                    ),
                    radius: 45,
                    width: 15,
                    child: Ring(
                      percent: _isLoading ? 0 : 95 / 110 * 100,
                      color: RingColorScheme(
                        ringColor: Color(0xFF00FFF6),
                        backgroundColor: Colors.grey.withOpacity(0.2),
                      ),
                      radius: 30,
                      width: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
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
      padding: EdgeInsets.all(8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFB2D7FF)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Salad",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Text(
                        "🔥",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        " 69 kcal -100g",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(178, 215, 255, 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: GestureDetector(
                  onTap: () {
                    final provider = context.read<HistoryTodayTabProvider>();
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return BlurChooseActionScreenDialog.builder(
                          dialogContext,
                          'breakfast',
                          () {
                            provider.deleteMeal('breakfast');
                            Navigator.pop(dialogContext);
                          },
                          'Salad',
                        );
                      },
                    );
                  },
                  child:
                      Icon(Icons.more_horiz, color: Colors.black54, size: 16),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMacroColumn(
                "69g",
                "Protein",
                const Color(0xFF4CD964),
                0.7,
              ),
              _buildMacroColumn(
                "69g",
                "Fats",
                const Color(0xFFFA114F),
                0.5,
              ),
              _buildMacroColumn(
                "69g",
                "Carbs",
                const Color(0xFFFFD60A),
                0.3,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroColumn(
      String value, String label, Color color, double progress) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 4,
                height: 32 * progress,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 6.h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
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
      padding: EdgeInsets.all(8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFB2D7FF)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Vegan bacon cheeseburger",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Text(
                        "🔥",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        " 69 kcal -100g",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(178, 215, 255, 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: GestureDetector(
                  onTap: () {
                    final provider = context.read<HistoryTodayTabProvider>();
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return BlurChooseActionScreenDialog.builder(
                          dialogContext,
                          'lunch',
                          () {
                            provider.deleteMeal('lunch');
                            Navigator.pop(dialogContext);
                          },
                          'Vegan bacon cheeseburger',
                        );
                      },
                    );
                  },
                  child:
                      Icon(Icons.more_horiz, color: Colors.black54, size: 16),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMacroColumn(
                "69g",
                "Protein",
                const Color(0xFF4CD964),
                0.7,
              ),
              _buildMacroColumn(
                "69g",
                "Fats",
                const Color(0xFFFA114F),
                0.5,
              ),
              _buildMacroColumn(
                "69g",
                "Carbs",
                const Color(0xFFFFD60A),
                0.3,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildNumberandunit(
    BuildContext context, {
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
  Widget _buildColumnveganbaco(
    BuildContext context, {
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

  Widget _buildEmptyBreakfast(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(
        left: 18.h,
        right: 26.h,
      ),
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFB2D7FF)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "You haven't logged your breakfast yet.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8.h),
          CustomIconButton(
            height: 48.h,
            width: 48.h,
            child: Icon(Icons.add, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyLunch(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(
        left: 18.h,
        right: 26.h,
      ),
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFB2D7FF)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "You haven't logged your lunch yet.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12.h),
          CustomIconButton(
            height: 48.h,
            width: 48.h,
            child: Icon(Icons.add, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
