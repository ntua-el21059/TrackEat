import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
  @override
  void initState() {
    super.initState();
    
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

  void _saveDataToUserProvider() {
    final provider = Provider.of<CreateProfile22Provider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    userProvider.setProfile2Info(
      activity: provider.activityLevel,
      diet: provider.dietType,
      goal: provider.goalType,
      height: double.tryParse(provider.inputfiveController.text) ?? 0,
      weight: double.tryParse(provider.inputsevenController.text) ?? 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _saveDataToUserProvider();
        return true;
      },
      child: Scaffold(
        backgroundColor: theme.colorScheme.onErrorContainer,
        resizeToAvoidBottomInset: false,
        appBar: _buildAppbar(context),
        body: SafeArea(
          top: false,
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 14.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      SizedBox(height: 12.h),
                      Text(
                        "Let's complete your profile (2/3)",
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontSize: 22.0,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 52.h),
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
                _buildSectionTitle(context, "Height (cm)"),
                SizedBox(height: 8.h),
                _buildInputfive(context),
                SizedBox(height: 8.h),
                _buildSectionTitle(context, "Current weight (Kg)"),
                SizedBox(height: 8.h),
                _buildInputseven(context),
                Spacer(),
                _buildNext(context),
                SizedBox(height: 48.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

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

    return Consumer<CreateProfile22Provider>(
      builder: (context, provider, child) {
        return GestureDetector(
          onTap: () {
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
                        itemExtent: 44.0,
                        onSelectedItemChanged: (int index) {
                          provider.setActivityLevel(activityOptions[index]);
                        },
                        children: activityLevels.map((activity) => 
                          Text(
                            "${activity['level']} ${activity['description']}",
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
                builder: (BuildContext context) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: activityLevels.length,
                      itemBuilder: (context, index) {
                        final activity = activityLevels[index];
                        return ListTile(
                          title: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: activity['level']!,
                                  style: CustomTextStyles.bodyLargeBlack90018,
                                ),
                                TextSpan(
                                  text: ' ${activity['description']!}',
                                  style: CustomTextStyles.bodyLargeGray50003,
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            provider.setActivityLevel(activity['level']!);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
          child: Container(
            margin: EdgeInsets.only(
              left: 8.h,
              right: 16.h,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 12.h,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: appTheme.blueGray100,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    provider.activityLevel.isEmpty 
                        ? "Choose activity level" 
                        : provider.activityLevel,
                    style: provider.activityLevel.isEmpty
                        ? CustomTextStyles.bodyLargeGray500
                        : TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 20.h,
                  color: appTheme.blueGray100,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputone(BuildContext context) {
    final dietOptions = dietTypes.map((d) => d['type']!).toList();

    return Consumer<CreateProfile22Provider>(
      builder: (context, provider, child) {
        return GestureDetector(
          onTap: () {
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
                        itemExtent: 44.0,
                        onSelectedItemChanged: (int index) {
                          provider.setDietType(dietOptions[index]);
                        },
                        children: dietTypes.map((diet) => 
                          Text(
                            "${diet['type']} ${diet['description']}",
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
                builder: (BuildContext context) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: dietTypes.length,
                      itemBuilder: (context, index) {
                        final diet = dietTypes[index];
                        return ListTile(
                          title: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: diet['type']!,
                                  style: CustomTextStyles.bodyLargeBlack90018,
                                ),
                                TextSpan(
                                  text: ' ${diet['description']!}',
                                  style: CustomTextStyles.bodyLargeGray50003,
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            provider.setDietType(diet['type']!);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
          child: Container(
            margin: EdgeInsets.only(
              left: 8.h,
              right: 16.h,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 12.h,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: appTheme.blueGray100,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    provider.dietType.isEmpty 
                        ? "Choose diet type" 
                        : provider.dietType,
                    style: provider.dietType.isEmpty
                        ? CustomTextStyles.bodyLargeGray500
                        : TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 20.h,
                  color: appTheme.blueGray100,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputthree(BuildContext context) {
    final goalOptions = goalTypes.map((g) => g['type']!).toList();

    return Consumer<CreateProfile22Provider>(
      builder: (context, provider, child) {
        return GestureDetector(
          onTap: () {
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
                        itemExtent: 44.0,
                        onSelectedItemChanged: (int index) {
                          provider.setGoalType(goalOptions[index]);
                        },
                        children: goalTypes.map((goal) => 
                          Text(
                            "${goal['type']} ${goal['description']}",
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
                builder: (BuildContext context) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: goalTypes.length,
                      itemBuilder: (context, index) {
                        final goal = goalTypes[index];
                        return ListTile(
                          title: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: goal['type']!,
                                  style: CustomTextStyles.bodyLargeBlack90018,
                                ),
                                TextSpan(
                                  text: ' ${goal['description']!}',
                                  style: CustomTextStyles.bodyLargeGray50003,
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            provider.setGoalType(goal['type']!);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
          child: Container(
            margin: EdgeInsets.only(
              left: 8.h,
              right: 16.h,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 12.h,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: appTheme.blueGray100,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    provider.goalType.isEmpty 
                        ? "Choose goal" 
                        : provider.goalType,
                    style: provider.goalType.isEmpty
                        ? CustomTextStyles.bodyLargeGray500
                        : TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 20.h,
                  color: appTheme.blueGray100,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputfive(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      child: Selector<CreateProfile22Provider, TextEditingController?>(
        selector: (context, provider) => provider.inputfiveController,
        builder: (context, inputfiveController, child) {
          return Container(
            margin: EdgeInsets.only(
              left: 0.h,
              right: 8.h,
            ),
            child: CustomTextFormField(
              controller: inputfiveController,
              hintText: "Enter your height",
              hintStyle: CustomTextStyles.bodyLargeGray500,
              textInputType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                FilteringTextInputFormatter.deny(RegExp(r'^0+')),
              ],
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.h,
                vertical: 12.h,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputseven(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      child: Selector<CreateProfile22Provider, TextEditingController?>(
        selector: (context, provider) => provider.inputsevenController,
        builder: (context, inputsevenController, child) {
          return Container(
            margin: EdgeInsets.only(
              left: 0.h,
              right: 8.h,
            ),
            child: CustomTextFormField(
              controller: inputsevenController,
              hintText: "Enter your current weight",
              hintStyle: CustomTextStyles.bodyLargeGray500,
              textInputType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                FilteringTextInputFormatter.deny(RegExp(r'^0+')),
              ],
              textInputAction: TextInputAction.done,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.h,
                vertical: 12.h,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNext(BuildContext context) {
    return Consumer<CreateProfile22Provider>(
      builder: (context, provider, child) {
        bool isFormValid = 
            provider.activityLevel.isNotEmpty &&  // Check activity level
            provider.goalType.isNotEmpty &&       // Check goal type
            provider.inputfiveController.text.isNotEmpty &&  // Check height
            provider.inputsevenController.text.isNotEmpty;   // Check weight
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
            // Save to UserProvider
            final userProvider = Provider.of<UserProvider>(context, listen: false);
            userProvider.setProfile2Info(
              activity: provider.activityLevel,
              diet: provider.dietType,
              goal: provider.goalType,
              height: double.tryParse(provider.inputfiveController.text) ?? 0,
              weight: double.tryParse(provider.inputsevenController.text) ?? 0,
            );
            
            Navigator.pushNamed(context, AppRoutes.calorieCalculatorScreen);
          } : null,
        );
      },
    );
  }
}
