import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../theme/custom_button_style.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_text_form_field.dart';
import 'models/calorie_calculator_model.dart';
import 'provider/calorie_calculator_provider.dart';

class CalorieCalculatorScreen extends StatefulWidget {
  const CalorieCalculatorScreen({Key? key}) : super(key: key);

  @override
  CalorieCalculatorScreenState createState() => CalorieCalculatorScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CalorieCalculatorProvider(),
      child: CalorieCalculatorScreen(),
    );
  }
}

class CalorieCalculatorScreenState extends State<CalorieCalculatorScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.onErrorContainer,
      resizeToAvoidBottomInset: false,
      appBar: _buildAppbar(context),
      body: SafeArea(
        top: false,
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 14.h),
          child: Column(
            children: [
              Text(
                "Let’s complete your profile (3/3)",
                style: theme.textTheme.headlineSmall,
              ),
              SizedBox(height: 60.h),
              Text(
                "Our calorie calculator made a personalized\nestimation for your calorie consumption\nat 2400 kcal daily.\nWould you like to set it as your daily goal\nor input your own calorie choice?",
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: CustomTextStyles.bodyLargeBlack90016_3.copyWith(
                  height: 1.38,
                ),
              ),
              SizedBox(height: 78.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.h),
                  child: Text(
                    "Calories per day ",
                    style: CustomTextStyles.titleSmallBlack90015,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.h),
                child: Selector<CalorieCalculatorProvider, TextEditingController?>(
                  selector: (context, provider) => provider.zipcodeController,
                  builder: (context, zipcodeController, child) {
                    return CustomTextFormField(
                      controller: zipcodeController,
                      hintText: "2500",
                      hintStyle: CustomTextStyles.bodyLargeGray500,
                      textInputAction: TextInputAction.done,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.h,
                        vertical: 12.h,
                      ),
                    );
                  },
                ),
              ),
              Spacer(),
              CustomElevatedButton(
                height: 48.h,
                width: 114.h,
                text: "Finish",
                margin: EdgeInsets.only(right: 8.h),
                buttonStyle: CustomButtonStyles.fillPrimary,
                buttonTextStyle: theme.textTheme.titleMedium!,
                alignment: Alignment.centerRight,
              ),
              SizedBox(height: 48.h)
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 28.h,
      leadingWidth: 31.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftGray900,
        height: 24.h,
        width: 24.h,
        margin: EdgeInsets.only(left: 7.h),
      ),
    );
  }
}
