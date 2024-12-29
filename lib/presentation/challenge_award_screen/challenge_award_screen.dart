import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_image_view.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xFFB2D7FF),
      appBar: _buildAppBar(context),
      body: Consumer<ChallengeAwardProvider>(
        builder: (context, provider, _) {
          final award = provider.challengeAwardModelObj;
          return Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 80.h),
                Image.asset(
                  award.imagePath,
                  height: 280.h,
                  width: 206.h,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 24.h),
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
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      actions: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: EdgeInsets.only(right: 24.h),
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
  }
}