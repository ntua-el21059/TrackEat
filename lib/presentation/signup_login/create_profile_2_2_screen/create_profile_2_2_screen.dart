import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'dart:io' show Platform;
import '../../../core/app_export.dart';
import '../../../theme/custom_button_style.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../providers/user_provider.dart';
import 'provider/create_profile_2_2_provider.dart';
import 'package:flutter/services.dart';

const List<Map<String, String>> activityLevels = [
  {
    'level': 'Light',
    'description': '(Walking, light housework)',
  },
  {
    'level': 'Moderate',
    'description': '(Jogging, cycling, swimming)',
  },
  {
    'level': 'Vigorous',
    'description': '(Running, intense training)',
  },
];

const List<Map<String, String>> dietTypes = [
  {
    'type': 'Balanced',
    'description': '(Mixed diet with all food groups)',
  },
  {
    'type': 'Keto',
    'description': '(Low-carb, high-fat)',
  },
  {
    'type': 'Vegan',
    'description': '(No animal products)',
  },
  {
    'type': 'Vegetarian',
    'description': '(No meat)',
  },
  {
    'type': 'Carnivore',
    'description': '(Meat-based diet)',
  },
  {
    'type': 'Fruitarian',
    'description': '(Primarily fruits)',
  },
  {
    'type': 'Pescatarian',
    'description': '(Fish but no other meat)',
  },
];

const List<Map<String, String>> goalTypes = [
  {
    'type': 'Lose Weight',
    'description': '(Caloric deficit)',
  },
  {
    'type': 'Maintain Weight',
    'description': '(Caloric balance)',
  },
  {
    'type': 'Gain Weight',
    'description': '(Caloric surplus)',
  },
];

class CreateProfile22Screen extends StatefulWidget {
  const CreateProfile22Screen({Key? key}) : super(key: key);

  @override
  CreateProfile22ScreenState createState() => CreateProfile22ScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CreateProfile22Provider(),
      child: CreateProfile22Screen(),
    );
  }
}

class CreateProfile22ScreenState extends State<CreateProfile22Screen> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _weightFocusNode = FocusNode();
  final FocusNode _weeklyGoalFocusNode = FocusNode();
  final FocusNode _goalWeightFocusNode = FocusNode();

  void _scrollToFocusedField(FocusNode focusNode, BuildContext context) {
    if (!mounted) return;

    // Calculate keyboard height
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    
    // Calculate different scroll positions based on which field is focused
    double scrollPosition;
    if (focusNode == _goalWeightFocusNode) {
      scrollPosition = 300.0 + bottomInset;
    } else {
      scrollPosition = _scrollController.position.maxScrollExtent;
    }
    
    // Jump to position immediately
    _scrollController.jumpTo(scrollPosition);
  }

  @override
  void initState() {
    super.initState();
    
    // Add focus listeners
    _weightFocusNode.addListener(() {
      if (_weightFocusNode.hasFocus) {
        _scrollToFocusedField(_weightFocusNode, context);
      }
    });
    _goalWeightFocusNode.addListener(() {
      if (_goalWeightFocusNode.hasFocus) {
        _scrollToFocusedField(_goalWeightFocusNode, context);
      }
    });
    
    // Pre-fill data from UserProvider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<CreateProfile22Provider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userProvider.user;
      
      if (user.activity != null) provider.setActivityLevel(user.activity!);
      if (user.diet != null) provider.setDietType(user.diet!);
      if (user.goal != null) provider.setGoalType(user.goal!);
      if (user.height != null) provider.inputfiveController.text = user.height!.toString();
      if (user.weight != null) provider.inputsevenController.text = user.weight!.toString();
    });
  }

  @override
  void dispose() {
    _weightFocusNode.dispose();
    _weeklyGoalFocusNode.dispose();
    _goalWeightFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _saveDataToUserProvider() {
    final provider = Provider.of<CreateProfile22Provider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    final currentWeight = double.tryParse(provider.inputsevenController.text) ?? 0;
    final isMaintainWeight = provider.goalType == 'Maintain Weight';
    
    userProvider.setProfile2Info(
      activity: provider.activityLevel,
      diet: provider.dietType,
      goal: provider.goalType,
      weight: currentWeight,
      weeklygoal: isMaintainWeight ? 0 : (double.tryParse(provider.weeklyGoalController.text) ?? 0),
      weightgoal: isMaintainWeight ? currentWeight : (double.tryParse(provider.goalWeightController.text) ?? 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardOpen = bottomPadding > 0;
    
    // Reset scroll position immediately when keyboard closes
    if (!isKeyboardOpen && _scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
    
    return Scaffold(
      backgroundColor: theme.colorScheme.onErrorContainer,
      resizeToAvoidBottomInset: false,
      appBar: _buildAppbar(context),
      body: SafeArea(
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 14.h),
          child: Column(
            children: [
              // Fixed title section that doesn't scroll
              Container(
                color: theme.colorScheme.onErrorContainer,
                padding: EdgeInsets.only(top: 12.h),
                child: Center(
                  child: Text(
                    "Let's complete your profile (2/3)",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontSize: 22.0,
                    ),
                  ),
                ),
              ),
              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: isKeyboardOpen ? ClampingScrollPhysics() : NeverScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 52.h,
                      bottom: isKeyboardOpen ? bottomPadding : 0,
                    ),
                    child: Consumer<CreateProfile22Provider>(
                      builder: (context, provider, child) {
                        bool isMaintainWeight = provider.goalType == 'Maintain Weight';
                        
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle(context, "Activity"),
                            SizedBox(height: 8.h),
                            _buildActivityLevel(context),
                            SizedBox(height: 8.h),
                            _buildSectionTitle(context, "Diet (Optional)"),
                            SizedBox(height: 8.h),
                            _buildInputone(context),
                            SizedBox(height: 8.h),
                            _buildSectionTitle(context, "Goal"),
                            SizedBox(height: 8.h),
                            _buildInputthree(context),
                            SizedBox(height: 8.h),
                            _buildSectionTitle(context, "Current weight (Kg)"),
                            SizedBox(height: 8.h),
                            _buildInputseven(context),
                            if (!isMaintainWeight) ...[
                              SizedBox(height: 8.h),
                              _buildSectionTitle(context, "Weekly Goal (Kg)"),
                              SizedBox(height: 8.h),
                              _buildWeeklyGoal(context),
                              SizedBox(height: 8.h),
                              _buildSectionTitle(context, "Goal Weight (Kg)"),
                              SizedBox(height: 8.h),
                              _buildGoalWeight(context),
                            ],
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              _buildNext(context),
              SizedBox(height: 48.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(left: 10.h),
      child: Text(
        title,
        style: CustomTextStyles.titleSmallBlack90015,
      ),
    );
  }

  Widget _buildActivityLevel(BuildContext context) {
    final activityOptions = activityLevels.map((a) => a['level']!).toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      child: Consumer<CreateProfile22Provider>(
        builder: (context, provider, child) {
          return CustomTextFormField(
            readOnly: true,
            showCursor: false,
            controller: TextEditingController(text: provider.activityLevel),
            hintText: "Choose activity level",
            hintStyle: CustomTextStyles.bodyLargeGray500,
            textInputType: TextInputType.text,
            textInputAction: TextInputAction.next,
            textStyle: CustomTextStyles.bodyLargeGray900,
            suffix: Icon(
              Icons.arrow_forward_ios,
              size: 20.h,
              color: appTheme.blueGray100,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 12.h,
            ),
            onTap: () {
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
                    String selectedActivity = provider.activityLevel.isEmpty ? 'Light' : provider.activityLevel;
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
                                  onPressed: () {
                                    provider.setActivityLevel(selectedActivity);
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
                                initialItem: activityOptions.indexOf(selectedActivity),
                              ),
                              itemExtent: 44,
                              onSelectedItemChanged: (int index) {
                                selectedActivity = activityOptions[index];
                              },
                              children: activityLevels.map((activity) => 
                                Center(
                                  child: Text(
                                    "${activity['level']} ${activity['description']}",
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
                            "Select Activity Level",
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          ...activityLevels.map((activity) => ListTile(
                            title: Text(
                              "${activity['level']} ${activity['description']}",
                              style: CustomTextStyles.bodyLargeBlack90018,
                              textAlign: TextAlign.center,
                            ),
                            tileColor: activity['level'] == provider.activityLevel ? Colors.blue.withOpacity(0.1) : null,
                            onTap: () {
                              provider.setActivityLevel(activity['level']!);
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
            },
          );
        },
      ),
    );
  }

  Widget _buildInputone(BuildContext context) {
    final dietOptions = dietTypes.map((d) => d['type']!).toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      child: Consumer<CreateProfile22Provider>(
        builder: (context, provider, child) {
          return CustomTextFormField(
            readOnly: true,
            showCursor: false,
            controller: TextEditingController(text: provider.dietType),
            hintText: "Choose diet type",
            hintStyle: CustomTextStyles.bodyLargeGray500,
            textInputType: TextInputType.text,
            textInputAction: TextInputAction.next,
            textStyle: CustomTextStyles.bodyLargeGray900,
            suffix: Icon(
              Icons.arrow_forward_ios,
              size: 20.h,
              color: appTheme.blueGray100,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 12.h,
            ),
            onTap: () {
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
                    String selectedDiet = provider.dietType.isEmpty ? dietOptions[0] : provider.dietType;
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
                                  onPressed: () {
                                    provider.setDietType(selectedDiet);
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
                                initialItem: dietOptions.indexOf(selectedDiet),
                              ),
                              itemExtent: 44,
                              onSelectedItemChanged: (int index) {
                                selectedDiet = dietOptions[index];
                              },
                              children: dietTypes.map((diet) => 
                                Center(
                                  child: Text(
                                    "${diet['type']} ${diet['description']}",
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
                            "Select Diet Type",
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          ...dietTypes.map((diet) => ListTile(
                            title: Text(
                              "${diet['type']} ${diet['description']}",
                              style: CustomTextStyles.bodyLargeBlack90018,
                              textAlign: TextAlign.center,
                            ),
                            tileColor: diet['type'] == provider.dietType ? Colors.blue.withOpacity(0.1) : null,
                            onTap: () {
                              provider.setDietType(diet['type']!);
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
            },
          );
        },
      ),
    );
  }

  Widget _buildInputthree(BuildContext context) {
    final goalOptions = goalTypes.map((g) => g['type']!).toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      child: Consumer<CreateProfile22Provider>(
        builder: (context, provider, child) {
          return CustomTextFormField(
            readOnly: true,
            showCursor: false,
            controller: TextEditingController(text: provider.goalType),
            hintText: "Choose goal",
            hintStyle: CustomTextStyles.bodyLargeGray500,
            textInputType: TextInputType.text,
            textInputAction: TextInputAction.next,
            textStyle: CustomTextStyles.bodyLargeGray900,
            suffix: Icon(
              Icons.arrow_forward_ios,
              size: 20.h,
              color: appTheme.blueGray100,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 12.h,
            ),
            onTap: () {
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
                    String selectedGoal = provider.goalType.isEmpty ? goalOptions[0] : provider.goalType;
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
                                  onPressed: () {
                                    provider.setGoalType(selectedGoal);
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
                                initialItem: goalOptions.indexOf(selectedGoal),
                              ),
                              itemExtent: 44,
                              onSelectedItemChanged: (int index) {
                                selectedGoal = goalOptions[index];
                              },
                              children: goalTypes.map((goal) => 
                                Center(
                                  child: Text(
                                    "${goal['type']} ${goal['description']}",
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
                            "Select Goal",
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          ...goalTypes.map((goal) => ListTile(
                            title: Text(
                              "${goal['type']} ${goal['description']}",
                              style: CustomTextStyles.bodyLargeBlack90018,
                              textAlign: TextAlign.center,
                            ),
                            tileColor: goal['type'] == provider.goalType ? Colors.blue.withOpacity(0.1) : null,
                            onTap: () {
                              provider.setGoalType(goal['type']!);
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
            },
          );
        },
      ),
    );
  }

  Widget _buildInputseven(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      child: Consumer<CreateProfile22Provider>(
        builder: (context, provider, child) {
          return CustomTextFormField(
            focusNode: _weightFocusNode,
            controller: provider.inputsevenController,
            hintText: "Enter weight",
            hintStyle: CustomTextStyles.bodyLargeGray500,
            textInputType: TextInputType.number,
            textInputAction: TextInputAction.next,
            textStyle: CustomTextStyles.bodyLargeGray900,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 12.h,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWeeklyGoal(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      child: Consumer<CreateProfile22Provider>(
        builder: (context, provider, child) {
          bool isMaintainWeight = provider.goalType == 'Maintain Weight';
          bool isLoseWeight = provider.goalType == 'Lose Weight';
          
          return CustomTextFormField(
            focusNode: _weeklyGoalFocusNode,
            readOnly: true,
            showCursor: false,
            enabled: !isMaintainWeight,
            controller: provider.weeklyGoalController,
            hintText: "Enter weekly goal",
            hintStyle: CustomTextStyles.bodyLargeGray500,
            textInputType: TextInputType.number,
            textInputAction: TextInputAction.next,
            textStyle: isMaintainWeight 
                ? CustomTextStyles.bodyLargeGray500
                : CustomTextStyles.bodyLargeGray900,
            suffix: Icon(
              Icons.arrow_forward_ios,
              size: 20.h,
              color: appTheme.blueGray100,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 12.h,
            ),
            onTap: isMaintainWeight ? null : () {
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
                                  onPressed: () {
                                    double value = provider.selectedValue;
                                    if (isLoseWeight) value = -value;
                                    provider.weeklyGoalController.text = 
                                      value.toStringAsFixed(1);
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
                                initialItem: (provider.selectedValue * 10).round(),
                              ),
                              itemExtent: 44,
                              onSelectedItemChanged: (int index) {
                                provider.setSelectedValue(index * 0.1);
                              },
                              children: List<Widget>.generate(16, (index) {
                                final value = index * 0.1;
                                final displayValue = isLoseWeight ? -value : value;
                                return Center(
                                  child: Text(
                                    '${displayValue.toStringAsFixed(1)} kg',
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
                    );
                  },
                );
              } else {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  ),
                  builder: (BuildContext context) {
                    return Container(
                      height: 250,
                      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 20.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Weekly Goal",
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Expanded(
                            child: CupertinoPicker(
                              scrollController: FixedExtentScrollController(
                                initialItem: (provider.selectedValue * 10).round(),
                              ),
                              itemExtent: 44,
                              onSelectedItemChanged: (int index) {
                                provider.setSelectedValue(index * 0.1);
                              },
                              children: List<Widget>.generate(16, (index) {
                                final value = index * 0.1;
                                final displayValue = isLoseWeight ? -value : value;
                                return Center(
                                  child: Text(
                                    '${displayValue.toStringAsFixed(1)} kg',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Cancel'),
                              ),
                              SizedBox(width: 16.h),
                              TextButton(
                                onPressed: () {
                                  double value = provider.selectedValue;
                                  if (isLoseWeight) value = -value;
                                  provider.weeklyGoalController.text = 
                                    value.toStringAsFixed(1);
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
            },
          );
        },
      ),
    );
  }

  Widget _buildGoalWeight(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      child: Consumer<CreateProfile22Provider>(
        builder: (context, provider, child) {
          bool isMaintainWeight = provider.goalType == 'Maintain Weight';
          
          return CustomTextFormField(
            focusNode: _goalWeightFocusNode,
            readOnly: isMaintainWeight,
            enabled: !isMaintainWeight,
            controller: provider.goalWeightController,
            hintText: "Enter goal weight",
            hintStyle: CustomTextStyles.bodyLargeGray500,
            textInputType: TextInputType.number,
            textInputAction: TextInputAction.done,
            textStyle: isMaintainWeight 
                ? CustomTextStyles.bodyLargeGray500
                : CustomTextStyles.bodyLargeGray900,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 12.h,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNext(BuildContext context) {
    return Consumer<CreateProfile22Provider>(
      builder: (context, provider, child) {
        bool isMaintainWeight = provider.goalType == 'Maintain Weight';
        bool isFormValid = provider.activityLevel.isNotEmpty &&  // Check activity level
            provider.goalType.isNotEmpty &&       // Check goal type
            provider.inputsevenController.text.isNotEmpty &&   // Check weight
            (isMaintainWeight || provider.weeklyGoalController.text.isNotEmpty) &&   // Check weekly goal if not maintain weight
            (isMaintainWeight || provider.goalWeightController.text.isNotEmpty);     // Check goal weight if not maintain weight
            // Note: diet is optional, so we don't check it

        return CustomElevatedButton(
          height: 48.h,
          width: 114.h,
          text: "Next",
          buttonStyle: isFormValid 
              ? CustomButtonStyles.fillPrimary
              : CustomButtonStyles.fillGray,
          buttonTextStyle: theme.textTheme.titleMedium!,
          alignment: Alignment.centerRight,
          onPressed: isFormValid ? () {
            _saveDataToUserProvider();
            Navigator.pushNamed(context, AppRoutes.calorieCalculatorScreen);
          } : null,
        );
      },
    );
  }

  /// AppBar Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 28.h,
      leadingWidth: 31.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftPrimary,
        height: 20.h,
        width: 20.h,
        margin: EdgeInsets.only(left: 7.h),
        onTap: () {
          _saveDataToUserProvider();
          Navigator.pop(context);
        },
      ),
    );
  }
}
