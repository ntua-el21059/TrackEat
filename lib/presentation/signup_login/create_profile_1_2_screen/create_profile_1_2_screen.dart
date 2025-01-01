import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import '../../../core/app_export.dart';
import '../../../theme/custom_button_style.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../providers/user_provider.dart';
import 'provider/create_profile_1_2_provider.dart';

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
  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    
    // Pre-fill data from UserProvider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<CreateProfile12Provider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userProvider.user;
      
      if (user.firstName != null) provider.firstNameController.text = user.firstName!;
      if (user.lastName != null) provider.lastNameController.text = user.lastName!;
      if (user.birthdate != null) provider.dateController.text = user.birthdate!;
      if (user.gender != null) provider.gendertwoController.text = user.gender!;
    });
  }

  @override
  void dispose() {
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    super.dispose();
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
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: Column(
            children: [
              SizedBox(height: 12.h),
              Text(
                "Let's complete your profile (1/3)",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontSize: 22.0,
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                "Please fill in your details. ",
                style: CustomTextStyles.titleLargeBlack900,
              ),
              SizedBox(height: 26.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 8.h),
                  child: Text(
                    "First name",
                    style: CustomTextStyles.titleSmallBlack90015,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              _buildFirstName(context),
              SizedBox(height: 8.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 8.h),
                  child: Text(
                    "Last name",
                    style: CustomTextStyles.titleSmallBlack90015,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              _buildLastName(context),
              SizedBox(height: 8.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 8.h),
                  child: Text(
                    "Birthdate ",
                    style: CustomTextStyles.titleSmallBlack90015,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              _buildDate(context),
              SizedBox(height: 8.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 8.h),
                  child: Text(
                    "Gender",
                    style: CustomTextStyles.titleSmallBlack90015,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              _buildGender(context),
              Spacer(),
              _buildNext(context),
              SizedBox(height: 48.h),
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

  /// First Name Field
  Widget _buildFirstName(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      child: Consumer<CreateProfile12Provider>(
        builder: (context, provider, child) {
          return CustomTextFormField(
            focusNode: _firstNameFocusNode,
            controller: provider.firstNameController,
            hintText: "John",
            hintStyle: CustomTextStyles.bodyLargeGray500,
            textInputType: TextInputType.name,
            textInputAction: TextInputAction.next,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 12.h,
            ),
            onTap: () {
              FocusScope.of(context).requestFocus(_firstNameFocusNode);
            },
          );
        },
      ),
    );
  }

  /// Last Name Field
  Widget _buildLastName(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      child: Consumer<CreateProfile12Provider>(
        builder: (context, provider, child) {
          return CustomTextFormField(
            focusNode: _lastNameFocusNode,
            controller: provider.lastNameController,
            hintText: "Appleseed",
            hintStyle: CustomTextStyles.bodyLargeGray500,
            textInputType: TextInputType.name,
            textInputAction: TextInputAction.next,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 12.h,
            ),
            onTap: () {
              FocusScope.of(context).requestFocus(_lastNameFocusNode);
            },
          );
        },
      ),
    );
  }

  /// Birthdate Field
  Widget _buildDate(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      child: Selector<CreateProfile12Provider, TextEditingController?>(
        selector: (context, provider) => provider.dateController,
        builder: (context, dateController, child) {
          return CustomTextFormField(
            readOnly: true,
            controller: dateController,
            hintText: "01/01/2000",
            hintStyle: CustomTextStyles.bodyLargeGray500,
            onTap: () async {
              if (Platform.isIOS) {
                showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 216,
                      padding: const EdgeInsets.only(top: 6.0),
                      margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      color: CupertinoColors.systemBackground.resolveFrom(context),
                      child: SafeArea(
                        top: false,
                        child: CupertinoDatePicker(
                          initialDateTime: DateTime.now(),
                          maximumDate: DateTime.now(),
                          minimumYear: 1900,
                          maximumYear: DateTime.now().year,
                          mode: CupertinoDatePickerMode.date,
                          onDateTimeChanged: (DateTime newDate) {
                            dateController?.text = 
                              "${newDate.day.toString().padLeft(2, '0')}/"
                              "${newDate.month.toString().padLeft(2, '0')}/"
                              "${newDate.year}";
                          },
                          backgroundColor: CupertinoColors.systemBackground,
                          itemExtent: 44.0,
                        ),
                      ),
                    );
                  },
                );
              } else {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                
                if (pickedDate != null) {
                  dateController?.text = 
                    "${pickedDate.day.toString().padLeft(2, '0')}/"
                    "${pickedDate.month.toString().padLeft(2, '0')}/"
                    "${pickedDate.year}";
                }
              }
            },
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 12.h,
            ),
          );
        },
      ),
    );
  }

  /// Gender Field
  Widget _buildGender(BuildContext context) {
    final genderOptions = ['Male', 'Female', 'Non Binary'];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      child: Consumer<CreateProfile12Provider>(
        builder: (context, provider, child) {
          return CustomTextFormField(
            readOnly: true,
            controller: provider.gendertwoController,
            hintText: "Select gender",
            hintStyle: CustomTextStyles.bodyLargeGray500,
            textInputType: TextInputType.text,
            suffix: Icon(
              Icons.arrow_forward_ios,
              size: 20.h,
              color: appTheme.blueGray100,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 12.h,
            ),
            onTap: () {
              if (Platform.isIOS) {
                showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 216,
                      padding: const EdgeInsets.only(top: 6.0),
                      margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      color: CupertinoColors.systemBackground.resolveFrom(context),
                      child: SafeArea(
                        top: false,
                        child: CupertinoPicker(
                          itemExtent: 44.0,
                          onSelectedItemChanged: (int index) {
                            provider.gendertwoController.text = genderOptions[index];
                          },
                          children: genderOptions.map((gender) => 
                            Text(
                              gender,
                              style: TextStyle(
                                fontSize: 20,
                                color: CupertinoColors.black,
                              ),
                            )
                          ).toList(),
                        ),
                      ),
                    );
                  },
                );
              } else {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: Text(
                              'Male',
                              style: CustomTextStyles.bodyLargeBlack90018,
                            ),
                            onTap: () {
                              provider.gendertwoController.text = 'Male';
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: Text(
                              'Female',
                              style: CustomTextStyles.bodyLargeBlack90018,
                            ),
                            onTap: () {
                              provider.gendertwoController.text = 'Female';
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: Text(
                              'Non Binary',
                              style: CustomTextStyles.bodyLargeBlack90018,
                            ),
                            onTap: () {
                              provider.gendertwoController.text = 'Non Binary';
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }

  /// Next Button
  Widget _buildNext(BuildContext context) {
    return Consumer<CreateProfile12Provider>(
      builder: (context, provider, child) {
        bool isFormValid = provider.firstNameController.text.isNotEmpty &&
            provider.lastNameController.text.isNotEmpty &&
            provider.dateController.text.isNotEmpty &&
            provider.gendertwoController.text.isNotEmpty;

        return CustomElevatedButton(
          height: 48.h,
          width: 114.h,
          text: "Next",
          buttonStyle: isFormValid 
              ? CustomButtonStyles.fillPrimary
              : CustomButtonStyles.fillGray,
          buttonTextStyle: theme.textTheme.titleMedium!,
          alignment: Alignment.centerRight,
          onPressed: isFormValid ? () {
            // Save to UserProvider
            final userProvider = Provider.of<UserProvider>(context, listen: false);
            userProvider.setProfile1Info(
              firstName: provider.firstNameController.text,
              lastName: provider.lastNameController.text,
              birthdate: provider.dateController.text,
              gender: provider.gendertwoController.text,
            );
            
            NavigatorService.pushNamed(AppRoutes.createProfile22Screen);
          } : null,
        );
      },
    );
  }
}