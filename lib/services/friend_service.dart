import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Add points to a user
  Future<void> _updatePoints(String userEmail, int pointsToAdd) async {
    try {
      final docRef = _firestore.collection('users').doc(userEmail);

      // Get current points
      final doc = await docRef.get();
      if (!doc.exists) {
        throw Exception('User document not found');
      }

      final currentPoints = (doc.data()?['points'] as num?)?.toInt() ?? 0;
      final newPoints = currentPoints + pointsToAdd;

      // Update points in Firestore
      await docRef.update({'points': newPoints});
    } catch (e) {
      print('Error updating points: $e');
      rethrow;
    }
  }

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

      // Add 10 points for adding a friend
      await _updatePoints(currentUserEmail, 10);

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
    final currentUserEmail = _auth.currentUser?.email;
    if (currentUserEmail == null) return;

    try {
      // Get the friend document
      final querySnapshot = await _firestore
          .collection('friends')
          .where('followerId', isEqualTo: currentUserEmail)
          .where('followingId', isEqualTo: followingId)
          .get();

      // Delete all matching documents (should only be one)
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      // Remove 10 points for removing a friend
      await _updatePoints(currentUserEmail, -10);
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
}
