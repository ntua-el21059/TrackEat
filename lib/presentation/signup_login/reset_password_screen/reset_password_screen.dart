import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../theme/custom_button_style.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_text_form_field.dart';
import 'provider/reset_password_provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  ResetPasswordScreenState createState() => ResetPasswordScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ResetPasswordProvider(),
      child: ResetPasswordScreen(),
    );
  }
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
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
            left: 24.h,
            top: 12.h,
            right: 24.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                "Reset Password ",
                style: CustomTextStyles.headlineSmallBold,
              ),
              SizedBox(height: 8.h),
              Text(
                "Enter your new password twice below.",
                style: CustomTextStyles.bodyLargeBlack90016,
              ),
              SizedBox(height: 96.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Enter new password",
                  style: CustomTextStyles.bodyLargeBlack90016,
                ),
              ),
              SizedBox(height: 8.h),
              Consumer<ResetPasswordProvider>(
                builder: (context, provider, child) {
                  return CustomTextFormField(
                    controller: provider.newpasswordController,
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
              SizedBox(height: 12.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Re-enter new password",
                  style: CustomTextStyles.bodyLargeBlack90016,
                ),
              ),
              SizedBox(height: 8.h),
              Consumer<ResetPasswordProvider>(
                builder: (context, provider, child) {
                  return CustomTextFormField(
                    controller: provider.newpasswordoneController,
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
              SizedBox(height: 38.h),
              CustomElevatedButton(
                height: 48.h,
                text: " Reset Password",
                buttonStyle: CustomButtonStyles.fillPrimary,
                buttonTextStyle: theme.textTheme.titleMedium!,
              )
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
        imagePath: ImageConstant.imgArrowLeft,
        height: 20.h,
        width: 20.h,
        margin: EdgeInsets.only(left: 7.h),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
