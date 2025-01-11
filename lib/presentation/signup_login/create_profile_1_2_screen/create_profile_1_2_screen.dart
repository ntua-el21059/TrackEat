import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
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
  final FocusNode _heightFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Pre-fill data from UserProvider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<CreateProfile12Provider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userProvider.user;

      if (user.firstName != null)
        provider.firstNameController.text = user.firstName!;
      if (user.lastName != null)
        provider.lastNameController.text = user.lastName!;
      if (user.birthdate != null)
        provider.dateController.text = user.birthdate!;
      if (user.gender != null) 
        provider.gendertwoController.text = user.gender!;
      if (user.height != null && user.height! > 0)
        provider.heightController.text = user.height!.toInt().toString();
    });
  }

  @override
  void dispose() {
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _heightFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardOpen = bottomPadding > 0;
    
    return Scaffold(
      backgroundColor: theme.colorScheme.onErrorContainer,
      resizeToAvoidBottomInset: true,
      appBar: _buildAppbar(context),
      body: SafeArea(
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 14.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: isKeyboardOpen ? ClampingScrollPhysics() : NeverScrollableScrollPhysics(),
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
                      _buildFormFields(),
                    ],
                  ),
                ),
              ),
              _buildNext(context),
              SizedBox(height: 48.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel("First name"),
        SizedBox(height: 8.h),
        _buildFirstName(context),
        SizedBox(height: 8.h),
        _buildFieldLabel("Last name"),
        SizedBox(height: 8.h),
        _buildLastName(context),
        SizedBox(height: 8.h),
        _buildFieldLabel("Birthdate"),
        SizedBox(height: 8.h),
        _buildDate(context),
        SizedBox(height: 8.h),
        _buildFieldLabel("Gender"),
        SizedBox(height: 8.h),
        _buildGender(context),
        SizedBox(height: 8.h),
        _buildFieldLabel("Height (cm)"),
        SizedBox(height: 8.h),
        _buildHeight(context),
      ],
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(left: 8.h),
      child: Text(
        label,
        style: CustomTextStyles.titleSmallBlack90015,
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
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: CupertinoColors.white,
                  enableDrag: true,
                  isDismissible: true,
                  useRootNavigator: true,
                  barrierColor: Colors.black.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  ),
                  builder: (BuildContext context) {
                    DateTime selectedDate = DateTime.now().subtract(Duration(days: 365 * 18));
                    try {
                      if (dateController?.text.isNotEmpty ?? false) {
                        List<String> parts = dateController!.text.split('/');
                        if (parts.length == 3) {
                          selectedDate = DateTime(
                            int.parse(parts[2]),  // year
                            int.parse(parts[1]),  // month
                            int.parse(parts[0]),  // day
                          );
                        }
                      }
                    } catch (e) {
                      print("Error parsing date: $e");
                    }
                    
                    return Container(
                      height: 320,
                      padding: EdgeInsets.only(top: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: CupertinoColors.white,
                              border: Border(
                                bottom: BorderSide(
                                  color: CupertinoColors.systemGrey5,
                                  width: 0.5,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CupertinoButton(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Cancel', style: TextStyle(color: Color(0xFF4A90E2))),
                                ),
                                CupertinoButton(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  onPressed: () {
                                    String formattedDate = "${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}";
                                    dateController?.text = formattedDate;
                                    Navigator.pop(context);
                                  },
                                  child: Text('Save', style: TextStyle(color: Color(0xFF4A90E2))),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.date,
                              initialDateTime: selectedDate,
                              maximumDate: DateTime.now(),
                              minimumYear: 1900,
                              maximumYear: DateTime.now().year,
                              onDateTimeChanged: (DateTime newDate) {
                                selectedDate = newDate;
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().subtract(Duration(days: 365 * 18)),
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
            textInputAction: TextInputAction.next,
            suffix: Icon(
              Icons.arrow_forward_ios,
              size: 20.h,
              color: appTheme.blueGray100,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 12.h,
            ),
            textStyle: CustomTextStyles.bodyLargeGray900,
            onTap: () {
              if (Platform.isIOS) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: CupertinoColors.white,
                  enableDrag: true,
                  isDismissible: true,
                  useRootNavigator: true,
                  barrierColor: Colors.black.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  ),
                  builder: (BuildContext context) {
                    String selectedGender = provider.gendertwoController.text.isEmpty ? 'Male' : provider.gendertwoController.text;
                    return Container(
                      height: 320,
                      padding: EdgeInsets.only(top: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: CupertinoColors.white,
                              border: Border(
                                bottom: BorderSide(
                                  color: CupertinoColors.systemGrey5,
                                  width: 0.5,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CupertinoButton(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Cancel', style: TextStyle(color: Color(0xFF4A90E2))),
                                ),
                                CupertinoButton(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  onPressed: () {
                                    provider.gendertwoController.text = selectedGender;
                                    Navigator.pop(context);
                                  },
                                  child: Text('Save', style: TextStyle(color: Color(0xFF4A90E2))),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: CupertinoPicker(
                              scrollController: FixedExtentScrollController(
                                initialItem: genderOptions.indexOf(selectedGender),
                              ),
                              itemExtent: 44,
                              onSelectedItemChanged: (int index) {
                                selectedGender = genderOptions[index];
                              },
                              children: genderOptions.map((gender) => 
                                Center(
                                  child: Text(
                                    gender,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: CupertinoColors.black,
                                    ),
                                  ),
                                )
                              ).toList(),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  ),
                  builder: (BuildContext context) {
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Select Gender",
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          ...genderOptions.map((gender) => ListTile(
                            title: Text(
                              gender,
                              style: CustomTextStyles.bodyLargeBlack90018,
                              textAlign: TextAlign.center,
                            ),
                            tileColor: gender == provider.gendertwoController.text ? Colors.blue.withOpacity(0.1) : null,
                            onTap: () {
                              provider.gendertwoController.text = gender;
                              Navigator.pop(context);
                            },
                          )).toList(),
                          SizedBox(height: 8.h),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 16.h,
                                color: Colors.blue,
                              ),
                            ),
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

  /// Height Field
  Widget _buildHeight(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      child: Consumer<CreateProfile12Provider>(
        builder: (context, provider, child) {
          return CustomTextFormField(
            focusNode: _heightFocusNode,
            controller: provider.heightController,
            hintText: "Enter height",
            hintStyle: CustomTextStyles.bodyLargeGray500,
            textInputType: TextInputType.number,
            textInputAction: TextInputAction.done,
            textStyle: CustomTextStyles.bodyLargeGray900,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 12.h,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
            ],
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
            provider.gendertwoController.text.isNotEmpty &&
            provider.heightController.text.isNotEmpty &&
            double.tryParse(provider.heightController.text) != null;

        return CustomElevatedButton(
          height: 48.h,
          width: 114.h,
          text: "Next",
          buttonStyle: isFormValid
              ? CustomButtonStyles.fillPrimary
              : CustomButtonStyles.fillGray,
          buttonTextStyle: theme.textTheme.titleMedium!,
          alignment: Alignment.centerRight,
          onPressed: isFormValid
              ? () {
                  // Save to UserProvider
                  final userProvider =
                      Provider.of<UserProvider>(context, listen: false);
                  userProvider.setProfile1Info(
                    firstName: provider.firstNameController.text,
                    lastName: provider.lastNameController.text,
                    birthdate: provider.dateController.text,
                    gender: provider.gendertwoController.text,
                    height: double.tryParse(provider.heightController.text) ?? 0,
                  );

                  NavigatorService.pushNamed(AppRoutes.createProfile22Screen);
                }
              : null,
        );
      },
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
}
