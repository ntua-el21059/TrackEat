import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/cached_profile_picture.dart';
import 'models/profile_item_model.dart';
import 'provider/profile_provider.dart';
import 'widgets/profile_item_widget.dart';
import '../../providers/user_info_provider.dart';
import '../../models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final List<String> dietChoices = [
    'Balanced',
    'Keto',
    'Vegan',
    'Vegetarian',
    'Carnivore',
    'Fruitarian',
    'Pescatarian',
    'Mediterranean',
  ];

  String? selectedDiet;
  int _selectedDietIndex = 0;
  double _selectedWeeklyGoalValue = 0.0;
  int _selectedSign = 1;
  double _selectedValue = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchUserDiet();
    _fetchActivityLevel();
    _fetchDailyCalories();
  }

  void _fetchActivityLevel() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser?.email != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.email)
          .get()
          .then((doc) {
        if (doc.exists && mounted) {
          final userData = doc.data()!;
          final activity = userData['activity'] as String? ?? 'Light';
          Provider.of<ProfileProvider>(context, listen: false)
              .updateActivityLevel(activity);
        }
      }).catchError((e) {
        _showErrorSnackBar("Error fetching activity level");
      });
    }
  }

  void _fetchDailyCalories() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser?.email != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.email)
          .get()
          .then((doc) {
        if (doc.exists && mounted) {
          final userData = doc.data()!;
          if (userData['dailyCalories'] != null) {
            Provider.of<ProfileProvider>(context, listen: false)
                .updateNumericValue('Calories Goal', userData['dailyCalories'].toDouble());
          }
        }
      }).catchError((e) {
        _showErrorSnackBar("Error fetching daily calories");
      });
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _fetchUserData() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser?.email != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.email)
          .snapshots()
          .listen(
            (doc) {
              if (doc.exists && mounted) {
                final userData = doc.data()!;
                final provider = Provider.of<ProfileProvider>(context, listen: false);
                final userProvider = Provider.of<UserInfoProvider>(context, listen: false);
                
                try {
                  // Weight updates
                  if (userData['weight'] != null) {
                    provider.updateNumericValue('Cur. Weight', double.parse(userData['weight'].toString()));
                  }
                  // Goal weight updates
                  if (userData['weightgoal'] != null) {
                    provider.updateNumericValue('Goal Weight', double.parse(userData['weightgoal'].toString()));
                  }
                  // Weekly goal updates
                  if (userData['weeklygoal'] != null) {
                    provider.updateNumericValue('Weekly Goal', double.parse(userData['weeklygoal'].toString()));
                  }
                  // Macros updates
                  if (userData['carbsgoal'] != null) {
                    provider.updateNumericValue('Carbs Goal', userData['carbsgoal'].toDouble());
                  }
                  if (userData['proteingoal'] != null) {
                    provider.updateNumericValue('Protein Goal', userData['proteingoal'].toDouble());
                  }
                  if (userData['fatgoal'] != null) {
                    provider.updateNumericValue('Fat Goal', userData['fatgoal'].toDouble());
                  }

                  // Update user data
                  final userModel = UserModel(
                    firstName: userData['firstName'] as String? ?? '',
                    lastName: userData['lastName'] as String? ?? '',
                    username: userData['username'] as String? ?? '',
                    email: currentUser.email,
                    dailyCalories: userData['dailyCalories'] as int? ?? 0,
                    carbsGoal: double.tryParse(userData['carbsgoal']?.toString() ?? '0'),
                    proteinGoal: double.tryParse(userData['proteingoal']?.toString() ?? '0'),
                    fatGoal: double.tryParse(userData['fatgoal']?.toString() ?? '0'),
                    activity: userData['activity'] as String?,
                    diet: userData['diet'] as String?,
                    goal: userData['goal'] as String?,
                    height: double.tryParse(userData['height']?.toString() ?? '0'),
                    weight: double.tryParse(userData['weight']?.toString() ?? '0'),
                    birthdate: userData['birthdate'] as String?,
                    gender: userData['gender'] as String?,
                  );
                  
                  userProvider.setUser(userModel);
                } catch (e) {
                  _showErrorSnackBar("Error updating profile data");
                }
              }
            },
            onError: (e) {
              _showErrorSnackBar("Error fetching profile data");
            },
          );
    }
  }

  void _fetchUserDiet() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser?.email != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.email)
          .get()
          .then((doc) {
        if (doc.exists && mounted) {
          final userData = doc.data()!;
          final diet = userData['diet'] as String? ?? 'Balanced';
          
          // Update only local provider
          Provider.of<ProfileProvider>(context, listen: false)
              .updateDiet(diet);
        }
      }).catchError((e) {
        _showErrorSnackBar("Error fetching diet information");
      });
    }
  }

  @override
  void dispose() {
    // Clean up any listeners if needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: theme.colorScheme.onErrorContainer,
      appBar: _buildAppBar(context),
      body: SafeArea(
        top: false,
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 4.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildProfileHeader(context),
                SizedBox(height: 16.h),
                _buildProfilePreview(context),
                SizedBox(height: 16.h),
                _buildActivityLevelSection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
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
        text: "Home",
        margin: EdgeInsets.only(left: 7.h),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            "Profile",
            style: theme.textTheme.displaySmall,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.socialProfileMyselfScreen);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "PREVIEW PROFILE".toUpperCase(),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: const Color(0xFF8E8E93),
                  ),
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgArrowRightBlueGray400,
                  height: 10.h,
                  width: 8.h,
                  margin: EdgeInsets.only(left: 4.h),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildProfilePreview(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 10.h,
        vertical: 12.h,
      ),
      margin: EdgeInsets.symmetric(horizontal: 4.h),
      decoration: AppDecoration.lightBlueLayoutPadding.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(left: 8.h),
            width: 72.h,
            height: 72.h,
            alignment: Alignment.center,
            child: FirebaseAuth.instance.currentUser?.email != null
              ? CachedProfilePicture(
                  email: FirebaseAuth.instance.currentUser!.email!,
                  size: 56.h,
                )
              : _buildDefaultProfilePicture(),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 4.h, left: 0.h),
              padding: EdgeInsets.only(left: 4.h, right: 12.h),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.profileStaticScreen);
                      },
                      child: StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser?.email)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data != null && snapshot.data!.exists) {
                            final userData = snapshot.data!.data() as Map<String, dynamic>;
                            final firstName = userData['firstName']?.toString() ?? '';
                            final lastName = userData['lastName']?.toString() ?? '';
                            final username = userData['username']?.toString() ?? '';
                            
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "$firstName $lastName",
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "@$username",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            );
                          }
                          return Container();
                        },
                      ),
                    ),
                  ),
                  CustomImageView(
                    imagePath: ImageConstant.imgArrowRight,
                    height: 18.h,
                    width: 18.h,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                      right: 2.h,
                    ),
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultProfilePicture() {
    return Container(
      height: 56.h,
      width: 56.h,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        shape: BoxShape.circle,
      ),
      child: SvgPicture.asset(
        'assets/images/person.crop.circle.fill.svg',
        height: 56.h,
        width: 56.h,
        fit: BoxFit.cover,
      ),
    );
  }

  /// Section Widget
  Widget _buildActivityLevelSection(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 10.h,
        vertical: 12.h,
      ),
      margin: EdgeInsets.symmetric(horizontal: 4.h),
      decoration: AppDecoration.lightBlueLayoutPadding.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder20,
      ),
      child: Consumer<ProfileProvider>(
        builder: (context, provider, child) {
          return ListView.separated(
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return SizedBox(height: 4.h);
            },
            itemCount: provider.profileModelObj.profileItemList.length,
            itemBuilder: (context, index) {
              ProfileItemModel model = provider.profileModelObj.profileItemList[index];
              return ProfileItemWidget(
                model,
                onArrowTap: () {
                  // Handle different menu types
                  if (model.title?.toLowerCase().contains('diet') ?? false) {
                    _showDietSelectionDialog(context);
                  } else if (model.title == "Activity Level") {
                    _showActivityLevelDialog(context);
                  } else if (model.title == "Calories Goal") {
                    _showCaloriesInputDialog(context, model.value ?? "0");
                  } else if (model.title == "Cur. Weight") {
                    _showWeightInputDialog(context, model.value ?? "0");
                  } else if (model.title?.contains('Goal') ?? false) {
                    _showNumberInputDialog(context, model.title ?? "", model.value ?? "0");
                  }
                },
              );
            },
          );
        },
      ),
    );
  }

  void _showCaloriesInputDialog(BuildContext context, String currentValue) {
    final TextEditingController controller = TextEditingController(
      text: currentValue.replaceAll(" kcal", "")
    );

    if (Platform.isIOS) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: CupertinoColors.white,
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
                          if (controller.text.isNotEmpty) {
                            try {
                              // Update Firebase
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(FirebaseAuth.instance.currentUser!.email)
                                  .update({'dailyCalories': int.parse(controller.text)});

                              // Update local provider
                              Provider.of<ProfileProvider>(context, listen: false)
                                  .updateNumericValue("Calories Goal", double.parse(controller.text));
                            } catch (e) {
                              print("Error updating calories: $e");
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
                  controller: controller,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey6,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  placeholder: 'Enter daily calories goal',
                  suffix: Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Text(
                      ' kcal',
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
                  "Daily Calories Goal",
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),
                TextField(
                  controller: controller,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter daily calories goal',
                    suffixText: ' kcal',
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
                        if (controller.text.isNotEmpty) {
                          try {
                            // Update Firebase
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.email)
                                .update({'dailyCalories': int.parse(controller.text)});

                            // Update local provider
                            Provider.of<ProfileProvider>(context, listen: false)
                                .updateNumericValue("Calories Goal", double.parse(controller.text));
                          } catch (e) {
                            print("Error updating calories: $e");
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

  void _showDietSelectionDialog(BuildContext context) {
    final List<String> menuChoices = [
      'Balanced',
      'Keto',
      'Vegan',
      'Vegetarian',
      'Carnivore',
      'Fruitarian',
    ];

    // Get current diet from provider
    final currentDiet = Provider.of<ProfileProvider>(context, listen: false).profileModelObj.profileItemList[5].value ?? 'Balanced';
    // Get initial index
    final initialIndex = menuChoices.indexOf(currentDiet);

    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 250,
            color: CupertinoColors.white,
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
                          final diet = menuChoices[_selectedDietIndex];
                          final currentUser = FirebaseAuth.instance.currentUser;
                          if (currentUser?.email != null) {
                            try {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(currentUser!.email)
                                  .update({'diet': diet});

                              if (context.mounted) {
                                Provider.of<ProfileProvider>(context, listen: false)
                                    .updateDiet(diet);
                              }
                            } catch (e) {
                              print("Error updating diet: $e");
                            }
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
                    scrollController: FixedExtentScrollController(initialItem: initialIndex),
                    itemExtent: 44,
                    onSelectedItemChanged: (int index) {
                      _selectedDietIndex = index;
                    },
                    children: menuChoices.map((diet) => 
                      Center(
                        child: Text(
                          diet,
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
                  "Select Diet",
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),
                ...menuChoices.map((diet) => ListTile(
                  title: Text(
                    diet,
                    style: CustomTextStyles.bodyLargeBlack90018,
                    textAlign: TextAlign.center,
                  ),
                  tileColor: diet == currentDiet ? Colors.blue.withOpacity(0.1) : null,
                  onTap: () async {
                    final currentUser = FirebaseAuth.instance.currentUser;
                    if (currentUser?.email != null) {
                      try {
                        // Update Firebase
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(currentUser!.email)
                            .update({'diet': diet});

                        // Update local provider
                        if (context.mounted) {
                          Provider.of<ProfileProvider>(context, listen: false)
                              .updateDiet(diet);
                        }
                      } catch (e) {
                        print("Error updating diet: $e");
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

  void _showActivityLevelDialog(BuildContext context) {
    final List<String> activityLevels = ['Light', 'Moderate', 'Vigorous'];
    
    // Get current activity level from provider
    final currentActivity = Provider.of<ProfileProvider>(context, listen: false).profileModelObj.profileItemList[0].value ?? 'Light';
    // Get initial index
    final initialIndex = activityLevels.indexOf(currentActivity);

    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey6.withOpacity(0.95),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(15),
              ),
            ),
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
                  "Select Activity Level",
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),
                ...activityLevels.map((level) => ListTile(
                  title: Text(
                    level,
                    style: CustomTextStyles.bodyLargeBlack90018,
                    textAlign: TextAlign.center,
                  ),
                  tileColor: level == currentActivity ? Colors.blue.withOpacity(0.1) : null,
                  onTap: () async {
                    final currentUser = FirebaseAuth.instance.currentUser;
                    if (currentUser?.email != null) {
                      try {
                        // Update Firebase
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(currentUser!.email)
                            .update({'activity': level});

                        // Update local provider
                        if (context.mounted) {
                          Provider.of<ProfileProvider>(context, listen: false)
                              .updateActivityLevel(level);
                        }
                      } catch (e) {
                        print("Error updating activity level: $e");
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
                  "Select Activity Level",
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),
                ...activityLevels.map((level) => ListTile(
                  title: Text(
                    level,
                    style: CustomTextStyles.bodyLargeBlack90018,
                    textAlign: TextAlign.center,
                  ),
                  tileColor: level == currentActivity ? Colors.blue.withOpacity(0.1) : null,
                  onTap: () async {
                    final currentUser = FirebaseAuth.instance.currentUser;
                    if (currentUser?.email != null) {
                      try {
                        // Update Firebase
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(currentUser!.email)
                            .update({'activity': level});

                        // Update local provider
                        if (context.mounted) {
                          Provider.of<ProfileProvider>(context, listen: false)
                              .updateActivityLevel(level);
                        }
                      } catch (e) {
                        print("Error updating activity level: $e");
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

  void _showGoalWeightInputDialog(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser?.email != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.email)
          .get()
          .then((doc) {
        if (doc.exists) {
          final userData = doc.data()!;
          final goalWeight = userData['weightgoal']?.toString() ?? '';
          
          final TextEditingController controller = TextEditingController(text: goalWeight);

          if (Platform.isIOS) {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: CupertinoColors.white,
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
                                final newValue = double.tryParse(controller.text.replaceAll(' kg', ''));
                                if (newValue != null) {
                                  try {
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(currentUser.email)
                                        .update({'weightgoal': newValue});

                                    Provider.of<ProfileProvider>(context, listen: false)
                                        .updateNumericValue("Goal Weight", newValue);
                                  } catch (e) {
                                    print("Error updating goal weight: $e");
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
                        controller: controller,
                        autofocus: true,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemGrey6,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        placeholder: 'Enter goal weight',
                        suffix: Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Text(
                            'kg',
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
                final TextEditingController controller = TextEditingController(
                  text: _selectedWeeklyGoalValue.toStringAsFixed(1)
                );
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
                        "Weekly Goal",
                        style: CupertinoTheme.of(context).textTheme.navTitleTextStyle.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      TextField(
                        controller: controller,
                        autofocus: true,
                        keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                        decoration: InputDecoration(
                          hintText: 'Enter weekly goal in kg',
                          suffixText: ' kg',
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
                          FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
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
                              final newValue = double.tryParse(controller.text);
                              if (newValue != null) {
                                try {
                                  // Update Firebase
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(currentUser.email)
                                      .update({'weeklygoal': newValue});

                                  // Update local provider
                                  Provider.of<ProfileProvider>(context, listen: false)
                                      .updateNumericValue("Weekly Goal", newValue);
                                } catch (e) {
                                  print("Error updating weekly goal: $e");
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

  void _showNumberInputDialog(BuildContext context, String title, String currentValue) {
    if (title == "Goal Weight") {
      _showGoalWeightInputDialog(context);
    } else if (title == "Cur. Weight") {
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
            final weight = userData['weight']?.toString() ?? '0';
            
            // Show dialog with current weight from Firebase
            _showWeightInputDialog(context, weight);
          }
        });
      }
    } else if (title == "Weekly Goal") {
      _showWeeklyGoalInputDialog(context);
    } else if (title == "Calories Goal") {
      _showCaloriesGoalInputDialog(context);
    } else {
      // For carbs, protein, and fat goals
      final TextEditingController controller = TextEditingController(
        text: currentValue.replaceAll(" g", "")  // Remove "g" from the initial value
      );
      _showGenericNumberInputDialog(context, title, controller);
    }
  }

  void _showCaloriesGoalInputDialog(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser?.email != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.email)
          .get()
          .then((doc) {
        if (doc.exists) {
          final userData = doc.data()!;
          final caloriesGoal = userData['dailyCalories']?.toString() ?? '';
          
          final TextEditingController controller = TextEditingController(text: caloriesGoal);

          if (Platform.isIOS) {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: CupertinoColors.white,
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
                                if (controller.text.isNotEmpty) {
                                  try {
                                    // Update Firebase
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(currentUser.email)
                                        .update({'dailyCalories': int.parse(controller.text)});

                                    // Update local provider
                                    if (mounted) {
                                      final userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
                                      await userInfoProvider.updateDailyCalories(controller.text);
                                    }
                                  } catch (e) {
                                    print("Error updating calories: $e");
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
                        controller: controller,
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemGrey6,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        placeholder: 'Enter daily calories',
                        suffix: Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Text(
                            'kcal',
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
            // Android implementation
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
                        "Daily Calories Goal",
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      TextField(
                        controller: controller,
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Enter daily calories',
                          suffixText: ' kcal',
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
                              if (controller.text.isNotEmpty) {
                                try {
                                  // Update Firebase
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(currentUser.email)
                                      .update({'dailyCalories': int.parse(controller.text)});

                                  // Update local provider
                                  Provider.of<ProfileProvider>(context, listen: false)
                                      .updateNumericValue("Calories Goal", double.parse(controller.text));
                                } catch (e) {
                                  print("Error updating calories: $e");
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

  void _showWeightInputDialog(BuildContext context, String currentWeight) {
    final TextEditingController controller = TextEditingController(
      text: currentWeight.replaceAll(" kg", "")
    );

    if (Platform.isIOS) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: CupertinoColors.white,
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
                          final newValue = double.tryParse(controller.text);
                          if (newValue != null) {
                            final currentUser = FirebaseAuth.instance.currentUser;
                            if (currentUser?.email != null) {
                              try {
                                // Update Firebase
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(currentUser!.email)
                                    .update({'weight': newValue});

                                // Update local provider
                                Provider.of<ProfileProvider>(context, listen: false)
                                    .updateNumericValue("Cur. Weight", newValue);
                              } catch (e) {
                                print("Error updating weight: $e");
                              }
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
                  controller: controller,
                  autofocus: true,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey6,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  placeholder: 'Enter current weight',
                  suffix: Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Text(
                      'kg',
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
                  "Current Weight",
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),
                TextField(
                  controller: controller,
                  autofocus: true,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    hintText: 'Enter current weight',
                    suffixText: 'kg',
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
                        final newValue = double.tryParse(controller.text);
                        if (newValue != null) {
                          final currentUser = FirebaseAuth.instance.currentUser;
                          if (currentUser?.email != null) {
                            try {
                              // Update Firebase
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(currentUser!.email)
                                  .update({'weight': newValue});

                              // Update local provider
                              Provider.of<ProfileProvider>(context, listen: false)
                                  .updateNumericValue("Cur. Weight", newValue);
                            } catch (e) {
                              print("Error updating weight: $e");
                            }
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

  void _showGenericNumberInputDialog(BuildContext context, String title, TextEditingController controller) {
    if (Platform.isIOS) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: CupertinoColors.white,
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
                          final newValue = double.tryParse(controller.text);
                          if (newValue != null) {
                            final currentUser = FirebaseAuth.instance.currentUser;
                            if (currentUser?.email != null) {
                              try {
                                String fieldName = '';
                                if (title == "Carbs Goal") {
                                  fieldName = 'carbsgoal';
                                } else if (title == "Protein Goal") {
                                  fieldName = 'proteingoal';
                                } else if (title == "Fat Goal") {
                                  fieldName = 'fatgoal';
                                }
                                  
                                // Update Firebase
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(currentUser!.email)
                                    .update({fieldName: newValue});

                                // Update local provider
                                Provider.of<ProfileProvider>(context, listen: false)
                                    .updateNumericValue(title, newValue);
                              } catch (e) {
                                print("Error updating $title: $e");
                              }
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
                  controller: controller,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey6,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  placeholder: 'Enter ${title.toLowerCase()}',
                  suffix: Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Text(
                      ' g',
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
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),
                TextField(
                  controller: controller,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter ${title.toLowerCase()}',
                    suffixText: ' g',
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
                        final newValue = double.tryParse(controller.text);
                        if (newValue != null) {
                          final currentUser = FirebaseAuth.instance.currentUser;
                          if (currentUser?.email != null) {
                            try {
                              String fieldName = '';
                              if (title == "Carbs Goal") {
                                fieldName = 'carbsgoal';
                              } else if (title == "Protein Goal") {
                                fieldName = 'proteingoal';
                              } else if (title == "Fat Goal") {
                                fieldName = 'fatgoal';
                              }
                              
                              // Update Firebase
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(currentUser!.email)
                                  .update({fieldName: newValue});

                              // Update local provider
                              Provider.of<ProfileProvider>(context, listen: false)
                                  .updateNumericValue(title, newValue);
                            } catch (e) {
                              print("Error updating $title: $e");
                            }
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

  void _updateSelectedValue() {
    setState(() {
      _selectedWeeklyGoalValue = _selectedSign * _selectedValue;
    });
  }

  int _getInitialSignIndex(String currentValue) {
    try {
      final value = double.parse(currentValue);
      return value >= 0 ? 0 : 1;
    } catch (e) {
      return 0; // Default to positive
    }
  }

  int _getInitialValueIndex(String currentValue) {
    try {
      final value = double.parse(currentValue);
      return (value.abs() * 10).round().clamp(0, 15);
    } catch (e) {
      return 0; // Default to 0.0
    }
  }

  void _showWeeklyGoalInputDialog(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser?.email != null) {
      // First get the current weekly goal from Firebase
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.email)
          .get()
          .then((doc) {
        if (doc.exists) {
          final userData = doc.data()!;
          final weeklyGoal = userData['weeklygoal']?.toString() ?? '0.0';
          
          // Initialize the selected values
          try {
            final value = double.parse(weeklyGoal);
            _selectedSign = value >= 0 ? 1 : -1;
            _selectedValue = double.parse(value.abs().toStringAsFixed(1));
            _selectedWeeklyGoalValue = value;
          } catch (e) {
            _selectedSign = 1;
            _selectedValue = 0.0;
            _selectedWeeklyGoalValue = 0.0;
          }

          if (Platform.isIOS) {
            showCupertinoModalPopup(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: 250,
                  color: CupertinoColors.white,
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
                                  // Update Firebase
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(currentUser.email)
                                      .update({'weeklygoal': _selectedWeeklyGoalValue});

                                  // Update local provider
                                  Provider.of<ProfileProvider>(context, listen: false)
                                      .updateNumericValue("Weekly Goal", _selectedWeeklyGoalValue);
                                } catch (e) {
                                  print("Error updating weekly goal: $e");
                                }
                                Navigator.pop(context);
                              },
                              child: Text('Save', style: TextStyle(color: Color(0xFF4A90E2))),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            // Sign picker
                            Flexible(
                              flex: 1,
                              child: CupertinoPicker(
                                scrollController: FixedExtentScrollController(
                                  initialItem: _selectedSign == 1 ? 0 : 1,
                                ),
                                itemExtent: 44,
                                onSelectedItemChanged: (int index) {
                                  _selectedSign = index == 0 ? 1 : -1;
                                  _updateSelectedValue();
                                },
                                children: [
                                  Center(
                                    child: Text(
                                      '+',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: CupertinoColors.black,
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      '-',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: CupertinoColors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Value picker
                            Flexible(
                              flex: 4,
                              child: CupertinoPicker(
                                scrollController: FixedExtentScrollController(
                                  initialItem: (_selectedValue * 10).round(),
                                ),
                                itemExtent: 44,
                                onSelectedItemChanged: (int index) {
                                  _selectedValue = index * 0.1;
                                  _updateSelectedValue();
                                },
                                children: List<Widget>.generate(16, (index) {
                                  final value = index * 0.1;
                                  return Center(
                                    child: Text(
                                      '${value.toStringAsFixed(1)} kg',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: CupertinoColors.black,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
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
                final TextEditingController controller = TextEditingController(
                  text: _selectedWeeklyGoalValue.toStringAsFixed(1)
                );
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
                        "Weekly Goal",
                        style: CupertinoTheme.of(context).textTheme.navTitleTextStyle.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      TextField(
                        controller: controller,
                        autofocus: true,
                        keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                        decoration: InputDecoration(
                          hintText: 'Enter weekly goal in kg',
                          suffixText: ' kg',
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
                          FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
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
                              final newValue = double.tryParse(controller.text);
                              if (newValue != null) {
                                try {
                                  // Update Firebase
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(currentUser.email)
                                      .update({'weeklygoal': newValue});

                                  // Update local provider
                                  Provider.of<ProfileProvider>(context, listen: false)
                                      .updateNumericValue("Weekly Goal", newValue);
                                } catch (e) {
                                  print("Error updating weekly goal: $e");
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
}