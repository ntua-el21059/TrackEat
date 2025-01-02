import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import '../../../../theme/custom_button_style.dart';
import '../../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../../widgets/app_bar/custom_app_bar.dart';
import '../../../../widgets/custom_elevated_button.dart';
import '../../../../widgets/custom_text_form_field.dart';
import '../../../../providers/user_provider.dart';
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
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    
    // Pre-fill data from UserProvider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<CreateAccountProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userProvider.user;
      
      if (user.username != null) provider.userNameController.text = user.username!;
      if (user.email != null) provider.emailtwoController.text = user.email!;
      if (user.password != null) {
        provider.passwordtwoController.text = user.password!;
        provider.passwordthreeController.text = user.password!;
      }
    });
  }

  @override
  void dispose() {
    _usernameFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
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
                top: 0.h,
                right: 22.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Transform.translate(
                    offset: Offset(0, -10),
                    child: Align(
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
                  ),
                  Transform.translate(
                    offset: Offset(0, -20),
                    child: CustomImageView(
                      imagePath: ImageConstant.imgLogo,
                      height: 162.h,
                      width: double.maxFinite,
                      margin: EdgeInsets.symmetric(horizontal: 72.h),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, -20),
                    child: Align(
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
                  ),
                  SizedBox(height: 6.h),
                  Padding(
                    padding: EdgeInsets.only(left: 2.h),
                    child: Text(
                      "Username",
                      style: CustomTextStyles.bodyMediumBlack,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  _buildUserName(context),
                  SizedBox(height: 8.h),
                  Padding(
                    padding: EdgeInsets.only(left: 2.h),
                    child: Text(
                      "Email",
                      style: CustomTextStyles.bodyMediumBlack,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  _buildEmailtwo(context),
                  SizedBox(height: 8.h),
                  Padding(
                    padding: EdgeInsets.only(left: 2.h),
                    child: Text(
                      "Password",
                      style: CustomTextStyles.bodyMediumBlack,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  _buildPasswordtwo(context),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.only(left: 2.h),
                    child: Text(
                      "Re-enter your password",
                      style: CustomTextStyles.bodyMediumBlack,
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
          NavigatorService.goBack();
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildUserName(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 2.h),
      child: Consumer<CreateAccountProvider>(
        builder: (context, provider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextFormField(
                focusNode: _usernameFocusNode,
                controller: provider.userNameController,
                hintText: "timapple",
                hintStyle: CustomTextStyles.bodyLargeGray200,
                textInputType: TextInputType.text,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.h,
                  vertical: 12.h,
                ),
                borderDecoration: provider.usernameError != null
                    ? OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(8),
                      )
                    : null,
                obscureText: false,
                onTap: () {
                  FocusScope.of(context).requestFocus(_usernameFocusNode);
                },
              ),
              if (provider.usernameError != null)
                Padding(
                  padding: EdgeInsets.only(top: 4.h, left: 4.h),
                  child: Text(
                    provider.usernameError!,
                    style: TextStyle(color: Colors.red, fontSize: 12.h),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildEmailtwo(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 2.h),
      child: Consumer<CreateAccountProvider>(
        builder: (context, provider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextFormField(
                focusNode: _emailFocusNode,
                controller: provider.emailtwoController,
                hintText: "Appleseed@mail.com",
                hintStyle: CustomTextStyles.bodyLargeGray200,
                textInputType: TextInputType.emailAddress,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.h,
                  vertical: 12.h,
                ),
                borderDecoration: provider.emailError != null
                    ? OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(8),
                      )
                    : null,
                obscureText: false,
                onTap: () {
                  FocusScope.of(context).requestFocus(_emailFocusNode);
                },
              ),
              if (provider.emailError != null)
                Padding(
                  padding: EdgeInsets.only(top: 4.h, left: 4.h),
                  child: Text(
                    provider.emailError!,
                    style: TextStyle(color: Colors.red, fontSize: 12.h),
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
      padding: EdgeInsets.only(left: 2.h),
      child: Consumer<CreateAccountProvider>(
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
                    margin: EdgeInsets.fromLTRB(16.h, 8.h, 10.h, 8.h),
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
                    ? OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(8),
                      )
                    : null,
              ),
              if (provider.passwordError != null)
                Padding(
                  padding: EdgeInsets.only(top: 4.h, left: 4.h),
                  child: Text(
                    provider.passwordError!,
                    style: TextStyle(color: Colors.red, fontSize: 12.h),
                  ),
                ),
            ],
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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextFormField(
                controller: provider.passwordthreeController,
                hintText: "Re-enter password",
                textInputType: TextInputType.visiblePassword,
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
                borderDecoration: provider.reenterPasswordError != null
                    ? OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(8),
                      )
                    : null,
              ),
              if (provider.reenterPasswordError != null)
                Padding(
                  padding: EdgeInsets.only(top: 4.h, left: 4.h),
                  child: Text(
                    provider.reenterPasswordError!,
                    style: TextStyle(color: Colors.red, fontSize: 12.h),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  /// Next Button
  Widget _buildNext(BuildContext context) {
    return Consumer<CreateAccountProvider>(
      builder: (context, provider, child) {
        bool isFormValid = provider.userNameController.text.isNotEmpty &&
            provider.emailtwoController.text.isNotEmpty &&
            provider.passwordtwoController.text.isNotEmpty &&
            provider.passwordthreeController.text.isNotEmpty &&
            provider.usernameError == null &&
            provider.emailError == null &&
            provider.passwordError == null;

        return CustomElevatedButton(
          height: 48.h,
          width: 114.h,
          text: "Next",
          buttonStyle: isFormValid 
              ? CustomButtonStyles.fillPrimary
              : CustomButtonStyles.fillGray,
          buttonTextStyle: theme.textTheme.titleMedium!,
          alignment: Alignment.centerRight,
          onPressed: isFormValid ? () async {
            // Clear previous errors
            provider.clearErrors();

            // Validate passwords match
            if (provider.passwordtwoController.text != provider.passwordthreeController.text) {
              provider.setPasswordError("Passwords do not match");
              return;
            }

            // Save to UserProvider
            final userProvider = Provider.of<UserProvider>(context, listen: false);
            userProvider.setAccountInfo(
              username: provider.userNameController.text,
              email: provider.emailtwoController.text,
              password: provider.passwordtwoController.text,
            );
            
            NavigatorService.pushNamed(AppRoutes.createProfile12Screen);
          } : null,
        );
      },
    );
  }
}