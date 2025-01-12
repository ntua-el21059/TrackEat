import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/cached_profile_picture.dart';
import '../social_profile_message_from_profile_screen/social_profile_message_from_profile_screen.dart';
import '../social_profile_myself_screen/widgets/listvegan_item_widget.dart';
import '../social_profile_myself_screen/models/listvegan_item_model.dart';
import '../../models/award_model.dart';
import '../challenge_award_screen/challenge_award_screen.dart';
import 'provider/social_profile_view_provider.dart';

class SocialProfileViewScreen extends StatefulWidget {
  final String username;
  final String backButtonText;
  
  const SocialProfileViewScreen({
    Key? key,
    required this.username,
    this.backButtonText = "Profile",
  }) : super(key: key);

  @override
  SocialProfileViewScreenState createState() => SocialProfileViewScreenState();

  static Widget builder(BuildContext context, {required String username, String backButtonText = "Profile"}) {
    // Create and initialize provider with cached data
    final provider = SocialProfileViewProvider();
    provider.initWithUsername(username);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SocialProfileViewProvider>.value(
          value: provider,
        ),
      ],
      child: Container(
        color: const Color(0xFFB2D7FF), // Match parent background color
        child: SocialProfileViewScreen(
          username: username,
          backButtonText: backButtonText,
        ),
      ),
    );
  }
}

class SocialProfileViewScreenState extends State<SocialProfileViewScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger data fetch in background after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<SocialProfileViewProvider>(context, listen: false)
          .prefetchAllData(widget.username);
      }
    });
  }

  String getPronoun(String gender) {
    switch (gender.toLowerCase()) {
      case 'male':
        return 'his';
      case 'female':
        return 'her';
      default:
        return 'their';
    }
  }

  Widget _buildRowvectorone(BuildContext context, DocumentSnapshot userData) {
    final data = userData.data() as Map<String, dynamic>?;
    final firstName = data?['firstName']?.toString() ?? '';
    final lastName = data?['lastName']?.toString() ?? '';
    final username = data?['username']?.toString() ?? '';
    final email = data?['email']?.toString() ?? '';

    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      padding: EdgeInsets.all(16.h),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                height: 80.h,
                width: 80.h,
                child: CachedProfilePicture(
                  email: email,
                  size: 80.h,
                ),
              ),
              SizedBox(width: 12.h),
              Expanded(
                child: Column(
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
                            fontSize: 24.h,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "@$username",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF37474F),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: FriendButton(userId: email),
              ),
              SizedBox(width: 14.h),
              Expanded(
                child: CustomElevatedButton(
                  text: "Message",
                  height: 48.h,
                  buttonStyle: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.h),
                      ),
                    ),
                    elevation: MaterialStateProperty.all(0),
                  ),
                  buttonTextStyle: CustomTextStyles.titleSmallSemiBold.copyWith(color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SocialProfileMessageFromProfileScreen.builder(
                          context,
                          receiverId: userData.id,
                          receiverName: "${data?['firstName']} ${data?['lastName']}",
                          receiverUsername: data?['username'],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGridvectorone(BuildContext context) {
    return Consumer<SocialProfileViewProvider>(
      builder: (context, provider, _) {
        final userData = provider.getCachedUser(widget.username);
        if (userData == null) return const SizedBox.shrink();
        
        final data = userData.data() as Map<String, dynamic>?;
        final email = data?['email'] as String?;
        if (email == null) return const SizedBox.shrink();
        
        final awards = provider.getCachedAwards(email);
        if (awards == null || awards.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.h),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = (constraints.maxWidth - 36.h) / 3;
              return Wrap(
                spacing: 18.h,
                runSpacing: 18.h,
                children: awards.map((award) {
                  return SizedBox(
                    width: itemWidth,
                    child: _buildAwardItem(award),
                  );
                }).toList(),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildAwardItem(Award award) {
    return GestureDetector(
      onTap: award.isAwarded ? () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChallengeAwardScreen.builder(
              context,
              award: award,
            ),
          ),
        );
      } : null,
      child: Container(
        padding: EdgeInsets.all(12.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(award.isAwarded ? 0.5 : 0.1),
          borderRadius: BorderRadius.circular(12.h),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Opacity(
                opacity: award.isAwarded ? 1.0 : 0.3,
                child: Image.asset(
                  award.picture,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Icon(Icons.error));
                  },
                ),
              ),
            ),
            if (!award.isAwarded)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(8.h),
                child: Icon(
                  Icons.lock,
                  color: Colors.black.withOpacity(0.7),
                  size: 28.h,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeightgoal(BuildContext context, DocumentSnapshot userData) {
    final data = userData.data() as Map<String, dynamic>?;
    final firstName = data?['firstName']?.toString() ?? '';
    final gender = data?['gender']?.toString() ?? '';
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
            "🎉 $firstName has hit $progress% of ${getPronoun(gender)} weight goal!",
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
  }

  Widget _buildListvegan(BuildContext context) {
    return Consumer<SocialProfileViewProvider>(
      builder: (context, provider, _) {
        final userData = provider.getCachedUser(widget.username);
        if (userData == null) return const SizedBox.shrink();

        final Map<String, dynamic> data;
        try {
          data = Map<String, dynamic>.from(userData.data() as Map<String, dynamic>);
        } catch (e) {
          return const SizedBox.shrink();
        }

        final firstName = data['firstName']?.toString() ?? '';
        final username = data['username']?.toString() ?? '';
        final diet = data['diet']?.toString() ?? '';
        final create = data['create']?.toString() ?? '';

        String getDietWithEmoji(String diet) {
          return switch (diet.trim()) {
            'Vegan' => 'Vegan🌱',
            'Carnivore' => 'Carnivore🥩',
            'Vegetarian' => 'Vegetarian🥗',
            'Pescatarian' => 'Pescatarian🐟',
            'Keto' => 'Keto🥑',
            'Fruitarian' => 'Fruitarian🍎',
            _ => 'Balanced🥗'
          };
        }

        DateTime? createdDate;
        if (create.isNotEmpty) {
          final parts = create.split('/');
          if (parts.length == 3) {
            createdDate = DateTime(
              int.parse(parts[2]), // year
              int.parse(parts[1]), // month
              int.parse(parts[0]), // day
            );
          }
        }

        String timeDifference = "some time";
        if (createdDate != null) {
          final now = DateTime.now();
          final difference = now.difference(createdDate);
          final days = difference.inDays;
          
          if (days >= 365) {
            final years = days ~/ 365;
            timeDifference = "$years year${years > 1 ? 's' : ''}";
          } else if (days >= 30) {
            final months = (days / 30.44).floor();
            timeDifference = "$months month${months > 1 ? 's' : ''}";
          } else {
            timeDifference = "$days day${days > 1 ? 's' : ''}";
          }
        }

        final listveganItemList = [
          ListveganItemModel(
            title: getDietWithEmoji(diet),
            isStatic: true,
          ),
          ListveganItemModel(
            title: "$firstName has been thriving \nwith us for $timeDifference!",
            count: "⭐️",
            username: username,
            isStatic: false,
          ),
        ];

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.h),
          width: double.maxFinite,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(
                listveganItemList.length,
                (index) {
                  ListveganItemModel model = listveganItemList[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index == 0 ? 16.h : 0,
                    ),
                    child: ListveganItemWidget(
                      key: ValueKey('${model.username}_${model.isStatic}_${model.title}'),
                      model,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

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
          widget.backButtonText,
          style: theme.textTheme.bodyLarge!.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Consumer<SocialProfileViewProvider>(
            builder: (context, provider, _) {
              final userData = provider.getCachedUser(widget.username);
              
              // Show loading skeleton with same background color if no cached data
              if (userData == null) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16.h),
                    child: Column(
                      children: [
                        _buildLoadingSkeleton(),
                      ],
                    ),
                  ),
                );
              }

              return SingleChildScrollView(
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
                      _buildRowvectorone(context, userData),
                      SizedBox(height: 6.h),
                      _buildWeightgoal(context, userData),
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
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Column(
      children: [
        // Profile skeleton
        Container(
          width: double.maxFinite,
          margin: EdgeInsets.symmetric(horizontal: 16.h),
          padding: EdgeInsets.all(16.h),
          child: Row(
            children: [
              Container(
                height: 80.h,
                width: 80.h,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(40.h),
                ),
              ),
              SizedBox(width: 12.h),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24.h,
                      width: 150.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12.h),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      height: 16.h,
                      width: 100.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8.h),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        // Buttons skeleton
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.h),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16.h),
                  ),
                ),
              ),
              SizedBox(width: 14.h),
              Expanded(
                child: Container(
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16.h),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class FriendButton extends StatelessWidget {
  final String userId;

  const FriendButton({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SocialProfileViewProvider>(
      builder: (context, provider, _) {
        final isFriend = provider.getFriendStatus(userId) ?? false;

        return CustomElevatedButton(
          text: isFriend ? "Friends" : "Add Friend",
          height: 48.h,
          rightIcon: Container(
            margin: EdgeInsets.only(left: 6.h),
            child: SizedBox(
              height: 16.h,
              width: 16.h,
              child: CustomImageView(
                imagePath: isFriend ? ImageConstant.imgFriendsIcon : ImageConstant.imgAddFriend,
                fit: BoxFit.contain,
                color: Colors.white,
              ),
            ),
          ),
          buttonStyle: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(theme.colorScheme.primary),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.h),
              ),
            ),
            elevation: MaterialStateProperty.all(0),
          ),
          buttonTextStyle: CustomTextStyles.titleSmallSemiBold.copyWith(color: Colors.white),
          onPressed: () => provider.toggleFriendStatus(userId),
        );
      },
    );
  }
} 