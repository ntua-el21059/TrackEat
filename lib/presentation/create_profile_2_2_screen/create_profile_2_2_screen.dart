import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'models/create_profile_2_2_model.dart';
import 'provider/create_profile_2_2_provider.dart';

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Let’s complete your profile (2/3)",
                style: theme.textTheme.headlineSmall,
              ),
              SizedBox(height: 52.h),
              _buildSectionTitle(context, "Activity"),
              SizedBox(height: 8.h),
              _buildTime(context),
              SizedBox(height: 8.h),
              _buildSectionTitle(context, "Diet (Optional)"),
              SizedBox(height: 8.h),
              _buildInputone(context),
              SizedBox(height: 8.h),
              _buildSectionTitle(context, "Goal"),
              SizedBox(height: 8.h),
              _buildInputthree(context),
              SizedBox(height: 8.h),
              _buildSectionTitle(context, "Height (cm)"),
              SizedBox(height: 8.h),
              _buildInputfive(context),
              SizedBox(height: 8.h),
              _buildSectionTitle(context, "Current weight (Kg)"),
              SizedBox(height: 8.h),
              _buildInputseven(context),
              Spacer(),
              _buildNext(context),
              SizedBox(height: 48.h),
            ],
          ),
        ),
      ),
    );
  }

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

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(left: 10.h),
      child: Text(
        title,
        style: CustomTextStyles.titleSmallBlack90015,
      ),
    );
  }

  Widget _buildTime(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.h),
      child: Selector<CreateProfile22Provider, TextEditingController?>(
        selector: (context, provider) => provider.timeController,
        builder: (context, timeController, child) {
          return CustomTextFormField(
            controller: timeController,
            hintText: "Daily(6/7 times a week)",
            hintStyle: CustomTextStyles.bodyLargeGray500,
            suffix: Container(
              margin: EdgeInsets.fromLTRB(16.h, 12.h, 10.h, 12.h),
              child: CustomImageView(
                imagePath: ImageConstant.img,
                height: 20.h,
                width: 14.h,
                fit: BoxFit.contain,
              ),
            ),
            suffixConstraints: BoxConstraints(maxHeight: 48.h),
            contentPadding: EdgeInsets.fromLTRB(16.h, 12.h, 10.h, 12.h),
          );
        },
      ),
    );
  }

  Widget _buildInputone(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.h),
      child: Selector<CreateProfile22Provider, TextEditingController?>(
        selector: (context, provider) => provider.inputoneController,
        builder: (context, inputoneController, child) {
          return CustomTextFormField(
            controller: inputoneController,
            hintText: "Vegan",
            hintStyle: CustomTextStyles.bodyLargeGray500,
            suffix: Container(
              margin: EdgeInsets.fromLTRB(16.h, 12.h, 10.h, 12.h),
              child: CustomImageView(
                imagePath: ImageConstant.img,
                height: 20.h,
                width: 14.h,
                fit: BoxFit.contain,
              ),
            ),
            suffixConstraints: BoxConstraints(maxHeight: 48.h),
            contentPadding: EdgeInsets.fromLTRB(16.h, 12.h, 10.h, 12.h),
          );
        },
      ),
    );
  }

  Widget _buildInputthree(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.h),
      child: Selector<CreateProfile22Provider, TextEditingController?>(
        selector: (context, provider) => provider.inputthreeController,
        builder: (context, inputthreeController, child) {
          return CustomTextFormField(
            controller: inputthreeController,
            hintText: "Lose weight",
            hintStyle: CustomTextStyles.bodyLargeGray500,
            suffix: Container(
              margin: EdgeInsets.fromLTRB(16.h, 12.h, 10.h, 12.h),
              child: CustomImageView(
                imagePath: ImageConstant.img,
                height: 20.h,
                width: 14.h,
                fit: BoxFit.contain,
              ),
            ),
            suffixConstraints: BoxConstraints(maxHeight: 48.h),
            contentPadding: EdgeInsets.fromLTRB(16.h, 12.h, 10.h, 12.h),
          );
        },
      ),
    );
  }

  Widget _buildInputfive(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.h),
      child: Selector<CreateProfile22Provider, TextEditingController?>(
        selector: (context, provider) => provider.inputfiveController,
        builder: (context, inputfiveController, child) {
          return CustomTextFormField(
            controller: inputfiveController,
            hintText: "180",
            hintStyle: CustomTextStyles.bodyLargeGray500,
            contentPadding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h),
          );
        },
      ),
    );
  }

  Widget _buildInputseven(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.h),
      child: Selector<CreateProfile22Provider, TextEditingController?>(
        selector: (context, provider) => provider.inputsevenController,
        builder: (context, inputsevenController, child) {
          return CustomTextFormField(
            controller: inputsevenController,
            hintText: "80",
            hintStyle: CustomTextStyles.bodyLargeGray500,
            textInputAction: TextInputAction.done,
            contentPadding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h),
          );
        },
      ),
    );
  }

  Widget _buildNext(BuildContext context) {
    return CustomElevatedButton(
      height: 48.h,
      width: 114.h,
      text: "Next",
      margin: EdgeInsets.only(right: 8.h),
      buttonStyle: CustomButtonStyles.fillPrimary,
      buttonTextStyle: theme.textTheme.titleMedium!,
      alignment: Alignment.centerRight,
    );
  }
}
