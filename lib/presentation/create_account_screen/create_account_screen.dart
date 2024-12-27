import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../theme/custom_button_style.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_text_form_field.dart';
import 'models/create_account_model.dart';
import 'provider/create_account_provider.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  CreateAccountScreenState createState() => CreateAccountScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CreateAccountProvider(),
      child: CreateAccountScreen(),
    );
  }
}

class CreateAccountScreenState extends State<CreateAccountScreen> {
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
              width: double.maxFinite,
              padding: EdgeInsets.only(
                left: 22.h,
                top: 48.h,
                right: 22.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 22.h),
                  Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "TrackEat",
                          style: CustomTextStyles.headlineLargeBlack900,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 14.h),
                  CustomImageView(
                    imagePath: ImageConstant.imgLogo,
                    height: 162.h,
                    width: double.maxFinite,
                    margin: EdgeInsets.symmetric(horizontal: 72.h),
                  ),
                  SizedBox(height: 16.h),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "We are tremendously happy to \nsee you joining our community",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: CustomTextStyles.bodyLargeBlack900.copyWith(
                        height: 1.29,
                      ),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Padding(
                    padding: EdgeInsets.only(left: 2.h),
                    child: Text(
                      "Username",
                      style: CustomTextStyles.bodyMediumBlack900,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  _buildUserName(context),
                  SizedBox(height: 8.h),
                  Padding(
                    padding: EdgeInsets.only(left: 2.h),
                    child: Text(
                      "Email",
                      style: CustomTextStyles.titleSmallSemiBold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  _buildEmailtwo(context),
                  SizedBox(height: 8.h),
                  Padding(
                    padding: EdgeInsets.only(left: 2.h),
                    child: Text(
                      "Password ",
                      style: CustomTextStyles.bodyMediumBlack900,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  _buildPasswordtwo(context),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.only(left: 2.h),
                    child: Text(
                      "Re-enter your password",
                      style: CustomTextStyles.titleSmallSemiBold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  _buildPasswordthree(context),
                  SizedBox(height: 38.h),
                  _buildNext(context),
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
      padding: EdgeInsets.only(left: 2.h),
      child: Selector<CreateAccountProvider, TextEditingController?>(
        selector: (context, provider) => provider.userNameController,
        builder: (context, userNameController, child) {
          return CustomTextFormField(
            controller: userNameController,
            hintText: "timapple",
            hintStyle: CustomTextStyles.bodyLargeGray900,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 12.h,
            ),
          );
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildEmailtwo(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 2.h),
      child: Selector<CreateAccountProvider, TextEditingController?>(
        selector: (context, provider) => provider.emailtwoController,
        builder: (context, emailtwoController, child) {
          return CustomTextFormField(
            controller: emailtwoController,
            hintText: "Appleseed@mail.com",
            hintStyle: CustomTextStyles.bodyLargeGray900,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 12.h,
            ),
          );
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildPasswordtwo(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 2.h),
      child: Consumer<CreateAccountProvider>(
        builder: (context, provider, child) {
          return CustomTextFormField(
            controller: provider.passwordtwoController,
            suffix: InkWell(
              onTap: () {
                provider.changePasswordVisibility();
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(16.h, 12.h, 10.h, 12.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.h),
                ),
                child: CustomImageView(
                  imagePath: ImageConstant.imgIconEye,
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
  Widget _buildPasswordthree(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 2.h),
      child: Consumer<CreateAccountProvider>(
        builder: (context, provider, child) {
          return CustomTextFormField(
            controller: provider.passwordthreeController,
            textInputAction: TextInputAction.done,
            suffix: InkWell(
              onTap: () {
                provider.changePasswordVisibility1();
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(16.h, 12.h, 10.h, 12.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.h),
                ),
                child: CustomImageView(
                  imagePath: ImageConstant.imgIconEye,
                  height: 20.h,
                  width: 24.h,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            suffixConstraints: BoxConstraints(
              maxHeight: 48.h,
            ),
            obscureText: provider.isShowPassword1,
            contentPadding: EdgeInsets.fromLTRB(16.h, 12.h, 10.h, 12.h),
          );
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildNext(BuildContext context) {
    return CustomElevatedButton(
      height: 48.h,
      width: 114.h,
      text: "Next",
      buttonStyle: CustomButtonStyles.fillPrimary,
      buttonTextStyle: theme.textTheme.titleMedium!,
      alignment: Alignment.centerRight,
    );
  }
}