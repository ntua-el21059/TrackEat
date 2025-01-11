import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class SocialProfileViewProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, DocumentSnapshot> _userCache = {};
  Map<String, StreamSubscription> _userSubscriptions = {};

  DocumentSnapshot? getCachedUser(String username) => _userCache[username];

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
        notifyListeners();
      }
    });

    _userSubscriptions[username] = subscription;
  }

  @override
  void dispose() {
    // Cancel all subscriptions
    for (var subscription in _userSubscriptions.values) {
      subscription.cancel();
    }
    _userSubscriptions.clear();
    super.dispose();
  }
} 