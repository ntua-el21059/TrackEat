import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../routes/app_routes.dart';
import '../widgets.dart';
import 'calorie_calculator_provider.dart';

class CalorieCalculatorScreen extends StatefulWidget {
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CalorieCalculatorProvider(),
      child: CalorieCalculatorScreen(),
    );
  }

  @override
  CalorieCalculatorScreenState createState() => CalorieCalculatorScreenState();
}

class CalorieCalculatorScreenState extends State<CalorieCalculatorScreen> {
  @override
  void initState() {
    super.initState();
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 31.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeft,
        margin: EdgeInsets.only(left: 7.h),
        onTap: () {
          onTapArrowleftone(context);
        },
      ),
    );
  }

@override
Widget build(BuildContext context) {
  return SafeArea(
    child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppbar(context),
      body: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 14.h),
        child: Column(
          children: [
            Text(
              "msg_let_s_complete_your3".tr,
              style: theme.textTheme.headlineSmall,
            ),
            SizedBox(height: 60.h),
            Text(
              "msg_our_calorie_calculator".tr,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: CustomTextStyles.bodyLargeBlack900.copyWith(
                height: 1.38,
              ),
            ),
            SizedBox(height: 78.h),
            _buildCalorieInputSection(context),
            Spacer(),
            CustomElevatedButton(
              width: 114.h,
              text: "lbl_finish".tr,
              margin: EdgeInsets.only(right: 8.h),
              alignment: Alignment.centerRight,
            ),
            SizedBox(height: 48.h)
          ],
        ),
      ),
    ),
  );
}

  Widget _buildCalorieInputSection(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "msg_calories_per_day".tr,
            style: theme.textTheme.titleSmall,
          ),
          Selector<CalorieCalculatorProvider, TextEditingController?>(
            selector: (context, provider) => provider.zipcodeController,
            builder: (context, zipcodeController, child) {
              return CustomTextFormField(
                controller: zipcodeController,
                hintText: "lbl_2500".tr,
                textInputAction: TextInputAction.done,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.h,
                  vertical: 12.h,
                ),
              );
            },
          )
        ],
      ),
    );
  }

  /// Navigates to the previous screen.
  void onTapArrowleftone(BuildContext context) {
    NavigatorService.goBack();
  }
}
