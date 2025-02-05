import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../theme/custom_button_style.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/custom_checkbox_button.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../services/firebase/auth/auth_provider.dart' as auth;
import 'provider/login_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                  "Email Address",
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
                child: GestureDetector(
                  onTap: () {
                    NavigatorService.pushNamed(AppRoutes.forgotPasswordScreen);
                  },
                  child: Text(
                    "Forgot your Password ?",
                    style: CustomTextStyles.bodySmallPrimary,
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              _buildKeepmesignedin(context),
              SizedBox(height: 14.h),
              _buildLogintwo(context),
              SizedBox(height: 16.h),
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
        imagePath: ImageConstant.imgArrowLeftPrimary,
        height: 20.h,
        width: 20.h,
        margin: EdgeInsets.only(left: 7.h),
        onTap: () {
          Navigator.pop(context);
        },
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
      child: Consumer<LoginProvider>(
        builder: (context, provider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextFormField(
                controller: provider.userNameController,
                hintText: "hello@example.com",
                hintStyle: CustomTextStyles.bodyLargeGray50003,
                textInputType: TextInputType.emailAddress,
                contentPadding: EdgeInsets.fromLTRB(16.h, 12.h, 10.h, 12.h),
                borderDecoration: provider.emailError != null
                    ? TextFormFieldStyleHelper.outlineError
                    : TextFormFieldStyleHelper.outlineBlueGrayTL8,
              ),
              if (provider.emailError != null)
                Padding(
                  padding: EdgeInsets.only(top: 5.h, left: 16.h),
                  child: Text(
                    provider.emailError!,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12.h,
                    ),
                  ),
                ),
            ],
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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextFormField(
                controller: provider.passwordtwoController,
                hintText: "Enter password",
                textInputType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
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
                borderDecoration: provider.passwordError != null
                    ? TextFormFieldStyleHelper.outlineError
                    : TextFormFieldStyleHelper.outlineBlueGrayTL8,
              ),
              if (provider.passwordError != null)
                Padding(
                  padding: EdgeInsets.only(top: 5.h, left: 16.h),
                  child: Text(
                    provider.passwordError!,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12.h,
                    ),
                  ),
                ),
            ],
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
    return Consumer<LoginProvider>(
      builder: (context, provider, child) {
        return CustomElevatedButton(
          height: 48.h,
          text: provider.isLoading ? "Logging in..." : "Login",
          margin: EdgeInsets.only(
            left: 12.h,
            right: 10.h,
          ),
          buttonStyle: CustomButtonStyles.fillPrimary,
          buttonTextStyle: theme.textTheme.titleMedium!,
          onPressed: provider.isLoading ? null : () async {
            final authProvider = Provider.of<auth.AuthProvider>(context, listen: false);
            final email = provider.userNameController.text.trim();
            final password = provider.passwordtwoController.text;

            provider.setLoading(true);
            provider.clearErrors();

            try {
              final success = await authProvider.signIn(context, email, password);

              if (success && context.mounted) {
                if (provider.keepmesignedin!) {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('saved_email', email);
                  await provider.saveLoginState(email);
                }
                
                if (context.mounted) {
                  await Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.homeScreen,
                    (route) => false,
                  );
                }
              } else if (context.mounted) {
                String errorMessage = authProvider.lastError ?? 'Login failed';
                
                if (errorMessage.contains('Invalid email or password')) {
                  provider.setEmailError(errorMessage);
                  provider.setPasswordError(errorMessage);
                } else if (errorMessage.contains('No user found with this email')) {
                  provider.setEmailError(errorMessage);
                } else if (errorMessage.contains('Wrong password provided')) {
                  provider.setPasswordError(errorMessage);
                } else if (errorMessage.contains('The email address is not valid')) {
                  provider.setEmailError(errorMessage);
                } else {
                  provider.setEmailError(errorMessage);
                }
              }
            } finally {
              if (mounted) {
                provider.setLoading(false);
              }
            }
          },
        );
      },
    );
  }
}
