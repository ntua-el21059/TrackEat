import 'package:responsive_grid_list/responsive_grid_list.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_two.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../profile_screen/provider/profile_provider.dart';
import 'models/gridvector_one_item_model.dart';
import 'models/listvegan_item_model.dart';
import 'provider/social_profile_myself_provider.dart';
import 'widgets/gridvector_one_item_widget.dart';
import 'widgets/listvegan_item_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widgets/cached_profile_picture.dart';

class SocialProfileMyselfScreen extends StatefulWidget {
  final String? backButtonText;
  
  const SocialProfileMyselfScreen({
    Key? key,
    this.backButtonText,
  }) : super(key: key);

  @override
  SocialProfileMyselfScreenState createState() => SocialProfileMyselfScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SocialProfileMyselfProvider()..init(context),
      child: Consumer<ProfileProvider>(
        builder: (context, profileProvider, _) {
          // Get current diet and update social provider
          final diet = profileProvider.profileModelObj.profileItemList
              .firstWhere((item) => item.title == "Diet")
              .value;
          
          Provider.of<SocialProfileMyselfProvider>(context, listen: false)
              .updateDietBox(diet ?? 'Carnivore');
          
          return const SocialProfileMyselfScreen();
        },
      ),
    );
  }

  // Add a new builder method for navigation from leaderboard
  static Widget builderFromLeaderboard(BuildContext context, {String? backButtonText}) {
    return ChangeNotifierProvider(
      create: (context) => SocialProfileMyselfProvider()..init(context),
      child: Consumer<ProfileProvider>(
        builder: (context, profileProvider, _) {
          // Get current diet and update social provider
          final diet = profileProvider.profileModelObj.profileItemList
              .firstWhere((item) => item.title == "Diet")
              .value;
          
          Provider.of<SocialProfileMyselfProvider>(context, listen: false)
              .updateDietBox(diet ?? 'Carnivore');
          
          return SocialProfileMyselfScreen(backButtonText: backButtonText);
        },
      ),
    );
  }
}

class SocialProfileMyselfScreenState extends State<SocialProfileMyselfScreen> {
  @override
  void initState() {
    super.initState();
    // Wait for the widget to be built before accessing providers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SocialProfileMyselfProvider>(context, listen: false).init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(context),
        body: Container(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: const Color(0xFFB2D7FF),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(54.h),
              topRight: Radius.circular(54.h),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(54.h),
              topRight: Radius.circular(54.h),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 8.h,
                  top: 8.h,
                  right: 8.h,
                  bottom: MediaQuery.of(context).padding.bottom + 18.h,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    _buildRowvectorone(context),
                    SizedBox(height: 6.h),
                    _buildWeightgoal(context),
                    SizedBox(height: 12.h),
                    _buildListvegan(context),
                    SizedBox(height: 8.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.h),
                        child: Text(
                          "Awards",
                          style: CustomTextStyles.headlineSmallOnErrorContainerBold,
                        ),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    _buildGridvectorone(context)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildListvegan(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      width: double.maxFinite,
      child: Consumer<SocialProfileMyselfProvider>(
        builder: (context, provider, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(
                provider.socialProfileMyselfModelObj.listveganItemList.length,
                (index) {
                  ListveganItemModel model =
                      provider.socialProfileMyselfModelObj.listveganItemList[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index == 0 ? 16.h : 0,
                    ),
                    child: ListveganItemWidget(model),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildGridvectorone(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.h),
      child: Consumer<SocialProfileMyselfProvider>(
        builder: (context, provider, child) {
          return ResponsiveGridListBuilder(
            minItemWidth: 1,
            minItemsPerRow: 3,
            maxItemsPerRow: 3,
            horizontalGridSpacing: 18.h,
            verticalGridSpacing: 18.h,
            builder: (context, items) => ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              children: items,
            ),
            gridItems: List.generate(
              provider.socialProfileMyselfModelObj.gridvectorOneItemList.length,
              (index) {
                GridvectorOneItemModel model =
                    provider.socialProfileMyselfModelObj.gridvectorOneItemList[index];
                return GridvectorOneItemWidget(
                  model,
                  index: index,
                );
              },
            ),
          );
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildRowvectorone(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      padding: EdgeInsets.all(16.h),
      decoration: null,
      child: Column(
        children: [
          Row(
            children: [
              FirebaseAuth.instance.currentUser?.email != null
                ? CachedProfilePicture(
                    email: FirebaseAuth.instance.currentUser!.email!,
                    size: 80.h,
                  )
                : _buildDefaultProfilePicture(),
              SizedBox(width: 12.h),
              Expanded(
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser?.email)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null && snapshot.data!.exists) {
                      final userData = snapshot.data!.data() as Map<String, dynamic>;
                      final firstName = userData['firstName']?.toString() ?? '';
                      final lastName = userData['lastName']?.toString() ?? '';
                      final username = userData['username']?.toString() ?? '';
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "$firstName $lastName",
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: const Color(0xFF37474F),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "@$username",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF37474F).withOpacity(0.7),
                            ),
                          ),
                        ],
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: CustomElevatedButton(
                  text: "Add Friend",
                  height: 48.h,
                  rightIcon: Container(
                    margin: EdgeInsets.only(left: 6.h),
                    child: SizedBox(
                      height: 16.h,
                      width: 16.h,
                      child: CustomImageView(
                        imagePath: ImageConstant.imgAddFriend,
                        fit: BoxFit.contain,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  buttonStyle: CustomButtonStyles.fillBlueGrayTL16,
                  buttonTextStyle: CustomTextStyles.titleSmallSemiBold,
                ),
              ),
              SizedBox(width: 14.h),
              Expanded(
                child: CustomElevatedButton(
                  text: "Message",
                  height: 48.h,
                  buttonStyle: CustomButtonStyles.fillBlueGrayTL16,
                  buttonTextStyle: CustomTextStyles.titleSmallSemiBold,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildWeightgoal(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.email)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox();
        }

        final data = snapshot.data!.data() as Map<String, dynamic>?;
        final firstName = data?['firstName']?.toString() ?? '';
        final gender = data?['gender']?.toString().toLowerCase() ?? '';
        final hasWeightGoal = data?.containsKey('weightgoal') ?? false;
        
        String getPronoun() {
          switch (gender) {
            case 'male':
              return 'his';
            case 'female':
              return 'her';
            default:
              return 'their';
          }
        }
        
        if (!hasWeightGoal) {
          return Container(
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(horizontal: 16.h),
            padding: EdgeInsets.all(16.h),
            decoration: BoxDecoration(
              color: const Color(0xFF8FB8E0).withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "😕 $firstName has not set ${getPronoun()} weight goal yet",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.h),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(4.h),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 100,
                        child: const SizedBox(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        final currentWeight = double.tryParse(data?['weight']?.toString() ?? '0') ?? 0;
        final goalWeight = double.tryParse(data?['weightgoal']?.toString() ?? '0') ?? 0;
        
        int progress = 0;
        if (currentWeight > 0) {
          double calculation = (1 - ((currentWeight - goalWeight) / currentWeight)) * 100;
          progress = calculation.round().clamp(0, 100);
        }

        return Container(
          width: double.maxFinite,
          margin: EdgeInsets.symmetric(horizontal: 16.h),
          padding: EdgeInsets.all(16.h),
          decoration: BoxDecoration(
            color: const Color(0xFF8FB8E0).withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "🎉 $firstName has hit $progress% of ${getPronoun()} weight goal!",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                height: 8.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.h),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: progress,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(4.h),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 100 - progress,
                      child: const SizedBox(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 23.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftPrimary,
        margin: EdgeInsets.only(left: 7.h),
        onTap: () => Navigator.pop(context),
      ),
      title: TextButton(
        onPressed: () => Navigator.pop(context),
        style: TextButton.styleFrom(
          padding: EdgeInsets.only(left: 7.h),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          widget.backButtonText ?? "Profile",
          style: theme.textTheme.bodyLarge!.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
      ),
      actions: [
        AppbarSubtitleTwo(
          text: "PROFILE PREVIEW",
          margin: EdgeInsets.only(
            right: 20.h,
          ),
        )
      ],
    );
  }

  Widget _buildDefaultProfilePicture() {
    return Container(
      height: 80.h,
      width: 80.h,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        shape: BoxShape.circle,
      ),
      child: SvgPicture.asset(
        'assets/images/person.crop.circle.fill.svg',
        height: 80.h,
        width: 80.h,
        fit: BoxFit.cover,
      ),
    );
  }
}