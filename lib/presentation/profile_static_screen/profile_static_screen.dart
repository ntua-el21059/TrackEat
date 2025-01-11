import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
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

class ProfileStaticScreenState extends State<ProfileStaticScreen> with TickerProviderStateMixin {
  // Add text controller
  TextEditingController? _textController;
  StreamSubscription<DocumentSnapshot>? _userSubscription;

  void _showTextInputDialog(BuildContext context, String title, String currentValue, bool isNameField) {
    if (title == "Birthday") {
      _showDateInputDialog(context, currentValue);
      return;
    }

    // Create a new controller for each dialog
    _textController = TextEditingController();

    // Get the current value from Firebase first
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser?.email != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser?.email)
          .get()
          .then((doc) {
        if (doc.exists && mounted) {
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
          _textController?.text = dialogValue;
          
          if (Platform.isIOS) {
            late AnimationController controller;
            controller = AnimationController(
              duration: const Duration(milliseconds: 300),
              vsync: this,
            );

            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: CupertinoColors.white,
              enableDrag: true,
              isDismissible: true,
              useRootNavigator: true,
              barrierColor: Colors.black.withOpacity(0.5),
              useSafeArea: true,
              showDragHandle: false,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.9,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  behavior: HitTestBehavior.opaque,
                  child: SafeArea(
                    child: SingleChildScrollView(
                      physics: ClampingScrollPhysics(),
                      child: Container(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: WillPopScope(
                          onWillPop: () async {
                            FocusScope.of(context).unfocus();
                            Navigator.pop(context);
                            return false;
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
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
                                        onPressed: () {
                                          FocusScope.of(context).unfocus();
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancel', style: TextStyle(color: Color(0xFF4A90E2))),
                                      ),
                                      CupertinoButton(
                                        padding: EdgeInsets.symmetric(horizontal: 16),
                                        onPressed: () async {
                                          FocusScope.of(context).unfocus();
                                          final newValue = _textController?.text.trim() ?? '';
                                          Navigator.pop(context);
                                          
                                          if (newValue.isNotEmpty) {
                                            try {
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
                                        },
                                        child: Text('Save', style: TextStyle(color: Color(0xFF4A90E2))),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 16),
                                CupertinoTextField(
                                  controller: _textController,
                                  autofocus: true,
                                  keyboardType: TextInputType.name,
                                  onSubmitted: (_) {
                                    FocusScope.of(context).unfocus();
                                  },
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.systemGrey6,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  placeholder: 'Enter ${title.toLowerCase()}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: CupertinoColors.black,
                                  ),
                                ),
                                SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ).whenComplete(() {
              controller.dispose();
              _textController?.dispose();
              _textController = null;
            });
          } else {
            // Android implementation...
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.white,
              enableDrag: true,
              isDismissible: true,
              useRootNavigator: true,
              barrierColor: Colors.black.withOpacity(0.5),
              useSafeArea: true,
              showDragHandle: false,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.9,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  behavior: HitTestBehavior.opaque,
                  child: SafeArea(
                    child: SingleChildScrollView(
                      physics: ClampingScrollPhysics(),
                      child: Container(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.h),
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
                                keyboardType: TextInputType.name,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  hintText: 'Enter ${title.toLowerCase()}',
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.1),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: theme.primaryColor),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(3),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      Navigator.pop(context);
                                      _textController?.clear();
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      FocusScope.of(context).unfocus();
                                      final newValue = _textController?.text.trim() ?? '';
                                      Navigator.pop(context);
                                      _textController?.clear();
                                      
                                      if (newValue.isNotEmpty) {
                                        try {
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
                                    },
                                    child: Text('Save'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ).whenComplete(() {
              // No need for any cleanup here as it's handled in the dismiss actions
            });
          }
        }
      });
    }
  }

  void _showDateInputDialog(BuildContext context, String currentValue) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser?.email != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser?.email)
          .get()
          .then((doc) {
        if (doc.exists) {
          final userData = doc.data()!;
          final birthdate = userData['birthdate']?.toString() ?? '';
          
          DateTime initialDate = DateTime.now().subtract(Duration(days: 365 * 18)); // Default to 18 years ago
          try {
            if (birthdate.isNotEmpty) {
              List<String> parts = birthdate.split('/');
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
                              onPressed: () async {
                                try {
                                  String formattedDate = '${initialDate.day.toString().padLeft(2, '0')}/${initialDate.month.toString().padLeft(2, '0')}/${initialDate.year}';
                                  
                                  // Update Firebase
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
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              },
                              child: Text('Save', style: TextStyle(color: Color(0xFF4A90E2))),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          initialDateTime: initialDate,
                          maximumDate: DateTime.now(),
                          minimumYear: 1900,
                          maximumYear: DateTime.now().year,
                          onDateTimeChanged: (DateTime newDate) {
                            initialDate = newDate;
                          },
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
              isScrollControlled: true,
              backgroundColor: Colors.white.withOpacity(0.7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
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
                        "Birthday",
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Container(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: initialDate,
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                              builder: (BuildContext context, Widget? child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: theme.primaryColor,
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
                              try {
                                // Update Firebase
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
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            side: BorderSide(color: theme.primaryColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            birthdate.isEmpty ? 'Select birthday' : birthdate,
                            style: TextStyle(
                              color: theme.primaryColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }
        }
      });
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
          _textController?.text = heightValue.replaceAll(" cm", "").trim();

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
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: 16,
                    right: 16,
                    top: 16,
                  ),
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
                              onPressed: () async {
                                if (_textController?.text.isNotEmpty ?? false) {
                                  try {
                                    // Update Firebase
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(currentUser!.email)
                                        .update({'height': _textController?.text ?? ''});

                                    // Update local provider
                                    if (mounted) {
                                      final userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
                                      await userInfoProvider.updateHeight(_textController?.text ?? '');
                                    }
                                  } catch (e) {
                                    print("Error updating height: $e");
                                  }
                                }
                                Navigator.pop(context);
                              },
                              child: Text('Save', style: TextStyle(color: Color(0xFF4A90E2))),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      CupertinoTextField(
                        controller: _textController,
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemGrey6,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        placeholder: 'Enter height (100-251 cm)',
                        suffix: Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Text(
                            ' cm',
                            style: TextStyle(
                              color: CupertinoColors.systemGrey,
                              fontSize: 16,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          color: CupertinoColors.black,
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                );
              },
            );
          } else {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.white.withOpacity(0.7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
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
                          suffixText: ' cm',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: theme.primaryColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
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
                              if (_textController?.text.isNotEmpty ?? false) {
                                try {
                                  // Update Firebase
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(currentUser!.email)
                                      .update({'height': _textController?.text ?? ''});

                                  // Update local provider
                                  if (mounted) {
                                    final userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
                                    await userInfoProvider.updateHeight(_textController?.text ?? '');
                                  }
                                } catch (e) {
                                  print("Error updating height: $e");
                                }
                              }
                              Navigator.pop(context);
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
    String selectedGender = currentValue;
    
    // Get current gender from Firebase
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser?.email != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser?.email)
          .get()
          .then((doc) {
        if (doc.exists) {
          final userData = doc.data()!;
          selectedGender = userData['gender']?.toString() ?? 'Male';
          
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
                              onPressed: () async {
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(currentUser!.email)
                                      .update({'gender': selectedGender});

                                  if (context.mounted) {
                                    final userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
                                    await userInfoProvider.updateGender(selectedGender);
                                  }
                                } catch (e) {
                                  print("Error updating gender: $e");
                                }
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
                        tileColor: gender == selectedGender ? Colors.blue.withOpacity(0.1) : null,
                        onTap: () async {
                          try {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(currentUser!.email)
                                .update({'gender': gender});

                            if (context.mounted) {
                              final userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
                              await userInfoProvider.updateGender(gender);
                            }
                          } catch (e) {
                            print("Error updating gender: $e");
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
      });
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
          // Handle any future snapshot updates here
        }
      });
    }
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    _textController?.dispose();
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
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.accessibilitySettingsScreen);
            },
            child: Container(
              margin: EdgeInsets.only(right: 16.h),
              child: SvgPicture.asset(
                'assets/images/accessibility.fill.svg',
                height: 24.h,
                width: 24.h,
                color: theme.colorScheme.primary,
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
                          onTap: () => _showDateInputDialog(
                            context,
                            userInfo.birthdate,
                          ),
                        ),
                        _buildProfileItem(
                          label: "Gender",
                          value: userInfo.gender.isEmpty ? "Not set" : userInfo.gender,
                          onTap: () => _showGenderSelector(
                            context,
                            userInfo.gender.isEmpty ? "Not set" : userInfo.gender,
                          ),
                        ),
                        _buildProfileItem(
                          label: "Height",
                          value: userInfo.height <= 0 ? "Not set" : "${userInfo.height} cm",
                          onTap: () => _showHeightInputDialog(
                            context,
                            userInfo.height.toString(),
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
                              _showDateInputDialog(context, value);
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
                        _showDateInputDialog(context, value);
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