import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../core/utils/app_utils.dart';
import '../../routes/app_routes.dart';
import '../../widgets/widgets.dart';
import 'create_account_provider.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CreateAccountProvider(),
      child: CreateAccountScreen(),
    );
  }

  @override
  CreateAccountScreenState createState() => CreateAccountScreenState();
}

class CreateAccountScreenState extends State<CreateAccountScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Form(
          key: _formKey,
          child: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.only(
                  left: 16.h,
                  top: 14.h,
                  right: 16.h,
                ),
                child: Column(
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.imgLogo,
                      height: 162.h,
                      width: double.maxFinite,
                      margin: EdgeInsets.only(
                        left: 80.h,
                        right: 78.h,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "msg_we_are_tremendously".tr,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: CustomTextStyles.bodyLargeBlack90017.copyWith(
                        height: 1.29,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    _buildUserInfoSection(context),
                    SizedBox(height: 38.h),
                    _buildNextButton(context),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: 58.h,
      leadingWidth: 31.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeft,
        margin: EdgeInsets.only(left: 7.h),
        onTap: () {
          onTapArrowleftone(context);
        },
      ),
      centerTitle: true,
      title: AppbarTitle(
        text: "lbl_trackeat".tr,
      ),
    );
  }

  Widget _buildUsernameInput(BuildContext context) {
    return Selector<CreateAccountProvider, TextEditingController?>(
      selector: (context, provider) => provider.usernameInputController,
      builder: (context, usernameInputController, child) {
        return CustomTextFormField(
          controller: usernameInputController,
          hintText: "lbl_timapple".tr,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.h,
            vertical: 12.h,
          ),
        );
      },
    );
  }

  /// Section Widget
  Widget _buildEmailInput(BuildContext context) {
    return Selector<CreateAccountProvider, TextEditingController?>(
      selector: (context, provider) => provider.emailInputController,
      builder: (context, emailInputController, child) {
        return CustomTextFormField(
          controller: emailInputController,
          hintText: "msg_appleseed_mail_com".tr,
          textInputType: TextInputType.emailAddress,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.h,
            vertical: 12.h,
          ),
          validator: (value) {
            if (value == null || (!isValidEmail(value, isRequired: true))) {
              return "err_msg_please_enter_valid_email".tr;
            }
            return null;
          },
        );
      },
    );
  }

  /// Section Widget
  Widget _buildPasswordInput(BuildContext context) {
    return Consumer<CreateAccountProvider>(
      builder: (context, provider, child) {
        return CustomTextFormField(
          controller: provider.passwordInputController,
          suffix: InkWell(
            onTap: () {
              provider.changePasswordVisibility();
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(16.h, 14.h, 8.h, 14.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  12.h,
                ),
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
          contentPadding: EdgeInsets.fromLTRB(16.h, 14.h, 8.h, 14.h),
        );
      },
    );
  }

  /// Section Widget
  Widget _buildReenterPasswordInput(BuildContext context) {
    return Consumer<CreateAccountProvider>(
      builder: (context, provider, child) {
        return CustomTextFormField(
          controller: provider.reenterPasswordInputController,
          textInputAction: TextInputAction.done,
          suffix: InkWell(
            onTap: () {
              provider.changePasswordVisibility1();
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(16.h, 14.h, 8.h, 14.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  12.h,
                ),
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
          contentPadding: EdgeInsets.fromLTRB(16.h, 14.h, 8.h, 14.h),
        );
      },
    );
  }

  /// Section Widget
  Widget _buildUserInfoSection(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "lbl_username".tr,
            style: theme.textTheme.bodyMedium,
          ),
          SizedBox(height: 10.h),
          _buildUsernameInput(context),
          SizedBox(height: 10.h),
          Text(
            "lbl_email".tr,
            style: theme.textTheme.titleSmall,
          ),
          SizedBox(height: 10.h),
          _buildEmailInput(context),
          SizedBox(height: 10.h),
          Text(
            "lbl_password".tr,
            style: theme.textTheme.bodyMedium,
          ),
          SizedBox(height: 10.h),
          _buildPasswordInput(context),
          SizedBox(height: 10.h),
          Text(
            "msg_re_enter_your_password".tr,
            style: theme.textTheme.titleSmall,
          ),
          SizedBox(height: 10.h),
          _buildReenterPasswordInput(context),
        ],
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return CustomElevatedButton(
      width: 114.h,
      text: "lbl_next".tr,
      margin: EdgeInsets.only(right: 6.h),
      onPressed: () {
        onTapNextButton(context);
      },
      alignment: Alignment.centerRight,
    );
  }

  /// Navigates to the previous screen.
  onTapArrowleftone(BuildContext context) {
    NavigatorService.goBack();
  }

  /// Navigates to the createProfile12Screen when the action is triggered.
  onTapNextButton(BuildContext context) {
    NavigatorService.pushNamed(
      AppRoutes.createProfile12Screen,
    );
  }
}
