import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../theme/custom_button_style.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_text_form_field.dart';
import 'models/forgot_password_model.dart';
import 'provider/forgot_password_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ForgotPasswordProvider(),
      child: ForgotPasswordScreen(),
    );
  }
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
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
          padding: EdgeInsets.symmetric(
            horizontal: 24.h,
            vertical: 14.h,
          ),
          child: Column(
            children: [
              Text(
                "Forgot Password ?",
                style: theme.textTheme.headlineSmall,
              ),
              SizedBox(height: 8.h),
              Text(
                "Enter your email, and we’ll help you \nget back into your account.",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  height: 1.38,
                  color: Colors.black87,
                ),
              ),
              Spacer(
                flex: 21,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Enter your email:",
                  style: CustomTextStyles.bodyLargeBlack90018,
                ),
              ),
              SizedBox(height: 8.h),
              Selector<ForgotPasswordProvider, TextEditingController?>(
                selector: (context, provider) => provider.emailController,
                builder: (context, emailController, child) {
                  return CustomTextFormField(
                    controller: emailController,
                    hintText: "hello@example.com",
                    hintStyle: CustomTextStyles.bodyLargeGray50003,
                    textInputAction: TextInputAction.done,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.h,
                      vertical: 12.h,
                    ),
                    borderDecoration:
                        TextFormFieldStyleHelper.outlineBlueGrayTL8,
                  );
                },
              ),
              SizedBox(height: 20.h),
              CustomElevatedButton(
                height: 48.h,
                text: "Continue",
                buttonStyle: CustomButtonStyles.fillPrimary,
                buttonTextStyle: theme.textTheme.titleMedium!,
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.resetPasswordScreen);
                },
              ),
              Spacer(
                flex: 78,
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
