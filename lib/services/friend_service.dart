import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'points_service.dart';

class FriendService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final PointsService _pointsService = PointsService();

  // Add a friend/follow a user
  Future<void> addFriend(String followingId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      print('Error: No current user');
      return;
    }

    final currentUserEmail = currentUser.email;
    if (currentUserEmail == null) {
      print('Error: Current user has no email');
      return;
    }

    try {
      print('Adding friend relationship: $currentUserEmail -> $followingId');

      // Add friend relationship
      await _firestore.collection('friends').add({
        'followerId': currentUserEmail,
        'followingId': followingId,
        'timestamps': FieldValue.serverTimestamp(),
      });

      // Add points for adding a friend
      await _pointsService.addFriendPoints();

      // Get the username of the follower (current user)
      print('Fetching follower username for: $currentUserEmail');
      final followerDoc =
          await _firestore.collection('users').doc(currentUserEmail).get();

      if (followerDoc.exists) {
        final followerData = followerDoc.data() as Map<String, dynamic>;
        final followerUsername = followerData['username'] as String?;
        print('Found follower username: $followerUsername');

        if (followerUsername != null) {
          print('Creating notification for: $followingId');
          // Create notification in the user's notifications subcollection
          await _firestore
              .collection('users')
              .doc(followingId)
              .collection('notifications')
              .add({
            'message': '@$followerUsername added you as a friend',
            'timestamp': FieldValue.serverTimestamp(),
            'isRead': false,
            'type': 'friend_request',
            'senderId': currentUserEmail,
          });
          print('Notification created successfully');
        } else {
          print('Error: Follower username is null');
        }
      } else {
        print('Error: Follower document does not exist');
      }
    } catch (e) {
      print('Error adding friend: $e');
      rethrow;
    }
  }

  // Remove a friend/unfollow a user
  Future<void> removeFriend(String followingId) async {
    final currentUser = _auth.currentUser;
    final currentUserEmail = currentUser?.email;
    if (currentUserEmail == null) return;

    try {
      // Get the friend document
      final querySnapshot = await _firestore
          .collection('friends')
          .where('followerId', isEqualTo: currentUserEmail)
          .where('followingId', isEqualTo: followingId)
          .get();

      // Delete the exact friend document
      if (querySnapshot.docs.isNotEmpty) {
        final friendDoc = querySnapshot.docs.first;
        await friendDoc.reference.delete();

        // Get current user's username to find and delete the notification
        final currentUserDoc = await _firestore.collection('users').doc(currentUserEmail).get();
        if (currentUserDoc.exists) {
          final currentUsername = currentUserDoc.data()?['username'] as String?;
          if (currentUsername != null) {
            // Delete the friend request notification from the other user's notifications
            final notificationsQuery = await _firestore
                .collection('users')
                .doc(followingId)
                .collection('notifications')
                .where('message', isEqualTo: '@$currentUsername added you as a friend')
                .where('type', isEqualTo: 'friend_request')
                .where('senderId', isEqualTo: currentUserEmail)
                .get();
                
            for (var doc in notificationsQuery.docs) {
              await doc.reference.delete();
            }
          }
        }

        // Remove points for removing a friend
        await _pointsService.removeFriendPoints();
      }
    } catch (e) {
      print('Error removing friend: $e');
      rethrow;
    }
  }

  // Check if we're following a user
  Future<bool> isFollowing(String followingId) async {
    final currentUserEmail = _auth.currentUser?.email;
    if (currentUserEmail == null) return false;

    final querySnapshot = await _firestore
        .collection('friends')
        .where('followerId', isEqualTo: currentUserEmail)
        .where('followingId', isEqualTo: followingId)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  // Get all friends/following of a user
  Stream<QuerySnapshot> getFollowing(String userId) {
    return _firestore
        .collection('friends')
        .where('followerId', isEqualTo: userId)
        .orderBy('timestamps', descending: true)
        .snapshots();
  }

  // Get all followers of a user
  Stream<QuerySnapshot> getFollowers(String userId) {
    return _firestore
        .collection('friends')
        .where('followingId', isEqualTo: userId)
        .orderBy('timestamps', descending: true)
        .snapshots();
  }

  Stream<bool> getFriendStatusStream(String userId) {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return Stream.value(false);

    return _firestore
        .collection('friends')
        .where('followerId', isEqualTo: currentUser.email)
        .where('followingId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty);
  }
}
