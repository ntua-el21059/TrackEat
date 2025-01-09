import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import '../../../core/app_export.dart';
import '../../../providers/user_provider.dart';
import '../../../widgets/custom_bottom_bar.dart';
import '../../../widgets/app_bar/appbar_subtitle_one.dart';
import '../../../widgets/app_bar/appbar_title.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/motion_widget.dart';
import 'models/cards_item_model.dart';
import 'provider/home_provider.dart';
import 'widgets/cards_item_widget.dart';
import '../../../presentation/profile_screen/profile_screen.dart';
import '../../../providers/profile_picture_provider.dart';
import '../../../services/meal_service.dart';
import '../../../widgets/calories_macros_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../services/points_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
  final PointsService _pointsService = PointsService();

  @override
  void initState() {
    super.initState();

    // Check for monthly points reset
    _pointsService.checkAndResetMonthlyPoints();

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
        Provider.of<HomeProvider>(context, listen: false)
            .updateSuggestions(context);
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
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);

          // Update provider with fresh Firestore values
          userProvider
              .setDailyCalories(userData['dailyCalories'] as int? ?? 2000);
          userProvider.setMacronutrientGoals(
            carbsGoal:
                double.tryParse(userData['carbsgoal']?.toString() ?? '0'),
            proteinGoal:
                double.tryParse(userData['proteingoal']?.toString() ?? '0'),
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
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);

          // Update provider with fresh Firestore values
          userProvider
              .setDailyCalories(userData['dailyCalories'] as int? ?? 2000);
          userProvider.setMacronutrientGoals(
            carbsGoal:
                double.tryParse(userData['carbsgoal']?.toString() ?? '0'),
            proteinGoal:
                double.tryParse(userData['proteingoal']?.toString() ?? '0'),
            fatGoal: double.tryParse(userData['fatgoal']?.toString() ?? '0'),
          );
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

  void checkRingsAndShowReward(Map<String, dynamic> userData) async {
    final proteinGoal =
        double.tryParse(userData['proteingoal']?.toString() ?? '0') ?? 0.0;
    final fatGoal =
        double.tryParse(userData['fatgoal']?.toString() ?? '0') ?? 0.0;
    final carbsGoal =
        double.tryParse(userData['carbsgoal']?.toString() ?? '0') ?? 0.0;

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
    final bool ringsAreNowClosed =
        proteinPercent >= 100 && fatPercent >= 100 && carbsPercent >= 100;
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
      extendBodyBehindAppBar: false,
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
                if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data!.exists) {
                  final userData =
                      snapshot.data!.data() as Map<String, dynamic>;
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
        _buildProfilePicture(context),
      ],
    );
  }

  /// Section Widget
  Widget _buildCalories(BuildContext context) {
    return MotionWidget(
      sensitivity: 4.0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOutQuad,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(21),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 30,
              offset: const Offset(0, 15),
              spreadRadius: 4,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(21),
          child: CaloriesMacrosWidget(
            selectedDate: DateTime.now(),
            isLoading: _isLoading,
            isHomeScreen: true,
            showHistoryButton: true,
            ringRadius: 60,
            ringWidth: 15,
            padding: EdgeInsets.all(22.h),
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionsone(BuildContext context) {
    return MotionWidget(
      sensitivity: 4.0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOutQuad,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFBAB2),
          borderRadius: BorderRadius.circular(21),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 30,
              offset: const Offset(0, 15),
              spreadRadius: 4,
            ),
          ],
        ),
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(
            bottom: 22.h,
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
                      CardsItemModel model =
                          provider.homeInitialModelObj.cardsItemList[index];
                      return CardsItemWidget(model);
                    },
                  );
                },
              ),
            ],
          ),
        ),
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
              if (mounted) {
                Navigator.pushNamed(context, AppRoutes.leaderboardScreen);
              }
              break;
            case BottomBarEnum.AI:
              Navigator.pushNamed(context, AppRoutes.aiChatMainScreen);
              break;
          }
        },
      ),
    );
  }

  Widget _buildProfilePicture(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
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
            return ClipOval(
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser?.email)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null && snapshot.data!.exists) {
                    final userData = snapshot.data!.data() as Map<String, dynamic>;
                    final profilePicture = userData['profilePicture'] as String?;
                    
                    if (profilePicture != null && profilePicture.isNotEmpty) {
                      return Image.memory(
                        base64Decode(profilePicture),
                        height: 40.h,
                        width: 40.h,
                        fit: BoxFit.cover,
                        gaplessPlayback: true,
                      );
                    }
                  }
                  
                  return Container(
                    height: 40.h,
                    width: 40.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      'assets/images/person.crop.circle.fill.svg',
                      height: 40.h,
                      width: 40.h,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
