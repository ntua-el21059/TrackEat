import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../routes/app_routes.dart';
import '../widgets.dart';
import 'create_profile_1_2_provider.dart';

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
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _buildAppbar(context),
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: Column(
            children: [
              Text(
                "msg_let_s_complete_your".tr,
                style: theme.textTheme.headlineSmall,
              ),
              SizedBox(height: 18.h),
              Text(
                "msg_please_fill_in_your".tr,
                style: theme.textTheme.titleLarge,
              ),
              SizedBox(height: 26.h),
              _buildProfileDetailsSection(context),
              Spacer(),
              _buildNextButton(context),
              SizedBox(height: 48.h),
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
        imagePath: ImageConstant.imgArrowLeft,
        margin: EdgeInsets.only(left: 7.h),
        onTap: () {
          onTapArrowleftone(context);
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildFirstNameInput(BuildContext context) {
    return Selector<CreateProfile12Provider, TextEditingController?>(
      selector: (context, provider) => provider.firstNameInputController,
      builder: (context, firstNameInputController, child) {
        return CustomTextFormField(
          controller: firstNameInputController,
          hintText: "lbl_john".tr,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.h,
            vertical: 12.h,
          ),
        );
      },
    );
  }

  /// Section Widget
  Widget _buildLastNameInput(BuildContext context) {
    return Selector<CreateProfile12Provider, TextEditingController?>(
      selector: (context, provider) => provider.lastNameInputController,
      builder: (context, lastNameInputController, child) {
        return CustomTextFormField(
          controller: lastNameInputController,
          hintText: "lbl_appleseed".tr,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.h,
            vertical: 12.h,
          ),
        );
      },
    );
  }

  /// Section Widget
  Widget _buildBirthdateInput(BuildContext context) {
    return Selector<CreateProfile12Provider, TextEditingController?>(
      selector: (context, provider) => provider.birthdateInputController,
      builder: (context, birthdateInputController, child) {
        return CustomTextFormField(
          readOnly: true,
          controller: birthdateInputController,
          hintText: "lbl_01_01_2000".tr,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.h,
            vertical: 12.h,
          ),
          onTap: () {
            onTapBirthdateInput(context);
          },
        );
      },
    );
  }

  /// Section Widget
  Widget _buildGenderInput(BuildContext context) {
    return Selector<CreateProfile12Provider, TextEditingController?>(
      selector: (context, provider) => provider.genderInputController,
      builder: (context, genderInputController, child) {
        return CustomTextFormField(
          controller: genderInputController,
          hintText: "lbl_male".tr,
          textInputAction: TextInputAction.done,
          suffix: Container(
            margin: EdgeInsets.fromLTRB(16.h, 14.h, 8.h, 14.h),
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
          contentPadding: EdgeInsets.fromLTRB(16.h, 14.h, 8.h, 14.h),
        );
      },
    );
  }

  /// Section Widget
  Widget _buildProfileDetailsSection(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "lbl_first_name".tr,
            style: theme.textTheme.titleSmall,
          ),
          SizedBox(height: 8.h),
          _buildFirstNameInput(context),
          SizedBox(height: 8.h),
          Text(
            "lbl_last_name".tr,
            style: theme.textTheme.titleSmall,
          ),
          SizedBox(height: 8.h),
          _buildLastNameInput(context),
          SizedBox(height: 8.h),
          Text(
            "lbl_birthdate".tr,
            style: theme.textTheme.titleSmall,
          ),
          SizedBox(height: 8.h),
          _buildBirthdateInput(context),
          SizedBox(height: 8.h),
          Text(
            "lbl_gender".tr,
            style: theme.textTheme.titleSmall,
          ),
          SizedBox(height: 8.h),
          _buildGenderInput(context),
        ],
      ),
    );
  }

  /// Section Widget
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
  void onTapArrowleftone(BuildContext context) {
    NavigatorService.goBack();
  }

  /// Displays a date picker dialog and updates the selected date in the
  /// [createProfile12ModelObj] object of the current [birthdateInputController] if the user
  /// selects a valid date.
  Future<void> onTapBirthdateInput(BuildContext context) async {
    DateTime? dateTime = await showDatePicker(
        context: context,
        initialDate: context
                .read<CreateProfile12Provider>()
                .createProfile12ModelObj
                .selectedBirthdateInput ??
            DateTime.now(),
        firstDate: DateTime(1970),
        lastDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day));
    if (dateTime != null) {
      context
          .read<CreateProfile12Provider>()
          .createProfile12ModelObj
          .selectedBirthdateInput = dateTime;
      context.read<CreateProfile12Provider>().birthdateInputController.text =
          dateTime.format(pattern: D_M_Y);
    }
  }

  /// Navigates to the createProfile22Screen when the action is triggered.
  void onTapNextButton(BuildContext context) {
    NavigatorService.pushNamed(
      AppRoutes.createProfile22Screen,
    );
  }
}
