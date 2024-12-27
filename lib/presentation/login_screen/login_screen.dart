import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_checkbox_button.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'models/login_model.dart';
import 'provider/login_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginProvider(),
      child: LoginScreen(),
    );
  }
}

class LoginScreenState extends State<LoginScreen> {
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
          padding: EdgeInsets.only(
            left: 12.h,
            top: 34.h,
            right: 12.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Login",
                style: CustomTextStyles.headlineLargeGray900,
              ),
              SizedBox(height: 12.h),
              Text(
                "Welcome back to TrackEat",
                style: CustomTextStyles.bodyLargeBluegray70018,
              ),
              SizedBox(height: 74.h),
              Padding(
                padding: EdgeInsets.only(left: 8.h),
                child: Text(
                  "Email Address or username",
                  style: CustomTextStyles.bodyLargeBlack90018,
                ),
              ),
              SizedBox(height: 10.h),
              _buildUserName(context),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.only(left: 8.h),
                child: Text(
                  "Password",
                  style: CustomTextStyles.bodyLargeBlack90018,
                ),
              ),
              SizedBox(height: 8.h),
              _buildPasswordtwo(context),
              SizedBox(height: 14.h),
              Padding(
                padding: EdgeInsets.only(left: 8.h),
                child: Text(
                  "Forgot your Password ?",
                  style: CustomTextStyles.bodySmallPrimary,
                ),
              ),
              SizedBox(height: 14.h),
              _buildKeepmesignedin(context),
              SizedBox(height: 14.h),
              _buildLogintwo(context),
              SizedBox(height: 16.h),
              _buildRowlineeightyfi(context),
              SizedBox(height: 14.h),
              _buildContinuewith(context)
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 31.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftGray900,
        height: 24.h,
        width: 24.h,
        margin: EdgeInsets.only(left: 7.h),
      ),
    );
  }

  /// Section Widget
  Widget _buildUserName(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 8.h,
        right: 16.h,
      ),
      child: Selector<LoginProvider, TextEditingController?>(
        selector: (context, provider) => provider.userNameController,
        builder: (context, userNameController, child) {
          return CustomTextFormField(
            controller: userNameController,
            hintText: "hello@example.com",
            hintStyle: CustomTextStyles.bodyLargeGray50003,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 12.h,
            ),
            borderDecoration: TextFormFieldStyleHelper.outlineBlueGrayTL8,
          );
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildPasswordtwo(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 8.h,
        right: 16.h,
      ),
      child: Consumer<LoginProvider>(
        builder: (context, provider, child) {
          return CustomTextFormField(
            controller: provider.passwordtwoController,
            textInputAction: TextInputAction.done,
            suffix: InkWell(
              onTap: () {
                provider.changePasswordVisibility();
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(16.h, 12.h, 10.h, 12.h),
                child: CustomImageView(
                  imagePath: ImageConstant.imgIconEyeGray500,
                  height: 20.h,
                  width: 24.h,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            suffixConstraints: BoxConstraints(
              maxHeight: 48.h,
            ),
            obscureText: provider.isShowPassword,
            contentPadding: EdgeInsets.fromLTRB(16.h, 12.h, 10.h, 12.h),
          );
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildKeepmesignedin(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.h),
      child: Selector<LoginProvider, bool?>(
        selector: (context, provider) => provider.keepmesignedin,
        builder: (context, keepmesignedin, child) {
          return CustomCheckboxButton(
            text: "Keep me signed in",
            value: keepmesignedin,
            onChange: (value) {
              context.read<LoginProvider>().changeCheckBox(value);
            },
          );
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildLogintwo(BuildContext context) {
    return CustomElevatedButton(
      height: 48.h,
      text: "Login",
      margin: EdgeInsets.only(
        left: 12.h,
        right: 10.h,
      ),
      buttonStyle: CustomButtonStyles.fillPrimary,
      buttonTextStyle: theme.textTheme.titleMedium!,
    );
  }

  /// Section Widget
  Widget _buildRowlineeightyfi(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 6.h),
              child: Divider(
                color: appTheme.black900.withOpacity(0.25),
              ),
            ),
          ),
          SizedBox(width: 8.h),
          Align(
            alignment: Alignment.center,
            child: Text(
              "or sign in with",
              style: CustomTextStyles.bodySmallBlack900,
            ),
          ),
          SizedBox(width: 8.h),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 6.h),
              child: Divider(
                color: appTheme.black900.withOpacity(0.25),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildContinuewith(BuildContext context) {
    return CustomElevatedButton(
      height: 48.h,
      text: "Continue with Google",
      margin: EdgeInsets.only(
        left: 12.h,
        right: 10.h,
      ),
      leftIcon: Container(
        margin: EdgeInsets.only(right: 16.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgGoogle,
          height: 24.h,
          width: 24.h,
          fit: BoxFit.contain,
        ),
      ),
      buttonStyle: CustomButtonStyles.fillGray,
      buttonTextStyle: CustomTextStyles.bodyLargeBluegray700,
    );
  }
}
