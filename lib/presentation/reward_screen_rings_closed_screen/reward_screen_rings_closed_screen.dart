import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';
import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import 'models/reward_screen_rings_closed_model.dart';
import 'provider/reward_screen_rings_closed_provider.dart';
import '../../widgets/custom_image_view.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';
import 'package:confetti/confetti.dart';
import '../homepage_history/home_screen/provider/home_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../homepage_history/home_screen/home_screen.dart';

class RewardScreenRingsClosedScreen extends StatefulWidget {
  const RewardScreenRingsClosedScreen({Key? key}) : super(key: key);

  @override
  RewardScreenRingsClosedScreenState createState() =>
      RewardScreenRingsClosedScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RewardScreenRingsClosedProvider(),
      child: const RewardScreenRingsClosedScreen(),
    );
  }
}

class RewardScreenRingsClosedScreenState
    extends State<RewardScreenRingsClosedScreen> {
  late ConfettiController _confettiController;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 30));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.stop();
    _confettiController.dispose();
    super.dispose();
  }

  void _navigateToHome() async {
    if (_isNavigating) return;
    
    setState(() {
      _isNavigating = true;
    });

    // Mark reward as shown before navigating
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    await homeProvider.markRewardScreenAsShown();

    if (!mounted) return;

    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.homeScreen,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _navigateToHome();
        return false;
      },
      child: Scaffold(
        backgroundColor: theme.colorScheme.onErrorContainer,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final screenHeight = constraints.maxHeight;
              final screenWidth = constraints.maxWidth;
              final platterWidth = screenWidth - 40.h;
              
              return SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Container(
                  height: screenHeight,
                  width: screenWidth,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Multiple confetti sources across the top
                      Positioned(
                        top: 0,
                        child: SizedBox(
                          width: screenWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(8, (index) => // 8 sources across the screen
                              SizedBox(
                                width: screenWidth / 8,
                                child: ConfettiWidget(
                                  confettiController: _confettiController,
                                  blastDirection: pi/2,
                                  blastDirectionality: BlastDirectionality.directional,
                                  maxBlastForce: 20.0,
                                  minBlastForce: 10.0,
                                  emissionFrequency: 0.05,
                                  numberOfParticles: 5,
                                  gravity: 0.1,
                                  shouldLoop: true,
                                  colors: const [
                                    Colors.green,
                                    Colors.blue,
                                    Colors.pink,
                                    Colors.orange,
                                    Colors.purple,
                                    Colors.yellow,
                                    Colors.red,
                                    Colors.teal,
                                  ],
                                  minimumSize: const Size(8, 8),
                                  maximumSize: const Size(15, 15),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Main content
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Congratulations!",
                              style: theme.textTheme.displayMedium,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              "You closed your rings!",
                              style: theme.textTheme.headlineSmall,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      // Dismiss button
                      Positioned(
                        bottom: 50.h,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.h),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                    AppRoutes.homeScreen,
                                    (route) => false,
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 32.h,
                                    vertical: 12.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20.h),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.15),
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Text(
                                    "Dismiss",
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.9),
                                      fontSize: 17.h,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

