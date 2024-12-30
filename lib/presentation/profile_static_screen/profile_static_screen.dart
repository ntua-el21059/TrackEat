import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../profile_screen/provider/profile_provider.dart';
import 'provider/profile_static_provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../../providers/profile_picture_provider.dart';
import '../../../providers/user_info_provider.dart';

class ProfileStaticScreen extends StatefulWidget {
  const ProfileStaticScreen({Key? key}) : super(key: key);

  @override
  ProfileStaticScreenState createState() => ProfileStaticScreenState();
}

class ProfileStaticScreenState extends State<ProfileStaticScreen> {
  // Add text controller
  final TextEditingController _textController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  void _showTextInputDialog(BuildContext context, String title, String currentValue, bool isNameField) {
    _textController.text = currentValue;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white.withOpacity(0.9),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16.h,
            right: 16.h,
            top: 16.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: _textController,
                autofocus: true,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Enter $title',
                  border: OutlineInputBorder(),
                ),
                // Only allow letters for name and surname
                inputFormatters: isNameField ? [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                ] : null,
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.h),
                  TextButton(
                    onPressed: () {
                      if (title == "Name") {
                        context.read<UserInfoProvider>().updateName(
                          _textController.text, 
                          context.read<UserInfoProvider>().lastName
                        );
                      } else if (title == "Surname") {
                        context.read<UserInfoProvider>().updateName(
                          context.read<UserInfoProvider>().firstName, 
                          _textController.text
                        );
                      } else if (title == "Username") {
                        context.read<UserInfoProvider>().updateUsername(_textController.text);
                      }
                      Provider.of<ProfileStaticProvider>(context, listen: false)
                          .updateValue(title, _textController.text);
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Save',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDatePicker(BuildContext context, String currentValue) {
    DateTime initialDate = DateTime.now();
    try {
      // Parse the current date if it exists
      List<String> parts = currentValue.split('/');
      if (parts.length == 3) {
        initialDate = DateTime(
          int.parse(parts[2]),  // year
          int.parse(parts[1]),  // month
          int.parse(parts[0]),  // day
        );
      }
    } catch (e) {
      // Use current date if parsing fails
      initialDate = DateTime.now();
    }

    showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),  // Can't select future dates
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    ).then((DateTime? date) {
      if (date != null) {
        String formattedDate = '${date.day.toString().padLeft(2, '0')}/'
            '${date.month.toString().padLeft(2, '0')}/'
            '${date.year.toString()}';
        
        Provider.of<ProfileStaticProvider>(context, listen: false)
            .updateValue('birthday', formattedDate);
      }
    });
  }

  void _showSexSelectionMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,  // White background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12.h),
        ),
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSexOption(context, "Light"),
            Divider(height: 1, color: Colors.grey[300]),
            _buildSexOption(context, "Moderate"),
            Divider(height: 1, color: Colors.grey[300]),
            _buildSexOption(context, "Vigorous"),
            Divider(height: 1, color: Colors.grey[300]),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 17.h,
                ),
              ),
            ),
            SizedBox(height: 8.h),  // Bottom padding for safe area
          ],
        );
      },
    );
  }

  Widget _buildSexOption(BuildContext context, String option) {
    final provider = Provider.of<ProfileStaticProvider>(context, listen: false);
    final isSelected = provider.getValue('sex').toLowerCase() == option.toLowerCase();

    return InkWell(
      onTap: () {
        provider.updateValue('sex', option);
        Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Text(
          option,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.blue : Colors.black,
            fontSize: 17.h,
          ),
        ),
      ),
    );
  }

  void _showHeightInputDialog(BuildContext context, String currentValue) {
    _textController.text = currentValue.replaceAll('cm', '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white.withOpacity(0.9),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16.h,
            right: 16.h,
            top: 16.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Height",
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: _textController,
                autofocus: true,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Enter height (100-251 cm)',
                  border: OutlineInputBorder(),
                  suffixText: 'cm',
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.h),
                  TextButton(
                    onPressed: () {
                      int? height = int.tryParse(_textController.text);
                      if (height != null && height >= 100 && height <= 251) {
                        Provider.of<ProfileStaticProvider>(context, listen: false)
                            .updateValue('height', '${height.toString()}cm');
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      'Save',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      // Update the profile picture using the provider
      context.read<ProfilePictureProvider>().updateProfilePicture(image.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.onErrorContainer,
      appBar: CustomAppBar(
        height: 38.h,
        leadingWidth: 24.h,
        leading: AppbarLeadingImage(
          imagePath: ImageConstant.imgArrowLeftPrimary,
          margin: EdgeInsets.only(left: 8.h),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: AppbarSubtitle(
          text: "Profile",
          margin: EdgeInsets.only(left: 7.h),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.h, top: 4.h, bottom: 4.h),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.accessibilitySettingsScreen);
              },
              child: CustomImageView(
                imagePath: ImageConstant.imgAccessibilityFill,
                height: 28.h,
                width: 28.h,
                color: theme.colorScheme.primary,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 4.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 16.h),
                Container(
                  width: double.maxFinite,
                  margin: EdgeInsets.symmetric(horizontal: 4.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.h,
                    vertical: 12.h,
                  ),
                  decoration: AppDecoration.lightBlueLayoutPadding.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder20,
                  ),
                  child: Column(
                    children: [
                      Consumer<ProfilePictureProvider>(
                        builder: (context, profilePicProvider, _) {
                          return Column(
                            children: [
                              CustomImageView(
                                imagePath: profilePicProvider.profileImagePath,
                                isFile: !profilePicProvider.profileImagePath.startsWith('assets/'),
                                height: 72.h,
                                width: 72.h,
                                radius: BorderRadius.circular(36.h),
                              ),
                              SizedBox(height: 8.h),
                              GestureDetector(
                                onTap: _pickImage,
                                child: Text(
                                  "Edit",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.h,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 16.h),
                      // Profile Details
                      _buildProfileItem("Name", Provider.of<ProfileStaticProvider>(context, listen: false).getValue("Name")),
                      _buildProfileItem("Surname", Provider.of<ProfileStaticProvider>(context, listen: false).getValue("Surname")),
                      _buildProfileItem("Birthday", "23/01/1993"),
                      _buildProfileItem("Sex", "Male"),
                      _buildProfileItem("Height", "180 cm"),
                      _buildProfileItem("Username", Provider.of<ProfileStaticProvider>(context, listen: false).getValue("Username")),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                // Sign out button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.h),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.welcomeScreen,
                          (route) => false,
                        );
                      },
                      child: Text(
                        "Sign out",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16.h,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    bool isEditable = ["Name", "Surname", "Username"].contains(label);
    bool isNameField = ["Name", "Surname"].contains(label);
    bool isBirthday = label == "Birthday";
    bool isSex = label == "Sex";
    bool isHeight = label == "Height";

    return Consumer<ProfileStaticProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              margin: EdgeInsets.symmetric(horizontal: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: isHeight
                      ? () => _showHeightInputDialog(context, provider.getValue('height'))
                      : isSex 
                        ? () => _showSexSelectionMenu(context)
                        : isBirthday 
                          ? () => _showDatePicker(context, provider.getValue(label))
                          : isEditable 
                            ? () => _showTextInputDialog(
                                context,
                                label,
                                provider.getValue(label),
                                isNameField,
                              ) 
                            : null,
                    child: Row(
                      children: [
                        Text(
                          isHeight
                            ? provider.getValue('height')
                            : isSex 
                              ? provider.getValue('sex')
                              : isBirthday 
                                ? provider.getValue('birthday')
                                : provider.getValue(label),
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8.h),
                        CustomImageView(
                          imagePath: ImageConstant.imgArrowRight,
                          height: 14.h,
                          width: 14.h,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (label != "Username")
              Container(
                height: 1.h,
                color: Colors.white,
                margin: EdgeInsets.symmetric(horizontal: 16.h),
              ),
          ],
        );
      },
    );
  }
}