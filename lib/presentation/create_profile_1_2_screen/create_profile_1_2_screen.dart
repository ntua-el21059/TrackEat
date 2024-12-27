import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'models/create_profile_1_2_model.dart';
import 'provider/create_profile_1_2_provider.dart';

class CreateProfile12Screen extends StatefulWidget {
  const CreateProfile12Screen({Key? key}) : super(key: key);

  @override
  CreateProfile12ScreenState createState() => CreateProfile12ScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CreateProfile12Provider(),
      child: CreateProfile12Screen(),
    );
  }
}

class CreateProfile12ScreenState extends State<CreateProfile12Screen> {
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
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: Column(
            children: [
              Text(
                "Let’s complete your profile (1/3)",
                style: theme.textTheme.headlineSmall,
              ),
              SizedBox(height: 18.h),
              Text(
                "Please fill in your details. ",
                style: CustomTextStyles.titleLargeBlack900,
              ),
              SizedBox(height: 26.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 8.h),
                  child: Text(
                    "First name",
                    style: CustomTextStyles.titleSmallBlack90015,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              _buildFirstName(context),
              SizedBox(height: 8.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 8.h),
                  child: Text(
                    "Last name",
                    style: CustomTextStyles.titleSmallBlack90015,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              _buildLastName(context),
              SizedBox(height: 8.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 8.h),
                  child: Text(
                    "Birthdate ",
                    style: CustomTextStyles.titleSmallBlack90015,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              _buildDate(context),
              SizedBox(height: 8.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 8.h),
                  child: Text(
                    "Gender",
                    style: CustomTextStyles.titleSmallBlack90015,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              _buildGendertwo(context),
              Spacer(),
              _buildNext(context),
              SizedBox(height: 48.h),
            ],
          ),
        ),
      ),
    );
  }

  /// AppBar Widget
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

  /// First Name Field
  Widget _buildFirstName(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      child: Selector<CreateProfile12Provider, TextEditingController?>(
        selector: (context, provider) => provider.firstNameController,
        builder: (context, firstNameController, child) {
          return CustomTextFormField(
            controller: firstNameController,
            hintText: "John",
            hintStyle: CustomTextStyles.bodyLargeGray500,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 12.h,
            ),
          );
        },
      ),
    );
  }

  /// Last Name Field
  Widget _buildLastName(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      child: Selector<CreateProfile12Provider, TextEditingController?>(
        selector: (context, provider) => provider.lastNameController,
        builder: (context, lastNameController, child) {
          return CustomTextFormField(
            controller: lastNameController,
            hintText: "Appleseed",
            hintStyle: CustomTextStyles.bodyLargeGray500,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 12.h,
            ),
          );
        },
      ),
    );
  }

  /// Birthdate Field
  Widget _buildDate(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      child: Selector<CreateProfile12Provider, TextEditingController?>(
        selector: (context, provider) => provider.dateController,
        builder: (context, dateController, child) {
          return CustomTextFormField(
            readOnly: true,
            controller: dateController,
            hintText: "01/01/2000",
            hintStyle: CustomTextStyles.bodyLargeGray500,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 12.h,
            ),
          );
        },
      ),
    );
  }

  /// Gender Field
  Widget _buildGendertwo(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      child: Selector<CreateProfile12Provider, TextEditingController?>(
        selector: (context, provider) => provider.gendertwoController,
        builder: (context, gendertwoController, child) {
          return CustomTextFormField(
            controller: gendertwoController,
            hintText: "Male",
            hintStyle: CustomTextStyles.bodyLargeGray500,
            textInputAction: TextInputAction.done,
            suffix: Container(
              margin: EdgeInsets.fromLTRB(16.h, 12.h, 10.h, 12.h),
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
            contentPadding: EdgeInsets.fromLTRB(16.h, 12.h, 10.h, 12.h),
          );
        },
      ),
    );
  }

  /// Next Button
  Widget _buildNext(BuildContext context) {
    return CustomElevatedButton(
      height: 48.h,
      width: 114.h,
      text: "Next",
      margin: EdgeInsets.only(right: 6.h),
      buttonStyle: CustomButtonStyles.fillPrimary,
      buttonTextStyle: theme.textTheme.titleMedium!,
      alignment: Alignment.centerRight,
    );
  }
}