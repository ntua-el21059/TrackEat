import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/app_export.dart';
import '../../../../theme/custom_text_style.dart';
import '../../../../widgets/custom_elevated_button.dart';
import '../../../../theme/custom_button_style.dart';
import '../models/notifications_model.dart';
import '../notifications_screen.dart';
import '../../../../services/friend_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../presentation/social_profile_message_from_profile_screen/social_profile_message_from_profile_screen.dart';

class ReadTwoItemWidget extends StatefulWidget {
  ReadTwoItemWidget(this.notification, {Key? key}) : super(key: key);

  final NotificationItem notification;

  @override
  State<ReadTwoItemWidget> createState() => _ReadTwoItemWidgetState();
}

class _ReadTwoItemWidgetState extends State<ReadTwoItemWidget> {
  bool isAdded = false;
  final FriendService _friendService = FriendService();

  @override
  void initState() {
    super.initState();
    _checkIfAlreadyFriends();
  }

  Future<void> _checkIfAlreadyFriends() async {
    try {
      final username = widget.notification.message.split(' ')[0].replaceAll('@', '');
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();
      
      if (userDoc.docs.isNotEmpty) {
        final userEmail = userDoc.docs.first.data()['email'] as String;
        final isFollowing = await _friendService.isFollowing(userEmail);
        if (mounted) {
          setState(() {
            isAdded = isFollowing;
          });
        }
      }
    } catch (e) {
      print('Error checking friend status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.h),
      padding: EdgeInsets.all(8.h),
      decoration: (widget.notification.isRead
              ? AppDecoration.lightGreyButtonsPadding
              : AppDecoration.lightBlueLayoutPadding)
          .copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder20,
      ),
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 4.h),
              child: Text(
                widget.notification.message,
                style: CustomTextStyles.titleSmallBold,
              ),
            ),
          ),
          _buildButton(context),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    final message = widget.notification.message.toLowerCase();

    if (message.contains("added you")) {
      // Extract username from notification message (e.g., "@username added you as a friend")
      final username = widget.notification.message.split(' ')[0].replaceAll('@', '');
      
      return CustomElevatedButton(
        width: 74.h,
        text: isAdded ? "Added" : "Add",
        onPressed: () async {
          try {
            if (!isAdded) {
              // Get user email from username
              final userDoc = await FirebaseFirestore.instance
                  .collection('users')
                  .where('username', isEqualTo: username)
                  .limit(1)
                  .get();
              
              if (userDoc.docs.isNotEmpty) {
                final userEmail = userDoc.docs.first.data()['email'] as String;
                await _friendService.addFriend(userEmail);
                
                // Mark notification as read
                final currentUser = FirebaseAuth.instance.currentUser;
                if (currentUser?.email != null) {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUser!.email)
                      .collection('notifications')
                      .doc(widget.notification.id)
                      .update({'isRead': true});
                }
                
                // Create notifications subcollection if it doesn't exist
                final userRef = FirebaseFirestore.instance
                    .collection('users')
                    .doc(userEmail);
                    
                final notificationsCollection = userRef.collection('notifications');
                
                // Check if notifications subcollection exists
                final notificationsQuery = await notificationsCollection.limit(1).get();
                if (notificationsQuery.docs.isEmpty) {
                  // Create an initial notification to ensure the subcollection exists
                  await notificationsCollection.add({
                    'message': 'Welcome to TrackEat!',
                    'timestamp': FieldValue.serverTimestamp(),
                    'isRead': false,
                    'type': 'welcome',
                  });
                }
                
                setState(() {
                  isAdded = true;
                });
              }
            } else {
              // Get user email from username
              final userDoc = await FirebaseFirestore.instance
                  .collection('users')
                  .where('username', isEqualTo: username)
                  .limit(1)
                  .get();
              
              if (userDoc.docs.isNotEmpty) {
                final userEmail = userDoc.docs.first.data()['email'] as String;
                await _friendService.removeFriend(userEmail);
                
                // Get current user's username to find and delete the notification
                final currentUser = FirebaseAuth.instance.currentUser;
                if (currentUser?.email != null) {
                  final currentUserDoc = await FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUser!.email)
                      .get();
                  
                  if (currentUserDoc.exists) {
                    final currentUsername = currentUserDoc.data()?['username'] as String?;
                    if (currentUsername != null) {
                      // Delete the notification from the other user's notifications
                      final notificationsQuery = await FirebaseFirestore.instance
                          .collection('users')
                          .doc(userEmail)
                          .collection('notifications')
                          .where('message', isEqualTo: '@$currentUsername added you as a friend')
                          .get();
                          
                      for (var doc in notificationsQuery.docs) {
                        await doc.reference.delete();
                      }
                    }
                  }
                }
                
                setState(() {
                  isAdded = false;
                });
              }
            }
          } catch (e) {
            print('Error handling friend request: $e');
          }
        },
        rightIcon: Container(
          margin: EdgeInsets.only(left: 6.h),
          child: SvgPicture.asset(
            isAdded ? ImageConstant.imgFriendsIcon : "assets/images/add_friends.svg",
            height: isAdded ? 10.h : 14.h,
            width: isAdded ? 12.h : 16.h,
            fit: BoxFit.contain,
            color: Colors.white,
          ),
        ),
        buttonStyle: widget.notification.isRead 
          ? ElevatedButton.styleFrom(
              backgroundColor: appTheme.gray500,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.h),
              ),
              elevation: 0,
              padding: EdgeInsets.zero,
            )
          : CustomButtonStyles.fillBlue,
      );
    } else if (message.contains("sent you a message")) {
      return CustomElevatedButton(
        width: 74.h,
        text: "Open",
        onPressed: () async {
          try {
            // Extract username from notification message
            final username = widget.notification.message.split(' ')[0].replaceAll('@', '');
            
            // Get user info from username
            final userDoc = await FirebaseFirestore.instance
                .collection('users')
                .where('username', isEqualTo: username)
                .limit(1)
                .get();
            
            if (userDoc.docs.isNotEmpty) {
              final userData = userDoc.docs.first.data();
              final userEmail = userData['email'] as String;
              final firstName = userData['firstName'] as String? ?? '';
              final lastName = userData['lastName'] as String? ?? '';
              final receiverName = '$firstName $lastName'.trim();

              // Navigate to message screen first
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SocialProfileMessageFromProfileScreen.builder(
                    context,
                    receiverId: userEmail,
                    receiverName: receiverName,
                    receiverUsername: username,
                  ),
                ),
              );

              // Mark notification as read in the background
              final currentUser = FirebaseAuth.instance.currentUser;
              if (currentUser?.email != null) {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser!.email)
                    .collection('notifications')
                    .doc(widget.notification.id)
                    .update({'isRead': true});
              }
            }
          } catch (e) {
            print('Error navigating to message screen: $e');
          }
        },
        rightIcon: Container(
          margin: EdgeInsets.only(left: 4.h),
          child: SvgPicture.asset(
            "assets/images/message_bubble.svg",
            height: 14.h,
            width: 16.h,
            fit: BoxFit.contain,
          ),
        ),
        buttonStyle: widget.notification.isRead 
          ? ElevatedButton.styleFrom(
              backgroundColor: appTheme.gray500,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.h),
              ),
              elevation: 0,
              padding: EdgeInsets.zero,
            )
          : CustomButtonStyles.fillBlue,
      );
    } else {
      return CustomElevatedButton(
        width: 74.h,
        text: "View",
        onPressed: () {
          // Find the parent NotificationsScreenState to call showChallengeDialog
          final notificationsState =
              context.findAncestorStateOfType<NotificationsScreenState>();
          if (notificationsState != null) {
            notificationsState.showChallengeDialog(
                context, widget.notification.message);
          }
        },
        rightIcon: Container(
          margin: EdgeInsets.only(left: 4.h),
          child: SvgPicture.asset(
            "assets/images/imgArrowRight.svg",
            height: 16.h,
            width: 12.h,
            fit: BoxFit.contain,
          ),
        ),
        buttonStyle: CustomButtonStyles.fillBlue,
      );
    }
  }
}
