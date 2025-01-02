import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/app_export.dart';
import '../../../providers/user_provider.dart';
import '../../../widgets/custom_bottom_bar.dart';
import '../../../widgets/app_bar/appbar_subtitle_one.dart';
import '../../../widgets/app_bar/appbar_title.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import 'models/cards_item_model.dart';
import 'provider/home_provider.dart';
import 'widgets/cards_item_widget.dart';
import 'package:activity_ring/activity_ring.dart';
import '../../../presentation/profile_screen/profile_screen.dart';
import '../../../providers/profile_picture_provider.dart';
import '../../../providers/user_info_provider.dart';
import '../../../models/user_model.dart';
import '../../../services/meal_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeProvider(),
      child: HomeScreen(),
    );
  }
}

class HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  StreamSubscription<DocumentSnapshot>? _userSubscription;

  @override
  void initState() {
    super.initState();
    
    // Fetch current user data immediately
    _fetchInitialUserData();
    _setupFirestoreListener();
    
    // Update UI loading state after a delay
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        // Update suggestions with user's name
        Provider.of<HomeProvider>(context, listen: false).updateSuggestions(context);
      }
    });
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
          final userProvider = Provider.of<UserProvider>(context, listen: false);
          
          // Update provider with fresh Firestore values
          userProvider.setDailyCalories(userData['dailyCalories'] as int? ?? 2000);
          userProvider.setMacronutrientGoals(
            carbsGoal: double.tryParse(userData['carbsgoal']?.toString() ?? '0'),
            proteinGoal: double.tryParse(userData['proteingoal']?.toString() ?? '0'),
            fatGoal: double.tryParse(userData['fatgoal']?.toString() ?? '0'),
          );
          
          // Force UI update
          setState(() {});
        }
      });
    }
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    super.dispose();
  }

  void _fetchInitialUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final email = currentUser?.email;
    if (email != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(email)
            .get();
            
        if (doc.exists && mounted) {
          final userData = doc.data()!;
          final userProvider = Provider.of<UserProvider>(context, listen: false);
          
          // Update provider with fresh Firestore values
          userProvider.setDailyCalories(userData['dailyCalories'] as int? ?? 2000);
          userProvider.setMacronutrientGoals(
            carbsGoal: double.tryParse(userData['carbsgoal']?.toString() ?? '0'),
            proteinGoal: double.tryParse(userData['proteingoal']?.toString() ?? '0'),
            fatGoal: double.tryParse(userData['fatgoal']?.toString() ?? '0'),
          );
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

  void _checkRingsAndShowReward(Map<String, dynamic> userData) async {
    final proteinGoal = double.tryParse(userData['proteingoal']?.toString() ?? '0') ?? 98.0;
    final fatGoal = double.tryParse(userData['fatgoal']?.toString() ?? '0') ?? 70.0;
    final carbsGoal = double.tryParse(userData['carbsgoal']?.toString() ?? '0') ?? 110.0;

    // Get consumed macros from meal history
    final userEmail = FirebaseAuth.instance.currentUser?.email;
    final now = DateTime.now();
    final mealService = MealService();
    final macros = await mealService.getTotalMacrosForDate(userEmail!, now);
    
    final proteinConsumed = macros['protein'] ?? 0.0;
    final fatConsumed = macros['fats'] ?? 0.0;
    final carbsConsumed = macros['carbs'] ?? 0.0;

    final proteinPercent = (proteinConsumed / proteinGoal * 100).clamp(0, 100);
    final fatPercent = (fatConsumed / fatGoal * 100).clamp(0, 100);
    final carbsPercent = (carbsConsumed / carbsGoal * 100).clamp(0, 100);

    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    final bool ringsAreNowClosed = proteinPercent >= 100 && fatPercent >= 100 && carbsPercent >= 100;
    final bool hasRingChanged = await homeProvider.hasRingChanged();

    // Update rings closed state
    await homeProvider.setRingsClosed(ringsAreNowClosed);

    // Show reward screen only if:
    // 1. Rings are now closed AND
    // 2. Either rings were previously changed (not closed) or not shown yet
    if (ringsAreNowClosed && hasRingChanged) {
      // Reset the ring changed state since we're showing the reward
      await homeProvider.setRingChanged(false);
      
      if (mounted) {
        Navigator.pushNamed(context, AppRoutes.rewardScreenRingsClosedScreen);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.onErrorContainer,
      appBar: _buildAppbar(context),
      body: Container(
        width: double.maxFinite,
        decoration: AppDecoration.graysWhite,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.only(
                    left: 4.h,
                    top: 22.h,
                    right: 4.h,
                  ),
                  child: Column(
                    children: [
                      _buildCalories(context),
                      SizedBox(height: 16.h),
                      _buildSuggestionsone(context),
                      SizedBox(height: 14.h)
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: _buildBottombar(context),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 70.h,
      title: Padding(
        padding: EdgeInsets.only(left: 19.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppbarSubtitleOne(
              text: "WELCOME".toUpperCase(),
            ),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser?.email)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null && snapshot.data!.exists) {
                  final userData = snapshot.data!.data() as Map<String, dynamic>;
                  final firstName = userData['firstName']?.toString() ?? '';
                  return AppbarTitle(
                    text: firstName,
                  );
                }
                return AppbarTitle(
                  text: "",
                );
              },
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(
            left: 16.h,
            right: 16.h,
            bottom: 12.h,
            top: 18.h,
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
            child: Consumer<ProfilePictureProvider>(
              builder: (context, profilePicProvider, _) {
                return CustomImageView(
                  imagePath: profilePicProvider.profileImagePath,
                  isFile: !profilePicProvider.profileImagePath.startsWith('assets/'),
                  height: 40.h,
                  width: 40.h,
                  radius: BorderRadius.circular(20.h),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildCalories(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(22.h),
      decoration: BoxDecoration(
        color: const Color(0xFFB2D7FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser?.email)
                    .snapshots(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.hasData && userSnapshot.data != null && userSnapshot.data!.exists) {
                    final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                    final dailyCalories = userData['dailyCalories'] as int? ?? 2000;
                    
                    return FutureBuilder<int>(
                      future: MealService().getTotalCaloriesForDate(
                        FirebaseAuth.instance.currentUser!.email!,
                        DateTime.now(),
                      ),
                      builder: (context, consumedSnapshot) {
                        final consumedCalories = consumedSnapshot.data ?? 0;
                        final remainingCalories = (dailyCalories - consumedCalories).clamp(0, dailyCalories);
                        
                        return Text(
                          "$remainingCalories Kcal Remaining...",
                          style: CustomTextStyles.titleMediumGray90001Bold,
                        );
                      },
                    );
                  }
                  return Text(
                    "0 Kcal Remaining...",
                    style: CustomTextStyles.titleMediumGray90001Bold,
                  );
                },
              ),
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser?.email)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null && snapshot.data!.exists) {
                    final userData = snapshot.data!.data() as Map<String, dynamic>;
                    final dailyCalories = userData['dailyCalories']?.toString() ?? "2000";
                    return Text(
                      "$dailyCalories kcal",
                      style: TextStyle(
                        color: const Color(0xFFFF0000),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }
                  return Text(
                    "${_calculateDailyCalories()} kcal",
                    style: TextStyle(
                      color: const Color(0xFFFF0000),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 8.h),
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser?.email)
                .snapshots(),
            builder: (context, userSnapshot) {
              if (userSnapshot.hasData && userSnapshot.data != null && userSnapshot.data!.exists) {
                final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                final dailyCalories = userData['dailyCalories'] as int? ?? 2000;
                
                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('meals')
                      .where('userEmail', isEqualTo: FirebaseAuth.instance.currentUser?.email)
                      .where('date', isGreaterThanOrEqualTo: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))
                      .where('date', isLessThan: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1))
                      .snapshots(),
                  builder: (context, mealsSnapshot) {
                    int consumedCalories = 0;
                    if (mealsSnapshot.hasData) {
                      for (var doc in mealsSnapshot.data!.docs) {
                        consumedCalories += (doc.data() as Map<String, dynamic>)['calories'] as int;
                      }
                    }
                    final percentage = ((consumedCalories / dailyCalories) * 100).clamp(0, 100);
                    
                    return Container(
                      width: double.maxFinite,
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.h),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4.h),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Row(
                              children: [
                                Container(
                                  width: (constraints.maxWidth * (percentage / 100)).clamp(0, constraints.maxWidth),
                                  decoration: BoxDecoration(
                                    color: consumedCalories > dailyCalories ? Colors.red : const Color(0xFF4CD964),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              }
              return Container(
                width: double.maxFinite,
                height: 8.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.h),
                ),
              );
            },
          ),
          SizedBox(height: 20.h),
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser?.email)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null && snapshot.data!.exists) {
                final userData = snapshot.data!.data() as Map<String, dynamic>;
                final proteinGoal = double.tryParse(userData['proteingoal']?.toString() ?? '0') ?? 98.0;
                final fatGoal = double.tryParse(userData['fatgoal']?.toString() ?? '0') ?? 70.0;
                final carbsGoal = double.tryParse(userData['carbsgoal']?.toString() ?? '0') ?? 110.0;

                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('meals')
                      .where('userEmail', isEqualTo: FirebaseAuth.instance.currentUser?.email)
                      .where('date', isGreaterThanOrEqualTo: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))
                      .where('date', isLessThan: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1))
                      .snapshots(),
                  builder: (context, mealsSnapshot) {
                    double proteinConsumed = 0.0;
                    double fatConsumed = 0.0;
                    double carbsConsumed = 0.0;

                    if (mealsSnapshot.hasData) {
                      for (var doc in mealsSnapshot.data!.docs) {
                        final data = doc.data() as Map<String, dynamic>;
                        final macros = data['macros'] as Map<String, dynamic>;
                        proteinConsumed += (macros['protein'] as num).toDouble();
                        fatConsumed += (macros['fats'] as num).toDouble();
                        carbsConsumed += (macros['carbs'] as num).toDouble();
                      }
                    }

                    final proteinPercent = (proteinConsumed / proteinGoal * 100).clamp(0, 100);
                    final fatPercent = (fatConsumed / fatGoal * 100).clamp(0, 100);
                    final carbsPercent = (carbsConsumed / carbsGoal * 100).clamp(0, 100);
                    
                    // Update the UserProvider with the latest values from Firebase only if they've changed
                    final userProvider = Provider.of<UserProvider>(context, listen: false);
                    if (userProvider.user.carbsGoal != carbsGoal ||
                        userProvider.user.proteinGoal != proteinGoal ||
                        userProvider.user.fatGoal != fatGoal) {
                      userProvider.setMacronutrientGoals(
                        proteinGoal: proteinGoal,
                        fatGoal: fatGoal,
                        carbsGoal: carbsGoal,
                      );
                    }
                    
                    return Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildMacronutrientText("Protein", proteinConsumed, proteinGoal, const Color(0xFFFA114F)),
                              SizedBox(height: 16.h),
                              _buildMacronutrientText("Fats", fatConsumed, fatGoal, const Color(0xFFA6FF00)),
                              SizedBox(height: 16.h),
                              _buildMacronutrientText("Carbs", carbsConsumed, carbsGoal, const Color(0xFF00FFF6)),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Ring(
                            percent: _isLoading ? 0.0 : proteinPercent.toDouble(),
                            color: RingColorScheme(
                              ringColor: Color(0xFFFA114F),
                              backgroundColor: Colors.grey.withOpacity(0.2),
                            ),
                            radius: 60,
                            width: 15,
                            child: Ring(
                              percent: _isLoading ? 0.0 : fatPercent.toDouble(),
                              color: RingColorScheme(
                                ringColor: Color(0xFFA6FF00),
                                backgroundColor: Colors.grey.withOpacity(0.2),
                              ),
                              radius: 45,
                              width: 15,
                              child: Ring(
                                percent: _isLoading ? 0.0 : carbsPercent.toDouble(),
                                color: RingColorScheme(
                                  ringColor: Color(0xFF00FFF6),
                                  backgroundColor: Colors.grey.withOpacity(0.2),
                                ),
                                radius: 30,
                                width: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
              
              // Fallback values when data is not available
              return Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMacronutrientText("Protein", 0, 98.0, const Color(0xFFFA114F)),
                        SizedBox(height: 16.h),
                        _buildMacronutrientText("Fats", 0, 70.0, const Color(0xFFA6FF00)),
                        SizedBox(height: 16.h),
                        _buildMacronutrientText("Carbs", 0, 110.0, const Color(0xFF00FFF6)),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Ring(
                      percent: 0,
                      color: RingColorScheme(
                        ringColor: Color(0xFFFA114F),
                        backgroundColor: Colors.grey.withOpacity(0.2),
                      ),
                      radius: 60,
                      width: 15,
                      child: Ring(
                        percent: 0,
                        color: RingColorScheme(
                          ringColor: Color(0xFFA6FF00),
                          backgroundColor: Colors.grey.withOpacity(0.2),
                        ),
                        radius: 45,
                        width: 15,
                        child: Ring(
                          percent: 0,
                          color: RingColorScheme(
                            ringColor: Color(0xFF00FFF6),
                            backgroundColor: Colors.grey.withOpacity(0.2),
                          ),
                          radius: 30,
                          width: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.historyTodayTabScreen);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Show History",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Inter',
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _calculateDailyCalories() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return userProvider.user.dailyCalories ?? 2000;
  }

  Widget _buildSuggestionsone(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.only(
        bottom: 22.h,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFBAB2),
        borderRadius: BorderRadius.circular(21),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 17.h, top: 22.h),
            child: Text(
              "Suggestions",
              style: CustomTextStyles.titleMediumGray90001Bold.copyWith(
                fontSize: 22,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Consumer<HomeProvider>(
            builder: (context, provider, child) {
              return ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 5.h);
                },
                itemCount: provider.homeInitialModelObj.cardsItemList.length,
                itemBuilder: (context, index) {
                  CardsItemModel model = provider.homeInitialModelObj.cardsItemList[index];
                  return CardsItemWidget(model);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottombar(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: CustomBottomBar(
        onChanged: (BottomBarEnum type) {
          switch (type) {
            case BottomBarEnum.Home:
              break;
            case BottomBarEnum.Leaderboard:
              Navigator.pushNamed(context, "/leaderboard");
              break;
            case BottomBarEnum.AI:
              Navigator.pushNamed(context, AppRoutes.aiChatMainScreen);
              break;
          }
        },
      ),
    );
  }

  Widget _buildMacronutrientText(String label, double consumed, double total, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: CustomTextStyles.bodyLargeBlack90016_2,
        ),
        Text(
          "${consumed.toInt()}/${total.toInt()}g",
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}