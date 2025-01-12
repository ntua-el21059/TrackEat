import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:convert';
import 'package:collection/collection.dart';
import '../../../services/friend_service.dart';

class SocialProfileViewProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FriendService _friendService = FriendService();
  
  Map<String, DocumentSnapshot> _userCache = {};
  Map<String, StreamSubscription> _userSubscriptions = {};
  Map<String, StreamSubscription> _friendSubscriptions = {};
  Map<String, bool> _friendStatusCache = {};

  DocumentSnapshot? getCachedUser(String username) => _userCache[username];
  bool? getCachedFriendStatus(String email) => _friendStatusCache[email];
  bool? getFriendStatus(String email) => _friendStatusCache[email];

  Future<DocumentSnapshot?> getUserData(String username) async {
    // First check cache
    if (_userCache.containsKey(username)) {
      return _userCache[username];
    }

    try {
      // If not in cache, fetch from Firestore
      final userSnapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        _userCache[username] = userSnapshot.docs.first;
        
        // Set up friend status watch for this user
        final email = userSnapshot.docs.first.get('email') as String;
        setupFriendStatusWatch(email);
        
        return userSnapshot.docs.first;
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
    return null;
  }

  void setupRealtimeUpdates(String username) {
    // Cancel existing subscription if any
    _userSubscriptions[username]?.cancel();

    // Set up new subscription
    final subscription = _firestore
        .collection('users')
        .where('username', isEqualTo: username)
        .limit(1)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        _userCache[username] = snapshot.docs.first;
        
        // Update friend status watch when user data changes
        final email = snapshot.docs.first.get('email') as String;
        setupFriendStatusWatch(email);
        
        notifyListeners();
      }
    });

    _userSubscriptions[username] = subscription;
  }

  void setupFriendStatusWatch(String targetEmail) {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    // Cancel existing subscription if any
    _friendSubscriptions[targetEmail]?.cancel();

    // Set up new subscription
    final subscription = _firestore
        .collection('friends')
        .where('followerId', isEqualTo: currentUser.email)
        .where('followingId', isEqualTo: targetEmail)
        .snapshots()
        .listen((snapshot) {
      _friendStatusCache[targetEmail] = snapshot.docs.isNotEmpty;
      notifyListeners();
    });

    _friendSubscriptions[targetEmail] = subscription;
  }

  Future<void> toggleFriendStatus(String targetEmail) async {
    try {
      final isFriend = _friendStatusCache[targetEmail] ?? false;
      
      if (isFriend) {
        await _friendService.removeFriend(targetEmail);
      } else {
        await _friendService.addFriend(targetEmail);
      }
      
      // The friend status will be updated via the snapshot listener
    } catch (e) {
      print('Error toggling friend status: $e');
      rethrow;
    }
  }

  Future<bool> checkFriendStatus(String targetEmail) async {
    try {
      return await _friendService.isFollowing(targetEmail);
    } catch (e) {
      print('Error checking friend status: $e');
      return false;
    }
  }

  @override
  void dispose() {
    // Cancel all subscriptions
    for (var subscription in _userSubscriptions.values) {
      subscription.cancel();
    }
    for (var subscription in _friendSubscriptions.values) {
      subscription.cancel();
    }
    _userSubscriptions.clear();
    _friendSubscriptions.clear();
    super.dispose();
  }
} 