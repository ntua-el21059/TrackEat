import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/appbar_subtitle.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../models/meal.dart';
import 'provider/history_today_tab_provider.dart';
import '../blur_choose_action_screen_dialog/blur_choose_action_screen_dialog.dart';
import '../../../widgets/calories_macros_widget.dart';

class HistoryTodayTabScreen extends StatefulWidget {
  const HistoryTodayTabScreen({Key? key}) : super(key: key);

  @override
  HistoryTodayTabScreenState createState() => HistoryTodayTabScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HistoryTodayTabProvider(),
      child: HistoryTodayTabScreen(),
    );
  }
}

class HistoryTodayTabScreenState extends State<HistoryTodayTabScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  
  // Add PageControllers for each meal type
  final PageController _breakfastController = PageController();
  final PageController _lunchController = PageController();
  final PageController _dinnerController = PageController();

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Simulate loading delay
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _animateAndNavigate(bool goingBack) {
    final provider = Provider.of<HistoryTodayTabProvider>(context, listen: false);
    
    setState(() {
      _slideAnimation = Tween<Offset>(
        begin: Offset(goingBack ? 1 : -1, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeOutCubic,
      ));
    });

    // Reset to start position
    _slideController.value = 0;
    
    // Start animation
    _slideController.forward();

    // Update the date after a small delay to allow animation to start
    Future.delayed(Duration(milliseconds: 200), () {
      if (goingBack) {
        provider.goToPreviousDay();
      } else if (provider.canGoForward()) {
        provider.goToNextDay();
      }
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _breakfastController.dispose();
    _lunchController.dispose();
    _dinnerController.dispose();
    super.dispose();
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 4.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 4.h),
              child: Text(
                "History",
                style: theme.textTheme.headlineMedium,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Consumer<HistoryTodayTabProvider>(
                builder: (context, provider, _) => Column(
                  children: [
                    Text(
                      provider.isToday() 
                        ? "TODAY"
                        : "${provider.getDaysDifference()} ${provider.getDaysDifference() == 1 ? 'DAY' : 'DAYS'} AGO",
                      style: TextStyle(
                        color: provider.isToday() ? const Color(0xFF4CD964) : Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      provider.getFormattedDate().toUpperCase(),
                      style: CustomTextStyles.labelLargeSFProBluegray400,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8.h),
            _buildCalories(context),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.only(left: 18.h),
              child: Text(
                "Breakfast",
                style: CustomTextStyles.headlineSmallBold,
              ),
            ),
            SizedBox(height: 4.h),
            _buildBreakfastSection(context),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.only(left: 18.h),
              child: Text(
                "Lunch",
                style: CustomTextStyles.headlineSmallBold,
              ),
            ),
            SizedBox(height: 4.h),
            _buildLunchSection(context),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.only(left: 18.h),
              child: Text(
                "Dinner",
                style: CustomTextStyles.headlineSmallBold,
              ),
            ),
            SizedBox(height: 4.h),
            _buildDinnerSection(context),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.onErrorContainer,
      appBar: _buildAppbar(context),
      body: SafeArea(
        top: false,
        child: GestureDetector(
          onHorizontalDragEnd: (details) {
            // Require minimum velocity and distance for swipe
            if (details.primaryVelocity!.abs() < 800) {  // Minimum velocity threshold
              return;
            }
            
            final provider = Provider.of<HistoryTodayTabProvider>(context, listen: false);
            if (details.primaryVelocity! > 0) { // Swiping right (to go back)
              _animateAndNavigate(true);
            } else if (details.primaryVelocity! < 0 && provider.canGoForward()) { // Swiping left (to go forward)
              // Double check we're not on today's date
              if (!provider.isToday()) {
                _animateAndNavigate(false);
              }
            }
          },
          child: Stack(
            children: [
              SlideTransition(
                position: _slideAnimation,
                child: _buildMainContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 36.h,
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
        margin: EdgeInsets.only(left: 4.h),
      ),
    );
  }

  /// Section Widget
  Widget _buildCalories(BuildContext context) {
    return Consumer<HistoryTodayTabProvider>(
      builder: (context, provider, _) {
        return CaloriesMacrosWidget(
          selectedDate: provider.selectedDate,
          isLoading: _isLoading,
          isHomeScreen: false,
          showHistoryButton: false,
          ringRadius: 60,
          ringWidth: 15,
          padding: EdgeInsets.symmetric(
            horizontal: 8.h,
            vertical: 12.h,
          ),
        );
      },
    );
  }

  Widget _buildMacroColumn(String value, String label, Color color, double progress) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 4,
                height: 32 * progress,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 6.h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }


  Widget _buildEmptyBreakfast(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 22.h),
      padding: EdgeInsets.all(8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFB2D7FF)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Log your breakfast!",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Container(
            width: 40.h,
            height: 40.h,
            decoration: BoxDecoration(
              color: const Color(0xFFB2D7FF),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
                size: 20.h,
              ),
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.aiChatMainScreen);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyLunch(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 22.h),
      padding: EdgeInsets.all(8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFB2D7FF)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 8.h),
          Text(
            "Log your lunch!",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Container(
            width: 40.h,
            height: 40.h,
            decoration: BoxDecoration(
              color: const Color(0xFFB2D7FF),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
                size: 20.h,
              ),
              onPressed: () {
                // Navigate to AI main page
                Navigator.pushNamed(context, AppRoutes.aiChatMainScreen);
              },
            ),
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  Widget _buildEmptyDinner(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 22.h),
      padding: EdgeInsets.all(8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFB2D7FF)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 8.h),
          Text(
            "Log your dinner!",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Container(
            width: 40.h,
            height: 40.h,
            decoration: BoxDecoration(
              color: const Color(0xFFB2D7FF),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
                size: 20.h,
              ),
              onPressed: () {
                // Navigate to AI main page
                Navigator.pushNamed(context, AppRoutes.aiChatMainScreen);
              },
            ),
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }


  Widget _buildMealCard(BuildContext context, Meal meal, String mealType) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 22.h),
      padding: EdgeInsets.all(8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFB2D7FF)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.name,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Text(
                        "🔥",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        " ${meal.calories} kcal -${meal.servingSize.toInt()}g",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(178, 215, 255, 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return BlurChooseActionScreenDialog.builder(
                          dialogContext,
                          mealType,
                          () {
                            Provider.of<HistoryTodayTabProvider>(context, listen: false).deleteMeal(meal.id);
                          },
                          meal,
                        );
                      },
                    );
                  },
                  child: Icon(Icons.more_horiz, color: Colors.black54, size: 16),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMacroColumn(
                "${meal.macros['protein']?.toInt()}g",
                "Protein",
                const Color(0xFFFA114F),
                0.7,
              ),
              _buildMacroColumn(
                "${meal.macros['fats']?.toInt()}g",
                "Fats",
                const Color(0xFFA6FF00),
                0.5,
              ),
              _buildMacroColumn(
                "${meal.macros['carbs']?.toInt()}g",
                "Carbs",
                const Color(0xFF00FFF6),
                0.3,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBreakfastSection(BuildContext context) {
    return Consumer<HistoryTodayTabProvider>(
      builder: (context, provider, child) {
        final breakfastMeals = provider.getMealsByType('breakfast');
        return Container(
          height: 110.h,
          child: PageView.builder(
            controller: _breakfastController,
            physics: const BouncingScrollPhysics(),
            pageSnapping: true,
            itemCount: breakfastMeals.isEmpty ? 1 : breakfastMeals.length + 1,
            itemBuilder: (context, index) {
              if (index < breakfastMeals.length) {
                return _buildMealCard(context, breakfastMeals[index], 'breakfast');
              } else {
                return _buildEmptyBreakfast(context);
              }
            },
          ),
        );
      }
    );
  }

  Widget _buildLunchSection(BuildContext context) {
    return Consumer<HistoryTodayTabProvider>(
      builder: (context, provider, child) {
        final lunchMeals = provider.getMealsByType('lunch');
        return Container(
          height: 110.h,
          child: PageView.builder(
            controller: _lunchController,
            physics: const BouncingScrollPhysics(),
            pageSnapping: true,
            itemCount: lunchMeals.isEmpty ? 1 : lunchMeals.length + 1,
            itemBuilder: (context, index) {
              if (index < lunchMeals.length) {
                return _buildMealCard(context, lunchMeals[index], 'lunch');
              } else {
                return _buildEmptyLunch(context);
              }
            },
          ),
        );
      }
    );
  }

  Widget _buildDinnerSection(BuildContext context) {
    return Consumer<HistoryTodayTabProvider>(
      builder: (context, provider, child) {
        final dinnerMeals = provider.getMealsByType('dinner');
        return Container(
          height: 110.h,
          child: PageView.builder(
            controller: _dinnerController,
            physics: const BouncingScrollPhysics(),
            pageSnapping: true,
            itemCount: dinnerMeals.isEmpty ? 1 : dinnerMeals.length + 1,
            itemBuilder: (context, index) {
              if (index < dinnerMeals.length) {
                return _buildMealCard(context, dinnerMeals[index], 'dinner');
              } else {
                return _buildEmptyDinner(context);
              }
            },
          ),
        );
      }
    );
  }
}
