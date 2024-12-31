import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../theme/custom_button_style.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../providers/user_provider.dart';
import 'models/create_profile_1_2_model.dart';
import 'provider/create_profile_1_2_provider.dart';
import 'package:provider/provider.dart';

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
              Text(
                "Let’s complete your profile (1/3)",
                style: theme.textTheme.headlineSmall,
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
              _buildGendertwo(context),
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
  Widget _buildGendertwo(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      child: Selector<CreateProfile12Provider, TextEditingController?>(
        selector: (context, provider) => provider.gendertwoController,
        builder: (context, gendertwoController, child) {
          return CustomTextFormField(
            readOnly: true,
            controller: gendertwoController,
            hintText: "Select Gender",
            hintStyle: CustomTextStyles.bodyLargeGray500,
            textInputAction: TextInputAction.done,
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Select Gender'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text('Male'),
                          onTap: () {
                            gendertwoController?.text = 'Male';
                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          title: Text('Female'),
                          onTap: () {
                            gendertwoController?.text = 'Female';
                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          title: Text('Non Binary'),
                          onTap: () {
                            gendertwoController?.text = 'Non Binary';
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            suffix: Container(
              margin: EdgeInsets.fromLTRB(16.h, 12.h, 10.h, 12.h),
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
            contentPadding: EdgeInsets.fromLTRB(16.h, 12.h, 10.h, 12.h),
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