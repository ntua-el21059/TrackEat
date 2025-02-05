import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../core/app_export.dart';
import '../../../theme/custom_button_style.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../providers/user_provider.dart';
import '../../../services/firebase/auth/auth_provider.dart' as app_auth;
import 'provider/calorie_calculator_provider.dart';
import '../../../services/firebase/firestore/firestore_service.dart';
import '../../../services/awards_service.dart';
import '../../../models/award_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CalorieCalculatorScreen extends StatefulWidget {
  const CalorieCalculatorScreen({Key? key}) : super(key: key);

  @override
  CalorieCalculatorScreenState createState() => CalorieCalculatorScreenState();

  static Widget builder(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CalorieCalculatorProvider(),
        ),
        Provider<FirestoreService>(
          create: (context) => FirestoreService(),
        ),
      ],
      child: CalorieCalculatorScreen(),
    );
  }
}

class CalorieCalculatorScreenState extends State<CalorieCalculatorScreen> {
  @override
  void initState() {
    super.initState();
    
    // Pre-fill data from UserProvider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<CalorieCalculatorProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userProvider.user;
      
      // Calculate calories based on user data
      final weight = user.weight ?? 70.0; // default weight if not set
      final height = user.height ?? 170.0; // default height if not set
      final age = user.age ?? 25; // default age if not set
      final gender = user.gender?.toLowerCase() ?? 'male'; // default gender if not set
      
      final calculatedCalories = provider.calculateDailyCalories(weight, height, age, gender);
      provider.zipcodeController.text = calculatedCalories.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;
    final provider = Provider.of<CalorieCalculatorProvider>(context, listen: false);
    
    final weight = user.weight ?? 70.0;
    final height = user.height ?? 170.0;
    final age = user.age ?? 25;
    final gender = user.gender?.toLowerCase() ?? 'male';
    
    final calculatedCalories = provider.calculateDailyCalories(weight, height, age, gender);
    provider.zipcodeController.text = calculatedCalories.toString();

    return Scaffold(
      backgroundColor: theme.colorScheme.onErrorContainer,
      resizeToAvoidBottomInset: false,
      appBar: _buildAppbar(context),
      body: SafeArea(
        top: false,
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 14.h),
          child: Column(
            children: [
              SizedBox(height: 12.h),
              Text(
                "Let's complete your profile (3/3)",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontSize: 22.0,
                ),
              ),
              SizedBox(height: 60.h),
              Text(
                "Our calorie calculator made a personalized\nestimation for your calorie consumption\nat $calculatedCalories kcal daily.\nWould you like to set it as your daily goal\nor input your own calorie choice?",
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  height: 1.38,
                  color: Colors.black87,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 78.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.h),
                  child: Text(
                    "Calories per day ",
                    style: CustomTextStyles.titleSmallBlack90015,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.h),
                child: Selector<CalorieCalculatorProvider, TextEditingController?>(
                  selector: (context, provider) => provider.zipcodeController,
                  builder: (context, zipcodeController, child) {
                    return CustomTextFormField(
                      controller: zipcodeController,
                      hintText: "2400",
                      hintStyle: CustomTextStyles.bodyLargeGray500,
                      textInputAction: TextInputAction.done,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.h,
                        vertical: 12.h,
                      ),
                    );
                  },
                ),
              ),
              Spacer(),
              CustomElevatedButton(
                height: 48.h,
                width: 114.h,
                text: "Finish",
                margin: EdgeInsets.only(right: 8.h),
                buttonStyle: CustomButtonStyles.fillPrimary,
                buttonTextStyle: theme.textTheme.titleMedium!,
                alignment: Alignment.centerRight,
                onPressed: () async {
                  final provider = Provider.of<CalorieCalculatorProvider>(context, listen: false);
                  final userProvider = Provider.of<UserProvider>(context, listen: false);
                  final authProvider = Provider.of<app_auth.AuthProvider>(context, listen: false);
                  
                  // Parse calories
                  int? calories = int.tryParse(provider.zipcodeController.text);
                  if (calories == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter a valid calorie value')),
                    );
                    return;
                  }
                  
                  // Save calories to UserProvider
                  userProvider.setDailyCalories(calories);
                  
                  try {
                    print('Starting user creation process...');
                    print('User data to be saved: ${userProvider.user.toJson()}');
                    
                    // Create Firebase Auth user first
                    final success = await authProvider.signUp(
                      userProvider.user.email!,
                      userProvider.user.password!,
                    );
                    
                    if (!success) {
                      print('Failed to create Firebase Auth user. Error: ${authProvider.lastError}');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(authProvider.lastError ?? 'Failed to create account'),
                          duration: Duration(seconds: 5),
                        ),
                      );
                      return;
                    }
                    
                    print('Successfully created Firebase Auth user');
                    
                    // Wait for Firebase Auth to fully initialize
                    await Future.delayed(Duration(seconds: 1));
                    
                    // Get current date in D/M/YEAR format
                    final now = DateTime.now();
                    final formattedDate = "${now.day}/${now.month}/${now.year}";
                    
                    // Add creation date to user data
                    userProvider.user.create = formattedDate;
                    
                    // Test Firestore connection and save user data
                    final firestoreService = Provider.of<FirestoreService>(context, listen: false);
                    
                    try {
                      // Create user document first
                      await firestoreService.createUser(userProvider.user);
                      print('Successfully saved user data to Firestore');

                      // Wait for auth to propagate
                      await Future.delayed(Duration(seconds: 1));

                      // Copy existing awards from Firestore
                      try {
                        final awardsCollection = await FirebaseFirestore.instance
                            .collection('awards')
                            .get();

                        // Add each award to the user's awards subcollection
                        final awardsService = AwardsService();
                        for (final doc in awardsCollection.docs) {
                          final awardData = doc.data();
                          final award = Award(
                            id: doc.id,
                            name: awardData['name'] ?? '',
                            points: awardData['points'] is int 
                                ? awardData['points'] 
                                : int.tryParse(awardData['points']?.toString() ?? '0') ?? 0,
                            description: awardData['description'] ?? '',
                            picture: awardData['picture'] ?? 'assets/images/vector.png',
                            isAwarded: false,
                            awarded: null,
                          );
                          await awardsService.addOrUpdateAward(userProvider.user.email!, award);
                        }
                        print('Successfully copied awards to user subcollection');
                      } catch (awardsError) {
                        print('Error copying awards: $awardsError');
                        // Continue anyway since this is not critical
                      }
                      
                      // Navigate to finalized account screen
                      Navigator.pushNamed(context, AppRoutes.finalizedAccountScreen);
                    } catch (firestoreError) {
                      print('Error saving to Firestore: $firestoreError');
                      
                      // If there's a permission error, try signing out and back in
                      if (firestoreError.toString().contains('permission-denied')) {
                        await authProvider.signOut(context);
                        final reloginSuccess = await authProvider.signIn(
                          context,
                          userProvider.user.email!,
                          userProvider.user.password!,
                        );
                        
                        if (reloginSuccess) {
                          // Retry saving to Firestore
                          try {
                            await firestoreService.createUser(userProvider.user);
                            print('Successfully saved user data after reauth');
                            Navigator.pushNamed(context, AppRoutes.finalizedAccountScreen);
                            return;
                          } catch (retryError) {
                            print('Error saving after reauth: $retryError');
                          }
                        }
                      }
                      
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error saving user data: ${firestoreError.toString()}'),
                            duration: Duration(seconds: 5),
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    print('Error in account creation process: $e');
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error creating account: ${e.toString()}'),
                          duration: Duration(seconds: 5),
                        ),
                      );
                    }
                  }
                },
              ),
              SizedBox(height: 48.h)
            ],
          ),
        ),
      ),
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
          Navigator.pop(context);
        },
      ),
    );
  }
}
