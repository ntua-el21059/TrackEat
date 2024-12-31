import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import 'models/profile_item_model.dart';
import 'models/profile_model.dart';
import 'provider/profile_provider.dart';
import 'widgets/profile_item_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/profile_picture_provider.dart';
import '../../providers/user_info_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/firebase/auth/auth_provider.dart' as app_auth;

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

  @override
  void initState() {
    super.initState();
    _setupFirestoreListener();
    _fetchUserDiet();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = Provider.of<app_auth.AuthProvider>(context, listen: false);
      if (authProvider.userData?.diet == null) {
        await authProvider.updateUserDiet('Balanced');
      }
    });
  }

  void _setupFirestoreListener() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser?.email != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.email)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists && mounted) {
          final userData = snapshot.data()!;
          
          // Listen for calories changes
          final calories = userData['dailyCalories']?.toString() ?? '0';
          Provider.of<ProfileProvider>(context, listen: false)
              .updateCalories(calories);
            
          // Listen for diet changes
          final diet = userData['diet'] as String? ?? 'Balanced';
          Provider.of<ProfileProvider>(context, listen: false)
              .updateDiet(diet);

          // Listen for activity level changes
          final activity = userData['activity'] as String? ?? 'Moderate';
          Provider.of<ProfileProvider>(context, listen: false)
              .updateActivityLevel(activity);

          // Listen for weight changes
          final weight = userData['weight']?.toString() ?? '0';
          Provider.of<ProfileProvider>(context, listen: false)
              .updateNumericValue('Cur. Weight', double.parse(weight));
        }
      });
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
        print("Error fetching diet: $e");
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
        horizontal: 26.h,
        vertical: 20.h,
      ),
      margin: EdgeInsets.symmetric(horizontal: 4.h),
      decoration: AppDecoration.lightBlueLayoutPadding.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder20,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<ProfilePictureProvider>(
            builder: (context, profilePicProvider, _) {
              return CustomImageView(
                imagePath: profilePicProvider.profileImagePath,
                isFile: !profilePicProvider.profileImagePath.startsWith('assets/'),
                height: 72.h,
                width: 72.h,
                radius: BorderRadius.circular(36.h),
              );
            },
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 4.h, left: 16.h),
              padding: EdgeInsets.symmetric(horizontal: 12.h),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Consumer<UserInfoProvider>(
                          builder: (context, userInfo, _) {
                            return Text(
                              userInfo.fullName,
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          },
                        ),
                        Text(
                          "@${context.watch<UserInfoProvider>().username}",
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.profileStaticScreen);
                    },
                    child: CustomImageView(
                      imagePath: ImageConstant.imgArrowRight,
                      height: 30.h,
                      width: 18.h,
                      alignment: Alignment.bottomCenter,
                      margin: EdgeInsets.only(
                        right: 2.h,
                        bottom: 0,
                        top: 2.h,
                      ),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
                  } else if (model.title?.contains('Goal') ?? false || 
                           model.title == "Cur. Weight") {
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

  Widget _buildProfileItem(
    String title,
    String value,
    String imagePath,
    {EdgeInsets? iconPadding, double? iconWidth, double? iconHeight, Alignment? alignment}
  ) {
    return Container(
      // ... other widget properties
      child: Row(
        children: [
          // ... left side widgets
          Text(
            // Add space for kg units, remove space for others
            value?.replaceAll('kg', ' kg')  // First add space before all 'kg'
                .replaceAll(' g', 'g')            // Remove space before 'g'
                .replaceAll(' kcal', 'kcal') ?? '',  // Remove space before 'kcal'
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          // ... right side widgets
        ],
      ),
    );
  }

  void _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      context.read<ProfilePictureProvider>().updateProfilePicture(image.path);
    }
  }

  void _showCaloriesInputDialog(BuildContext context, String currentValue) {
    final TextEditingController controller = TextEditingController(text: currentValue);

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
                  suffixText: 'kcal',
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
                      final newValue = controller.text.trim();
                      if (newValue.isNotEmpty) {
                        final currentUser = FirebaseAuth.instance.currentUser;
                        if (currentUser?.email != null) {
                          try {
                            // Update Firestore
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(currentUser!.email)
                                .update({'dailyCalories': int.parse(newValue)});

                            // Update local provider
                            if (mounted) {
                              final userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
                              await userInfoProvider.updateDailyCalories(newValue);
                            }
                          } catch (e) {
                            print("Error updating calories: $e");
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

  void _showDietSelectionDialog(BuildContext context) {
    final List<String> menuChoices = [
      'Balanced',
      'Keto',
      'Vegan',
      'Vegetarian',
      'Carnivore',
      'Fruitarian',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...menuChoices.map((diet) => Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    final currentUser = FirebaseAuth.instance.currentUser;
                    if (currentUser?.email != null) {
                      try {
                        // Update Firebase
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(currentUser!.email)
                            .update({'diet': diet});

                        // Update only local provider
                        Provider.of<ProfileProvider>(context, listen: false)
                            .updateDiet(diet);
                      } catch (e) {
                        print("Error updating diet: $e");
                      }
                    }
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    child: Text(
                      diet,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )).toList(),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.blue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showActivityLevelDialog(BuildContext context) {
    final List<String> activityLevels = ['Light', 'Moderate', 'Vigorous'];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...activityLevels.map((level) => Material(
                color: Colors.transparent,
                child: InkWell(
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
                        Provider.of<ProfileProvider>(context, listen: false)
                            .updateActivityLevel(level);
                      } catch (e) {
                        print("Error updating activity level: $e");
                      }
                    }
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    child: Text(
                      level,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )).toList(),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.blue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showNumberInputDialog(BuildContext context, String title, String currentValue) {
    final TextEditingController controller = TextEditingController(text: currentValue);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
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
                  hintText: 'Enter value',
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
                    onPressed: () {
                      final newValue = double.tryParse(controller.text);
                      if (newValue != null) {
                        Provider.of<ProfileProvider>(context, listen: false)
                            .updateNumericValue(title, newValue);
                            
                        // Save weight to Firebase if it's the weight field
                        if (title == "Cur. Weight") {
                          final currentUser = FirebaseAuth.instance.currentUser;
                          if (currentUser?.email != null) {
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(currentUser!.email)
                                .update({'weight': newValue});
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