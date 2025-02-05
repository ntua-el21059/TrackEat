import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
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
  StreamSubscription<QuerySnapshot>? _awardsSubscription;
  final PointsService _pointsService = PointsService();
  bool _isNavigatingToReward = false;
  final Set<String> _shownAwards = {};
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _initPrefs();
    _initializeUI();
    // Check for monthly points reset
    _pointsService.checkAndResetMonthlyPoints();
    // Fetch current user data immediately
    _fetchInitialUserData();
    _setupFirestoreListener();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    final email = FirebaseAuth.instance.currentUser?.email;
    if (email != null) {
      _shownAwards.addAll(_prefs?.getStringList('shown_awards_${email}') ?? []);
    }
    _setupAwardsListener();
  }

  void _initializeUI() {
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

  Future<void> _markAwardAsShown(String awardId) async {
    final email = FirebaseAuth.instance.currentUser?.email;
    if (email != null && _prefs != null) {
      _shownAwards.add(awardId);
      await _prefs!.setStringList(
        'shown_awards_${email}',
        _shownAwards.toList()
      );
    }
  }

  void _setupAwardsListener() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser?.email == null) return;

    print('Setting up awards listener for user: ${currentUser?.email}');

    _awardsSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser?.email)
        .collection('awards')
        .snapshots()
        .listen((snapshot) {
      if (!mounted) return;

      for (var change in snapshot.docChanges) {
        print('Award change detected: ${change.type}');
        print('Award data: ${change.doc.data()}');
        
        if (change.type == DocumentChangeType.modified) {
          final awardData = change.doc.data();
          final awardId = change.doc.id;
          
          if (awardData != null && 
              awardData['isAwarded'] == true && 
              !_shownAwards.contains(awardId) &&
              !_isNavigatingToReward) {
            print('Navigating to reward screen for award: ${awardData['name']}');
            _isNavigatingToReward = true;
            _markAwardAsShown(awardId);
            Navigator.pushNamed(
              context, 
              AppRoutes.rewardScreenNewAwardScreen,
              arguments: {
                'awardId': awardId,
                'awardName': awardData['name'],
                'awardDescription': awardData['description'],
                'awardPicture': awardData['picture'],
                'awardPoints': awardData['points'] is String ? int.parse(awardData['points']) : (awardData['points'] as num?)?.toInt() ?? 0,
                'awardedTime': DateTime.now(),
              }
            ).then((_) {
              _isNavigatingToReward = false;
            });
            break;
          }
        }
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
          
          // Check rings status and show reward if needed
          checkRingsAndShowReward(userData);
          
          // Force UI update
          setState(() {});
        }
      });
    }
  }

  void checkRingsAndShowReward(Map<String, dynamic> userData) async {
    // Prevent multiple navigations
    if (_isNavigatingToReward) return;
    
    // Get the current values from meal history
    final userEmail = FirebaseAuth.instance.currentUser?.email;
    if (userEmail == null) return;

    final mealService = MealService();
    final now = DateTime.now();
    
    // Get actual consumed macros from meal history
    final macros = await mealService.getTotalMacrosForDate(userEmail, now);
    final proteinConsumed = macros['protein'] ?? 0.0;
    final fatConsumed = macros['fats'] ?? 0.0;
    final carbsConsumed = macros['carbs'] ?? 0.0;

    // Get the goals from userData
    final proteinGoal = double.tryParse(userData['proteingoal']?.toString() ?? '0') ?? 98.0;
    final fatGoal = double.tryParse(userData['fatgoal']?.toString() ?? '0') ?? 70.0;
    final carbsGoal = double.tryParse(userData['carbsgoal']?.toString() ?? '0') ?? 110.0;

    // Calculate percentages
    final proteinPercent = (proteinConsumed / proteinGoal * 100).clamp(0, 100);
    final fatPercent = (fatConsumed / fatGoal * 100).clamp(0, 100);
    final carbsPercent = (carbsConsumed / carbsGoal * 100).clamp(0, 100);

    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    final bool allRingsClosed = proteinPercent >= 100 && fatPercent >= 100 && carbsPercent >= 100;
    final bool ringsWereClosed = await homeProvider.areRingsClosed();

    if (!allRingsClosed) {
      // If any ring is not at 100%, set the variable to 0
      await homeProvider.setRingChanged(false);
      await homeProvider.setRingsClosed(false);
    } else if (!ringsWereClosed) {
      // Rings are now closed but weren't before, show reward
      if (mounted) {
        _isNavigatingToReward = true;
        Navigator.pushNamed(context, AppRoutes.rewardScreenRingsClosedScreen);
      }
      await homeProvider.setRingsClosed(true);
      await homeProvider.setRingChanged(true);
    }
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    _awardsSubscription?.cancel();
    _shownAwards.clear(); // Clear the set on dispose
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
            carbsgoal:
                double.tryParse(userData['carbsgoal']?.toString() ?? '0'),
            proteingoal:
                double.tryParse(userData['proteingoal']?.toString() ?? '0'),
            fatgoal: double.tryParse(userData['fatgoal']?.toString() ?? '0'),
          );
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Disable back button and swipe gesture
      child: Scaffold(
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
      ),
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
                    itemCount:
                        provider.homeInitialModelObj.cardsItemList.length,
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
                  if (snapshot.hasData &&
                      snapshot.data != null &&
                      snapshot.data!.exists) {
                    final userData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    final profilePicture =
                        userData['profilePicture'] as String?;

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
