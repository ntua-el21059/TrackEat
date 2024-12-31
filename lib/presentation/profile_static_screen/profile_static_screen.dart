import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../profile_screen/provider/profile_provider.dart';
import 'provider/profile_static_provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../../providers/profile_picture_provider.dart';
import '../../../providers/user_info_provider.dart';
import '../../services/firebase/auth/auth_provider.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  StreamSubscription<DocumentSnapshot>? _userSubscription;

  void _showTextInputDialog(BuildContext context, String title, String currentValue, bool isNameField) {
    // Get the current value from Firebase first
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser?.email != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser?.email)
          .get()
          .then((doc) {
        if (doc.exists) {
          final userData = doc.data()!;
          String dialogValue = '';
          
          switch (title) {
            case "Name":
              dialogValue = userData['firstName']?.toString() ?? '';
              break;
            case "Surname":
              dialogValue = userData['lastName']?.toString() ?? '';
              break;
            case "Username":
              dialogValue = userData['username']?.toString() ?? '';
              break;
            case "Birthday":
              dialogValue = userData['birthdate']?.toString() ?? '';
              break;
            case "Gender":
              dialogValue = userData['gender']?.toString() ?? '';
              break;
            case "Height":
              dialogValue = userData['height']?.toString() ?? '';
              break;
            default:
              dialogValue = currentValue;
          }
          
          // Set the text controller value
          _textController.text = dialogValue;

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
                    Text(title),
                    TextField(
                      controller: _textController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Enter $title',
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            final newValue = _textController.text.trim();
                            if (newValue.isNotEmpty) {
                              // Get current user email
                              if (currentUser?.email != null) {
                                try {
                                  // Update Firestore document using email as document ID
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(currentUser!.email)
                                      .update({
                                    if (title == "Name") 'firstName': newValue,
                                    if (title == "Surname") 'lastName': newValue,
                                    if (title == "Birthday") 'birthdate': newValue,
                                    if (title == "Gender") 'gender': newValue,
                                    if (title == "Height") 'height': newValue.replaceAll(" cm", ""),
                                    if (title == "Username") 'username': newValue,
                                  });

                                  // Update local provider
                                  if (mounted) {
                                    final userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
                                    switch (title) {
                                      case "Name":
                                        await userInfoProvider.updateName(newValue, userInfoProvider.lastName);
                                        break;
                                      case "Surname":
                                        await userInfoProvider.updateName(userInfoProvider.firstName, newValue);
                                        break;
                                      case "Birthday":
                                        await userInfoProvider.updateBirthdate(newValue);
                                        break;
                                      case "Gender":
                                        await userInfoProvider.updateGender(newValue);
                                        break;
                                      case "Height":
                                        await userInfoProvider.updateHeight(newValue.replaceAll(" cm", ""));
                                        break;
                                      case "Username":
                                        await userInfoProvider.updateUsername(newValue);
                                        break;
                                    }
                                    // Force UI update
                                    userInfoProvider.notifyListeners();
                                  }
                                } catch (e) {
                                  print("Error updating Firestore: $e");
                                }
                              }
                            }
                            if (mounted) {
                              Navigator.pop(context);
                            }
                          },
                          child: Text('Save'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        }
      });
    }
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

  void _showGenderSelector(BuildContext context, String currentValue) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white.withOpacity(0.9),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.h),
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
              // Male Button
              _buildGenderButton(
                context: context,
                label: "Male",
                currentValue: currentValue,
              ),
              SizedBox(height: 8.h),
              // Female Button
              _buildGenderButton(
                context: context,
                label: "Female",
                currentValue: currentValue,
              ),
              SizedBox(height: 8.h),
              // Non Binary Button
              _buildGenderButton(
                context: context,
                label: "Non Binary",
                currentValue: currentValue,
              ),
              SizedBox(height: 16.h),
            ],
          ),
        );
      },
    );
  }

  // Helper method to build gender selection buttons
  Widget _buildGenderButton({
    required BuildContext context,
    required String label,
    required String currentValue,
  }) {
    final isSelected = currentValue == label;
    
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.blue : Colors.grey[200],
          padding: EdgeInsets.symmetric(vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.h),
          ),
        ),
        onPressed: () async {
          // Get current user email
          final currentUser = FirebaseAuth.instance.currentUser;
          if (currentUser?.email != null) {
            try {
              // Update Firestore
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUser!.email)
                  .update({'gender': label});

              // Update local provider
              if (context.mounted) {
                final userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
                await userInfoProvider.updateGender(label);
                userInfoProvider.notifyListeners();
              }
            } catch (e) {
              print("Error updating gender: $e");
            }
          }
          if (context.mounted) {
            Navigator.pop(context);
          }
        },
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 16.h,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    
    // Fetch fresh data when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        final userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
        await userInfoProvider.fetchCurrentUser();
      }
    });
    _setupFirestoreListener();
  }

  void _setupFirestoreListener() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser?.email != null) {
      _userSubscription = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser?.email)
          .snapshots()
          .listen((snapshot) async {
        if (snapshot.exists && mounted) {
          final userData = snapshot.data()!;
          final userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
          
          // Update provider with fresh Firestore values
          await userInfoProvider.updateName(
            userData['firstName']?.toString() ?? '',
            userData['lastName']?.toString() ?? ''
          );
          
          userInfoProvider.updateUsername(userData['username']?.toString() ?? '');
          userInfoProvider.updateBirthdate(userData['birthdate']?.toString() ?? '');
          userInfoProvider.updateGender(userData['gender']?.toString() ?? '');
          userInfoProvider.updateHeight(userData['height']?.toString() ?? '');
          userInfoProvider.updateDailyCalories(userData['dailyCalories']?.toString() ?? '');
          
          // Force UI update
          setState(() {});
        }
      });
    }
  }

  @override
  void dispose() {
    // Cancel the subscription when the screen is disposed
    _userSubscription?.cancel();
    super.dispose();
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
        child: Consumer<UserInfoProvider>(
          builder: (context, userInfo, _) {
            return SingleChildScrollView(
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
                        // Profile Picture Section
                        Consumer<ProfilePictureProvider>(
                          builder: (context, profilePicProvider, _) {
                            return Column(
                              children: [
                                ClipOval(
                                  child: CustomImageView(
                                    imagePath: profilePicProvider.profileImagePath,
                                    isFile: !profilePicProvider.profileImagePath.startsWith('assets/'),
                                    height: 72.h,
                                    width: 72.h,
                                    radius: BorderRadius.circular(36.h),
                                  ),
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
                        _buildProfileItem(
                          label: "Name",
                          value: userInfo.firstName,
                          onTap: () => _showTextInputDialog(
                            context,
                            "Name",
                            userInfo.firstName,
                            true,
                          ),
                        ),
                        _buildProfileItem(
                          label: "Surname",
                          value: userInfo.lastName,
                          onTap: () => _showTextInputDialog(
                            context,
                            "Surname",
                            userInfo.lastName,
                            true,
                          ),
                        ),
                        _buildProfileItem(
                          label: "Birthday",
                          value: userInfo.birthdate,
                          onTap: () => _showTextInputDialog(
                            context,
                            "Birthday",
                            userInfo.birthdate,
                            false,
                          ),
                        ),
                        _buildProfileItem(
                          label: "Gender",
                          value: userInfo.gender,
                          onTap: () => _showGenderSelector(
                            context,
                            userInfo.gender,
                          ),
                        ),
                        _buildHeightSection(context, userInfo),
                        _buildProfileItem(
                          label: "Username",
                          value: userInfo.username,
                          onTap: () => _showTextInputDialog(
                            context,
                            "Username",
                            userInfo.username,
                            false,
                          ),
                        ),
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
                        onTap: () async {
                          final authProvider = Provider.of<auth.AuthProvider>(context, listen: false);
                          await authProvider.signOut(context);
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
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileItem({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
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
              Row(
                children: [
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser?.email)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null && snapshot.data!.exists) {
                        final userData = snapshot.data!.data() as Map<String, dynamic>;
                        String displayValue = value;
                        if (label == "Name") {
                          displayValue = userData['firstName']?.toString() ?? "Not set";
                        } else if (label == "Surname") {
                          displayValue = userData['lastName']?.toString() ?? "Not set";
                        } else if (label == "Username") {
                          displayValue = userData['username']?.toString() ?? "Not set";
                        }
                        return Text(
                          displayValue.isEmpty ? "Not set" : displayValue,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }
                      return Text(
                        value.isEmpty ? "Not set" : value,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 8.h),
                  GestureDetector(
                    onTap: onTap,
                    child: CustomImageView(
                      imagePath: ImageConstant.imgArrowRight,
                      height: 14.h,
                      width: 14.h,
                      color: Colors.white,
                    ),
                  ),
                ],
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
  }

  Widget _buildHeightSection(BuildContext context, UserInfoProvider userInfo) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          margin: EdgeInsets.symmetric(horizontal: 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Height",
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () => _showTextInputDialog(
                  context,
                  "Height",
                  "${userInfo.height} cm",
                  false,
                ),
                child: Row(
                  children: [
                    Text(
                      userInfo.height.isEmpty ? "Not set" : "${userInfo.height} cm",
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
        Container(
          height: 1.h,
          color: Colors.white,
          margin: EdgeInsets.symmetric(horizontal: 16.h),
        ),
      ],
    );
  }
}