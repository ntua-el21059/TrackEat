import 'package:flutter/services.dart';
import '../../core/app_export.dart';
import 'provider/challenge_award_provider.dart';

class ChallengeAwardScreen extends StatefulWidget {
  final int awardIndex;
  const ChallengeAwardScreen({Key? key, this.awardIndex = 0}) : super(key: key);

  @override
  ChallengeAwardScreenState createState() => ChallengeAwardScreenState();

  static Widget builder(BuildContext context, {int awardIndex = 0}) {
    return ChangeNotifierProvider(
      create: (context) => ChallengeAwardProvider(awardIndex: awardIndex),
      child: ChallengeAwardScreen(awardIndex: awardIndex),
    );
  }
}

class ChallengeAwardScreenState extends State<ChallengeAwardScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFB2D7FF),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Color(0xFFB2D7FF),
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: Color(0xFFB2D7FF),
          systemNavigationBarDividerColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Consumer<ChallengeAwardProvider>(
            builder: (context, provider, _) {
              final award = provider.challengeAwardModelObj;
              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 24.h,
                        right: 24.h,
                        top: MediaQuery.of(context).padding.top,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 120.h),
                          Image.asset(
                            award.imagePath,
                            height: 280.h,
                            width: 206.h,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(height: 40.h),
                          Text(
                            award.title,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            "Earned on ${award.earnedDate}",
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            award.description,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 16.h,
                    right: 24.h,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: CustomImageView(
                        imagePath: ImageConstant.imgXButton,
                        height: 24.h,
                        width: 24.h,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}