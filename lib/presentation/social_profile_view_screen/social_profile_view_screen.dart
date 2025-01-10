import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../social_profile_message_from_profile_screen/social_profile_message_from_profile_screen.dart';
import '../social_profile_myself_screen/widgets/gridvector_one_item_widget.dart';
import '../social_profile_myself_screen/widgets/listvegan_item_widget.dart';
import '../social_profile_myself_screen/models/gridvector_one_item_model.dart';
import '../social_profile_myself_screen/models/listvegan_item_model.dart';
import '../../services/friend_service.dart';

class SocialProfileViewScreen extends StatefulWidget {
  final String username;
  final String backButtonText;
  
  // Static cache for profile pictures
  static final Map<String, Uint8List> _profilePictureCache = {};
  
  const SocialProfileViewScreen({
    Key? key,
    required this.username,
    this.backButtonText = "Profile",
  }) : super(key: key);

  @override
  SocialProfileViewScreenState createState() => SocialProfileViewScreenState();

  static Widget builder(BuildContext context, {required String username, String backButtonText = "Profile"}) {
    print('SocialProfileViewScreen.builder called with username: $username, backButtonText: $backButtonText');
    return SocialProfileViewScreen(
      username: username,
      backButtonText: backButtonText,
    );
  }
}

class SocialProfileViewScreenState extends State<SocialProfileViewScreen> {
  late Stream<DocumentSnapshot> _userStream;

  @override
  void initState() {
    super.initState();
    _setupUserStream();
  }

  void _setupUserStream() {
    _userStream = FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: widget.username)
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) {
            throw Exception('User not found');
          }
          return snapshot.docs.first;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _userStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Container(
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
                      _buildRowvectorone(context, snapshot.data!),
                      SizedBox(height: 6.h),
                      _buildWeightgoal(context, snapshot.data!),
                      SizedBox(height: 12.h),
                      _buildListvegan(context, snapshot.data!),
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
                      _buildGridvectorone(context, snapshot.data!)
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    print('_buildAppBar called with backButtonText: ${widget.backButtonText}');
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

  Widget _buildRowvectorone(BuildContext context, DocumentSnapshot userData) {
    final data = userData.data() as Map<String, dynamic>?;
    final firstName = data?['firstName']?.toString() ?? '';
    final lastName = data?['lastName']?.toString() ?? '';
    final username = data?['username']?.toString() ?? '';
    final email = data?['email']?.toString() ?? '';
    final profilePicture = data?['profilePicture'] as String?;

    // Check if we need to update the cache
    if (profilePicture != null && profilePicture.isNotEmpty) {
      final decodedImage = base64Decode(profilePicture);
      if (!SocialProfileViewScreen._profilePictureCache.containsKey(username) ||
          !listEquals(SocialProfileViewScreen._profilePictureCache[username]!, decodedImage)) {
        SocialProfileViewScreen._profilePictureCache[username] = decodedImage;
      }
    }

    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      padding: EdgeInsets.all(16.h),
      child: Column(
        children: [
          Row(
            children: [
              ClipOval(
                child: SocialProfileViewScreen._profilePictureCache.containsKey(username)
                    ? Image.memory(
                        SocialProfileViewScreen._profilePictureCache[username]!,
                        height: 80.h,
                        width: 80.h,
                        fit: BoxFit.cover,
                      )
                    : Container(
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

  Widget _buildWeightgoal(BuildContext context, DocumentSnapshot userData) {
    final data = userData.data() as Map<String, dynamic>?;
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
  }

  Widget _buildListvegan(BuildContext context, DocumentSnapshot userData) {
    final data = userData.data() as Map<String, dynamic>?;
    final firstName = data?['firstName']?.toString() ?? '';
    final diet = data?['diet']?.toString() ?? 'Balanced';
    final createdDate = data?['create']?.toString();
    final username = data?['username']?.toString() ?? '';

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

    String _calculateTimeDifference(String createdDate) {
      try {
        final parts = createdDate.split('/');
        if (parts.length != 3) return "some time";

        final createdDateTime = DateTime(
          int.parse(parts[2]), // year
          int.parse(parts[1]), // month
          int.parse(parts[0]), // day
        );
        
        final now = DateTime.now();
        final difference = now.difference(createdDateTime);
        final days = difference.inDays;
        
        if (days >= 365) {
          final years = days ~/ 365;
          return "$years year${years > 1 ? 's' : ''}";
        } else if (days >= 30) {
          final months = (days / 30.44).floor();
          return "$months month${months > 1 ? 's' : ''}";
        } else {
          return "$days day${days > 1 ? 's' : ''}";
        }
      } catch (e) {
        return "some time";
      }
    }

    String timeDifference = "some time";
    if (createdDate != null && createdDate.isNotEmpty) {
      timeDifference = _calculateTimeDifference(createdDate);
    }

    final listveganItemList = [
      ListveganItemModel(title: getDietWithEmoji(diet), count: ""),
      ListveganItemModel(
        title: "$firstName has been thriving \nwith us for $timeDifference!",
        count: "⭐️",
        username: username,
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
                child: ListveganItemWidget(model),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGridvectorone(BuildContext context, DocumentSnapshot userData) {
    final gridvectorOneItemList = [
      GridvectorOneItemModel(image: ImageConstant.imgAward1),
      GridvectorOneItemModel(image: ImageConstant.imgAward2),
      GridvectorOneItemModel(image: ImageConstant.imgAward3),
      GridvectorOneItemModel(image: ImageConstant.imgAward4),
      GridvectorOneItemModel(image: ImageConstant.imgAward5),
      GridvectorOneItemModel(image: ImageConstant.imgAward6),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.h),
      child: ResponsiveGridListBuilder(
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
          gridvectorOneItemList.length,
          (index) {
            GridvectorOneItemModel model = gridvectorOneItemList[index];
            return GridvectorOneItemWidget(
              model,
              index: index,
            );
          },
        ),
      ),
    );
  }
}

class FriendButton extends StatefulWidget {
  final String userId;
  
  // Static cache for friend status
  static final Map<String, bool> _friendStatusCache = {};

  const FriendButton({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  _FriendButtonState createState() => _FriendButtonState();
}

class _FriendButtonState extends State<FriendButton> {
  final FriendService _friendService = FriendService();
  bool _isFriend = false;
  bool _isLoading = false;
  StreamSubscription? _friendStatusSubscription;

  @override
  void initState() {
    super.initState();
    // First check the cache
    if (FriendButton._friendStatusCache.containsKey(widget.userId)) {
      _isFriend = FriendButton._friendStatusCache[widget.userId]!;
      _isLoading = false;
    } else {
      // If not in cache, do initial fetch
      _checkFriendStatus();
    }
    // Setup stream listener for changes
    _setupFriendStatusListener();
  }

  @override
  void dispose() {
    _friendStatusSubscription?.cancel();
    super.dispose();
  }

  void _setupFriendStatusListener() {
    _friendStatusSubscription = _friendService.getFriendStatusStream(widget.userId).listen((isFollowing) {
      if (mounted && FriendButton._friendStatusCache[widget.userId] != isFollowing) {
        setState(() {
          _isFriend = isFollowing;
          _isLoading = false;
        });
        FriendButton._friendStatusCache[widget.userId] = isFollowing;
      }
    });
  }

  Future<void> _checkFriendStatus() async {
    if (!FriendButton._friendStatusCache.containsKey(widget.userId)) {
      setState(() => _isLoading = true);
      final isFollowing = await _friendService.isFollowing(widget.userId);
      if (mounted) {
        setState(() {
          _isFriend = isFollowing;
          _isLoading = false;
        });
        FriendButton._friendStatusCache[widget.userId] = isFollowing;
      }
    }
  }

  Future<void> _toggleFriendStatus() async {
    setState(() => _isLoading = true);
    try {
      if (_isFriend) {
        await _friendService.removeFriend(widget.userId);
      } else {
        await _friendService.addFriend(widget.userId);
      }
      // Update cache immediately for better UX
      FriendButton._friendStatusCache[widget.userId] = !_isFriend;
      if (mounted) {
        setState(() {
          _isFriend = !_isFriend;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error toggling friend status: $e');
      // Revert cache on error
      FriendButton._friendStatusCache[widget.userId] = _isFriend;
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      text: _isLoading ? "Loading..." : (_isFriend ? "Friends" : "Add Friend"),
      height: 48.h,
      rightIcon: _isLoading 
          ? SizedBox(
              height: 16.h,
              width: 16.h,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Container(
              margin: EdgeInsets.only(left: 6.h),
              child: SizedBox(
                height: 16.h,
                width: 16.h,
                child: CustomImageView(
                  imagePath: _isFriend ? ImageConstant.imgFriendsIcon : ImageConstant.imgAddFriend,
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
      onPressed: _isLoading ? null : _toggleFriendStatus,
    );
  }
} 