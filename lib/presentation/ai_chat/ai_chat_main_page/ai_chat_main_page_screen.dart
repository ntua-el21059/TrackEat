import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import '../../../../theme/custom_button_style.dart';
import '../../../../widgets/custom_bottom_bar.dart';
import '../../../../widgets/custom_elevated_button.dart';
import '../../../../widgets/custom_text_form_field.dart';
import 'models/ai_chat_main_page_model.dart';
import 'provider/ai_chat_main_page_provider.dart';

class AiChatMainScreen extends StatefulWidget {
  const AiChatMainScreen({Key? key}) : super(key: key);

  @override
  AiChatMainScreenState createState() => AiChatMainScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AiChatMainProvider(),
      child: AiChatMainScreen(),
    );
  }
}

// ignore_for_file: must_be_immutable
class AiChatMainScreenState extends State<AiChatMainScreen> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.cyan900,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          height: SizeUtils.height,
          width: double.maxFinite,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgSirianimationshaky852x392,
                height: SizeUtils.height,
                width: double.maxFinite,
                alignment: Alignment.centerLeft,
              ),
              Container(
                width: double.maxFinite,
                margin: EdgeInsets.symmetric(horizontal: 20.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.imgInfo,
                      height: 28.h,
                      width: 30.h,
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.only(right: 20.h),
                    ),
                    SizedBox(height: 24.h),
                    SizedBox(
                      width: 234.h,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "What can I help\nyou with?",
                              style: CustomTextStyles.headlineLargeLight,
                            ),
                            TextSpan(
                              text: " ",
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2147483647,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 36.h),
                    CustomImageView(
                      imagePath: ImageConstant.imgSiriGraph,
                      height: 46.h,
                      width: double.maxFinite,
                      margin: EdgeInsets.symmetric(horizontal: 20.h),
                    ),
                    Spacer(),
                    _buildRowspeakto(context),
                    SizedBox(height: 14.h),
                    Selector<AiChatMainProvider, TextEditingController?>(
                      selector: (context, provider) => provider.messageController,
                      builder: (context, messageController, child) {
                        return CustomTextFormField(
                          controller: messageController,
                          hintText: "Message TrackEat - AI",
                          hintStyle: CustomTextStyles.titleMediumGray400,
                          textInputAction: TextInputAction.done,
                          suffix: Container(
                            padding: EdgeInsets.all(14.h),
                            margin: EdgeInsets.fromLTRB(16.h, 18.h, 24.h, 18.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22.h),
                              gradient: LinearGradient(
                                begin: Alignment(0.5, 0),
                                end: Alignment(0.5, 1),
                                colors: [
                                  appTheme.lightBlue300,
                                  theme.colorScheme.primary,
                                ],
                              ),
                            ),
                            child: CustomImageView(
                              imagePath: ImageConstant.imgArrowIcon,
                              height: 16.h,
                              width: 16.h,
                              fit: BoxFit.contain,
                            ),
                          ),
                          suffixConstraints: BoxConstraints(
                            maxHeight: 54.h,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 24.h,
                            vertical: 16.h,
                          ),
                          fillColor: appTheme.gray5001,
                          filled: true,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        width: double.maxFinite,
        child: _buildBottombar(context),
      ),
    );
  }

  /// Section Widget
  Widget _buildRowspeakto(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        children: [
          Expanded(
            child: CustomElevatedButton(
              height: 44.h,
              text: "Speak to TrackEat - AI",
              rightIcon: Container(
                margin: EdgeInsets.only(left: 16.h),
                child: CustomImageView(
                  imagePath: ImageConstant.imgSpeakingIcon,
                  height: 32.h,
                  width: 24.h,
                  fit: BoxFit.contain,
                ),
              ),
              buttonStyle: CustomButtonStyles.none,
              decoration: CustomButtonStyles.gradientLightBlueToPrimaryDecoration,
              buttonTextStyle: CustomTextStyles.labelMediumOnErrorContainer,
            ),
          ),
          SizedBox(width: 8.h),
          Expanded(
            child: CustomElevatedButton(
              height: 44.h,
              text: "SnapEat",
              rightIcon: Container(
                margin: EdgeInsets.only(left: 30.h),
                child: CustomImageView(
                  imagePath: ImageConstant.imgCameraIcon,
                  height: 30.h,
                  width: 34.h,
                  fit: BoxFit.contain,
                ),
              ),
              buttonStyle: CustomButtonStyles.none,
              decoration: CustomButtonStyles.gradientLightBlueToPrimaryDecoration,
              buttonTextStyle: CustomTextStyles.labelMediumOnErrorContainer,
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildBottombar(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: CustomBottomBar(
        onChanged: (BottomBarEnum type) {
          Navigator.pushNamed(
              navigatorKey.currentContext!, getCurrentRoute(type));
        },
      ),
    );
  }

  /// Handling route based on bottom click actions
  String getCurrentRoute(BottomBarEnum type) {
    switch (type) {
      case BottomBarEnum.Home:
        return AppRoutes.homeScreen;
      case BottomBarEnum.Leaderboard:
        return "/leaderboard";
      case BottomBarEnum.AI:
        return AppRoutes.aiChatSplashScreen;
      default:
        return "/";
    }
  }
}