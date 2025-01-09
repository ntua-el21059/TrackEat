import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'dart:convert';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import '../../../providers/profile_picture_provider.dart';
import '../../../providers/user_info_provider.dart';
import '../../services/firebase/auth/auth_provider.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/storage_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widgets/cached_profile_picture.dart';

class ProfileStaticScreen extends StatefulWidget {
  const ProfileStaticScreen({Key? key}) : super(key: key);

  @override
  ProfileStaticScreenState createState() => ProfileStaticScreenState();
}

class ProfileStaticScreenState extends State<ProfileStaticScreen> {
  // Add text controller
  final TextEditingController _textController = TextEditingController();
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
                      // Add input formatter for name and surname fields
                      inputFormatters: (title == "Name" || title == "Surname") 
                          ? [
                              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                            ]
                          : null,
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

  void _showDatePicker(BuildContext context, String currentValue) async {
    DateTime initialDate = DateTime.now().subtract(Duration(days: 365 * 18)); // Default to 18 years ago
    try {
      // Parse the current date if it exists
      if (currentValue.isNotEmpty && currentValue != "Not set") {
        List<String> parts = currentValue.split('/');
        if (parts.length == 3) {
          initialDate = DateTime(
            int.parse(parts[2]),  // year
            int.parse(parts[1]),  // month
            int.parse(parts[0]),  // day
          );
        }
      }
    } catch (e) {
      print("Error parsing date: $e");
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
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
    );

    if (picked != null) {
      String formattedDate = '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      
      // Update Firestore
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser?.email != null) {
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser!.email)
              .update({'birthdate': formattedDate});

          // Update local provider
          if (context.mounted) {
            final userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
            await userInfoProvider.updateBirthdate(formattedDate);
          }
        } catch (e) {
          print("Error updating birthdate: $e");
        }
      }
    }
  }

  void _showHeightInputDialog(BuildContext context, String currentValue) {
    // Get current height from Firebase
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser?.email != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser?.email)
          .get()
          .then((doc) {
        if (doc.exists) {
          final userData = doc.data()!;
          String heightValue = userData['height']?.toString() ?? "";
          
          // Set the text controller value
          _textController.text = heightValue.replaceAll(" cm", "").trim();

          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(12.h),
              ),
            ),
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
                          onPressed: () async {
                            int? height = int.tryParse(_textController.text);
                            if (height != null && height >= 100 && height <= 251) {
                              try {
                                // Update Firestore
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(currentUser!.email)
                                    .update({'height': height.toString()});

                                // Update local provider
                                if (context.mounted) {
                                  final userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
                                  await userInfoProvider.updateHeight(height.toString());
                                }
                              } catch (e) {
                                print("Error updating height: $e");
                              }
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
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
      });
    }
  }

  void _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser?.email != null) {
        try {
          // Update the UI and get the result of cropping
          bool success = await context.read<ProfilePictureProvider>().updateProfilePicture(image.path);
          
          if (success && mounted) {
            // Show loading indicator
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => Center(
                child: CircularProgressIndicator(),
              ),
            );

            // Upload the cropped image to Firebase
            final profileService = ProfilePictureService();
            final base64Image = await profileService.uploadProfilePicture(
              currentUser!.email!,
              File(context.read<ProfilePictureProvider>().profileImagePath),
            );

            if (mounted) {
              // Hide loading indicator
              Navigator.pop(context);

              if (base64Image != null) {
                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Profile picture updated successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            }
          }
        } catch (e) {
          // Hide loading indicator if it's showing
          if (mounted && Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          // Show error message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to update profile picture'),
                backgroundColor: Colors.red,
              ),
            );
          }
          print('Error uploading profile picture: $e');
        }
      }
    }
  }

  void _showGenderSelector(BuildContext context, String currentValue) {
    final List<String> genderOptions = ['Male', 'Female', 'Non Binary'];
    // Get the initial selected index based on the current value
    int initialIndex = genderOptions.indexOf(currentValue);
    // If current value is not in the list, default to first option
    if (initialIndex == -1) initialIndex = 0;

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
                scrollController: FixedExtentScrollController(initialItem: initialIndex),
                itemExtent: 44.0,
                onSelectedItemChanged: (int index) async {
                  final gender = genderOptions[index];
                  final currentUser = FirebaseAuth.instance.currentUser;
                  if (currentUser?.email != null) {
                    try {
                      // Update Firebase
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(currentUser!.email)
                          .update({'gender': gender});

                      // Update local provider
                      if (context.mounted) {
                        final userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
                        await userInfoProvider.updateGender(gender);
                      }
                    } catch (e) {
                      print("Error updating gender: $e");
                    }
                  }
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
                  tileColor: gender == currentValue ? Colors.blue.withOpacity(0.1) : null,
                  onTap: () async {
                    final currentUser = FirebaseAuth.instance.currentUser;
                    if (currentUser?.email != null) {
                      try {
                        // Update Firebase
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(currentUser!.email)
                            .update({'gender': gender});

                        // Update local provider
                        if (context.mounted) {
                          final userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
                          await userInfoProvider.updateGender(gender);
                        }
                      } catch (e) {
                        print("Error updating gender: $e");
                      }
                    }
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
  }

  @override
  void initState() {
    super.initState();
    // Setup Firebase listener for changes
    _setupFirestoreListener();
  }

  void _setupFirestoreListener() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser?.email != null) {
      _userSubscription = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser?.email)
          .snapshots()
          .listen((snapshot) {
        if (!mounted) return;
        if (snapshot.exists) {
          final userData = snapshot.data()!;
          // Handle other user data updates here if needed
        }
      });
    }
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    _textController.dispose();
    super.dispose();
  }

  Widget _buildDefaultProfilePicture() {
    return Container(
      height: 72.h,
      width: 72.h,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        shape: BoxShape.circle,
      ),
      child: SvgPicture.asset(
        'assets/images/person.crop.circle.fill.svg',
        height: 72.h,
        width: 72.h,
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        leadingWidth: 23.h,
        leading: AppbarLeadingImage(
          imagePath: ImageConstant.imgArrowLeftPrimary,
          margin: EdgeInsets.only(left: 7.h),
          onTap: () => Navigator.pop(context),
        ),
        title: TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            padding: EdgeInsets.only(left: 7.h),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            "Profile",
            style: theme.textTheme.bodyLarge!.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ),
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
                        Column(
                          children: [
                            Container(
                              height: 72.h,
                              width: 72.h,
                              child: FirebaseAuth.instance.currentUser?.email != null
                                ? CachedProfilePicture(
                                    email: FirebaseAuth.instance.currentUser!.email!,
                                    size: 72.h,
                                  )
                                : _buildDefaultProfilePicture(),
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
                    padding: EdgeInsets.only(left: 20.h, right: 10.h),
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
                        } else if (label == "Birthday") {
                          displayValue = userData['birthdate']?.toString() ?? "Not set";
                        } else if (label == "Gender") {
                          displayValue = userData['gender']?.toString() ?? "Not set";
                        } else if (label == "Height") {
                          String heightValue = userData['height']?.toString() ?? "";
                          displayValue = heightValue.isEmpty ? "Not set" : "${heightValue} cm";
                        }
                        return GestureDetector(
                          onTap: () {
                            if (label == "Birthday") {
                              _showDatePicker(context, value);
                            } else if (label == "Gender") {
                              _showGenderSelector(context, value);
                            } else if (label == "Height") {
                              _showHeightInputDialog(context, value);
                            } else {
                              onTap();
                            }
                          },
                          child: Text(
                            displayValue.isEmpty ? "Not set" : displayValue,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
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
                    onTap: () {
                      if (label == "Birthday") {
                        _showDatePicker(context, value);
                      } else if (label == "Gender") {
                        _showGenderSelector(context, value);
                      } else if (label == "Height") {
                        _showHeightInputDialog(context, value);
                      } else {
                        onTap();
                      }
                    },
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
}