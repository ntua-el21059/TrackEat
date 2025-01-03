import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_floating_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'models/social_profile_message_from_profile_model.dart';
import 'provider/social_profile_message_from_profile_provider.dart';

class SocialProfileMessageFromProfileScreen extends StatefulWidget {
  const SocialProfileMessageFromProfileScreen({Key? key}) : super(key: key);

  @override
  SocialProfileMessageFromProfileScreenState createState() =>
      SocialProfileMessageFromProfileScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SocialProfileMessageFromProfileProvider(),
      child: const SocialProfileMessageFromProfileScreen(),
    );
  }
}

class SocialProfileMessageFromProfileScreenState
    extends State<SocialProfileMessageFromProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.onErrorContainer,
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(context),
      body: SafeArea(
        top: false,
        child: Container(
          height: 744.h,
          width: double.maxFinite,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: double.maxFinite,
                decoration: AppDecoration.outlineBlack.copyWith(
                  borderRadius: BorderRadiusStyle.roundedBorder54,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 60.h),
                    Text(
                      "Nancy Reagan",
                      style: CustomTextStyles.titleLargeGray800,
                    ),
                    Text(
                      "@nancy_reagan",
                      style: CustomTextStyles.bodyMediumGray800,
                    ),
                    SizedBox(height: 16.h),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Today",
                            style: CustomTextStyles.labelMediumGray50004,
                          ),
                          TextSpan(
                            text: " 3:25 PM",
                            style: CustomTextStyles.bodySmallGray50004,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const Spacer(),
                    _buildMessageColumn(context),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: 66.h,
                  width: 72.h,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.imgVectorOnerrorcontainer,
                        height: 66.h,
                        width: double.maxFinite,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  /// Builds the AppBar widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: 54.h,
      leadingWidth: 23.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftPrimary,
        margin: EdgeInsets.only(left: 7.h),
      ),
      title: AppbarSubtitle(
        text: "Profile",
        margin: EdgeInsets.only(left: 7.h),
      ),
    );
  }

  /// Builds the message input column
  Widget _buildMessageColumn(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 18.h),
      decoration: AppDecoration.graysWhite.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(16.h),
            decoration: AppDecoration.lightThemePrimarySurface.copyWith(
              borderRadius: BorderRadiusStyle.circleBorder38,
            ),
            width: double.maxFinite,
            child: Row(
              children: [
                Selector<SocialProfileMessageFromProfileProvider,
                    TextEditingController?>(
                  selector: (context, provider) => provider.messageoneController,
                  builder: (context, messageOneController, child) {
                    return CustomTextFormField(
                      width: 272.h,
                      controller: messageOneController,
                      hintText: "Message",
                      textInputAction: TextInputAction.done,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.h,
                        vertical: 12.h,
                      ),
                      borderDecoration:
                          TextFormFieldStyleHelper.fillOnErrorContainer,
                      filled: true,
                      fillColor: theme.colorScheme.onErrorContainer,
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  /// Builds the floating action button
  Widget _buildFloatingActionButton(BuildContext context) {
    return CustomFloatingButton(
      height: 40,
      width: 40,
      backgroundColor: theme.colorScheme.primary,
      child: CustomImageView(
        imagePath: ImageConstant.imgArrowRightOnerrorcontainer,
        height: 20.0.h,
        width: 20.0.h,
      ),
    );
  }
}