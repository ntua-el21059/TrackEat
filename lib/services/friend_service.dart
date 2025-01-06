import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'points_service.dart';

class FriendService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final PointsService _pointsService = PointsService();

  Future<void> addFriend(String friendEmail) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return;

      // Get current user's username for notification
      final currentUserDoc =
          await _firestore.collection('users').doc(currentUser.email).get();
      final currentUsername = currentUserDoc.data()?['username'];
      if (currentUsername == null) return;

      // Add friend to current user's friends list
      await _firestore
          .collection('users')
          .doc(currentUser.email)
          .collection('friends')
          .doc(friendEmail)
          .set({'timestamp': FieldValue.serverTimestamp()});

      // Add current user to friend's friends list
      await _firestore
          .collection('users')
          .doc(friendEmail)
          .collection('friends')
          .doc(currentUser.email)
          .set({'timestamp': FieldValue.serverTimestamp()});

      // Create notification for the friend
      await _firestore
          .collection('users')
          .doc(friendEmail)
          .collection('notifications')
          .add({
        'message': '@$currentUsername added you as a friend',
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
        'type': 'friend_request',
      });

      // Add points for making a new friend
      await _pointsService.addNewFriendPoints();

      print('Added friend and points successfully'); // Debug print
    } catch (e) {
      print('Error adding friend: $e');
      throw e;
    }
  }

  Future<void> removeFriend(String friendEmail) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return;

      // Remove friend from current user's friends list
      await _firestore
          .collection('users')
          .doc(currentUser.email)
          .collection('friends')
          .doc(friendEmail)
          .delete();

      // Remove current user from friend's friends list
      await _firestore
          .collection('users')
          .doc(friendEmail)
          .collection('friends')
          .doc(currentUser.email)
          .delete();
    } catch (e) {
      print('Error removing friend: $e');
      throw e;
    }
  }

  Future<bool> isFollowing(String friendEmail) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      final doc = await _firestore
          .collection('users')
          .doc(currentUser.email)
          .collection('friends')
          .doc(friendEmail)
          .get();

      return doc.exists;
    } catch (e) {
      print('Error checking following status: $e');
      return false;
    }
  }
}
