import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../routes/app_routes.dart';
import '../widgets.dart';
import 'create_profile_2_2_provider.dart';

class CreateProfile22Screen extends StatefulWidget {
  const CreateProfile22Screen({Key? key}) : super(key: key);

  @override
  CreateProfile22ScreenState createState() => CreateProfile22ScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CreateProfile22Provider(),
      child: CreateProfile22Screen(),
    );
  }
}

class CreateProfile22ScreenState extends State<CreateProfile22Screen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(context),
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 14.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "msg_let_s_complete_your2".tr,
                style: theme.textTheme.headlineSmall,
              ),
              SizedBox(height: 52.h),
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(horizontal: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "lbl_activity".tr,
                      style: theme.textTheme.titleSmall,
                    ),
                    SizedBox(height: 8.h),
                    _buildActivityInput(context),
                    SizedBox(height: 8.h),
                    Text(
                      "lbl_diet_optional".tr,
                      style: theme.textTheme.titleSmall,
                    ),
                    SizedBox(height: 8.h),
                    _buildDietInput(context),
                    SizedBox(height: 8.h),
                    Text(
                      "lbl_goal".tr,
                      style: theme.textTheme.titleSmall,
                    ),
                    SizedBox(height: 8.h),
                    _buildGoalInput(context),
                    SizedBox(height: 8.h),
                    Text(
                      "lbl_height_cm".tr,
                      style: theme.textTheme.titleSmall,
                    ),
                    SizedBox(height: 8.h),
                    _buildHeightInput(context),
                    SizedBox(height: 8.h),
                    Text(
                      "msg_current_weight_kg".tr,
                      style: theme.textTheme.titleSmall,
                    ),
                    SizedBox(height: 8.h),
                    _buildWeightInput(context),
                  ],
                ),
              ),
              Spacer(),
              _buildNextButton(context),
              SizedBox(height: 48.h),
            ],
          ),
        ),
      ),
    );
  }


/// Section Widget
Widget _buildGoalInput(BuildContext context) {
  return Selector<CreateProfile22Provider, TextEditingController?>(
    selector: (context, provider) => provider.goalInputController,
    builder: (context, goalInputController, child) {
      return CustomTextFormField(
        controller: goalInputController,
        hintText: "lbl_lose_weight".tr,
        suffix: Container(
          margin: EdgeInsets.fromLTRB(16.h, 14.h, 8.h, 14.h),
          child: CustomImageView(
            imagePath: ImageConstant.img,
            height: 20.h,
            width: 14.h,
            fit: BoxFit.contain,
          ),
        ),
        suffixConstraints: BoxConstraints(
          maxHeight: 48.h,
        ),
        contentPadding: EdgeInsets.fromLTRB(16.h, 14.h, 8.h, 14.h),
      );
    },
  );
}

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
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

  /// Section Widget
  Widget _buildActivityInput(BuildContext context) {
    return Selector<CreateProfile22Provider, TextEditingController?>(
      selector: (context, provider) => provider.activityInputController,
      builder: (context, activityInputController, child) {
        return CustomTextFormField(
          controller: activityInputController,
          hintText: "msg_daily_6_7_times".tr,
          suffix: Container(
            margin: EdgeInsets.fromLTRB(16.h, 14.h, 8.h, 14.h),
            child: CustomImageView(
              imagePath: ImageConstant.img,
              height: 20.h,
              width: 14.h,
              fit: BoxFit.contain,
            ),
          ),
          suffixConstraints: BoxConstraints(
            maxHeight: 48.h,
          ),
          contentPadding: EdgeInsets.fromLTRB(16.h, 14.h, 8.h, 14.h),
        );
      },
    );
  }

  /// Section Widget
  Widget _buildDietInput(BuildContext context) {
    return Selector<CreateProfile22Provider, TextEditingController?>(
      selector: (context, provider) => provider.dietInputController,
      builder: (context, dietInputController, child) {
        return CustomTextFormField(
          controller: dietInputController,
          hintText: "lbl_vegan".tr,
          suffix: Container(
            margin: EdgeInsets.fromLTRB(16.h, 14.h, 8.h, 14.h),
            child: CustomImageView(
              imagePath: ImageConstant.img,
              height: 20.h,
              width: 14.h,
              fit: BoxFit.contain,
            ),
          ),
          suffixConstraints: BoxConstraints(
            maxHeight: 48.h,
          ),
          contentPadding: EdgeInsets.fromLTRB(16.h, 14.h, 8.h, 14.h),
        );
      },
    );
  }

  /// Section Widget
  Widget _buildHeightInput(BuildContext context) {
    return Selector<CreateProfile22Provider, TextEditingController?>(
      selector: (context, provider) => provider.heightInputController,
      builder: (context, heightInputController, child) {
        return CustomTextFormField(
          controller: heightInputController,
          hintText: "lbl_180".tr,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.h,
            vertical: 12.h,
          ),
        );
      },
    );
  }

  /// Section Widget
  Widget _buildWeightInput(BuildContext context) {
    return Selector<CreateProfile22Provider, TextEditingController?>(
      selector: (context, provider) => provider.weightInputController,
      builder: (context, weightInputController, child) {
        return CustomTextFormField(
          controller: weightInputController,
          hintText: "lbl_80".tr,
          textInputAction: TextInputAction.done,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.h,
            vertical: 12.h,
          ),
        );
      },
    );
  }

  /// Section Widget
  Widget _buildNextButton(BuildContext context) {
    return CustomElevatedButton(
      width: 114.h,
      text: "lbl_next".tr,
      margin: EdgeInsets.only(right: 8.h),
      onPressed: () {
        onTapNextButton(context);
      },
    );
  }

  /// Navigates to the previous screen.
  onTapArrowleftone(BuildContext context) {
    NavigatorService.goBack();
  }

  /// Navigates to the calorieCalculatorScreen when the action is triggered.
  onTapNextButton(BuildContext context) {
    NavigatorService.pushNamed(
      AppRoutes.calorieCalculatorScreen,
    );
  }
}
