import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import '../../../services/friend_service.dart';
import '../../../core/utils/logger.dart';
import '../../../models/award_model.dart';

class SocialProfileViewProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FriendService _friendService = FriendService();
  
  static final Map<String, DocumentSnapshot> _globalUserCache = {};
  static final Map<String, bool> _globalFriendStatusCache = {};
  static final Map<String, List<Award>> _globalAwardsCache = {};
  static final Map<String, String> _globalEmailCache = {};

  DocumentSnapshot? getCachedUser(String username) => _globalUserCache[username];
  bool? getFriendStatus(String email) => _globalFriendStatusCache[email];
  List<Award>? getCachedAwards(String email) => _globalAwardsCache[email];

  // Call this when app starts to prefetch common profiles
  static Future<void> prefetchCommonProfiles() async {
    try {
      // Get most recently viewed or most common profiles with minimal fields
      final recentProfiles = await FirebaseFirestore.instance
          .collection('users')
          .orderBy('lastActive', descending: true)
          .limit(10)
          .get();

      // Process profiles in parallel
      await Future.wait(
        recentProfiles.docs.map((doc) async {
          final username = doc.data()['username'] as String?;
          final email = doc.data()['email'] as String?;
          if (username != null && email != null) {
            _globalUserCache[username] = doc;
            _globalEmailCache[username] = email;
            
            // Fetch awards in parallel
            await FirebaseFirestore.instance
                .collection('users')
                .doc(email)
                .collection('awards')
                .get()
                .then((awardsSnapshot) {
                  final awards = awardsSnapshot.docs.map((doc) {
                    final data = doc.data();
                    data['id'] = doc.id;
                    return Award.fromMap(data);
                  }).toList();
                  _globalAwardsCache[email] = awards;
                });
          }
        })
      );
    } catch (e) {
      // Ignore prefetch errors
    }
  }

  // Synchronously initialize with cached data
  void initWithUsername(String username) {
    if (_globalUserCache.containsKey(username)) {
      notifyListeners();
    }
    // Start background fetch
    prefetchAllData(username);
  }

  Future<void> prefetchAllData(String username) async {
    try {
      // First check global cache
      if (_globalUserCache.containsKey(username)) {
        notifyListeners();
        _refreshInBackground(username);
        return;
      }

      // Fetch user data with minimal fields first
      final userSnapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (userSnapshot.docs.isEmpty) return;

      final doc = userSnapshot.docs.first;
      _globalUserCache[username] = doc;
      notifyListeners(); // Notify immediately with basic user data
      
      final data = doc.data();
      final email = data['email'] as String?;
      if (email == null) return;
      
      _globalEmailCache[username] = email;

      // Fetch remaining data in parallel
      await Future.wait([
        // Fetch full user data
        _firestore
            .collection('users')
            .doc(doc.id)
            .get()
            .then((fullDoc) {
              _globalUserCache[username] = fullDoc;
              notifyListeners();
            }),

        // Fetch friend status
        _auth.currentUser != null 
            ? _friendService.isFollowing(email).then((status) {
                _globalFriendStatusCache[email] = status;
                notifyListeners();
              })
            : Future.value(),

        // Fetch awards
        _firestore
            .collection('users')
            .doc(email)
            .collection('awards')
            .get()
            .then((awardsSnapshot) {
              final awards = awardsSnapshot.docs.map((doc) {
                final data = doc.data();
                data['id'] = doc.id;
                return Award.fromMap(data);
              }).toList();
              _globalAwardsCache[email] = awards;
              notifyListeners();
            }),
      ]);

    } catch (e, stackTrace) {
      Logger.log('Failed to prefetch data', stackTrace: stackTrace);
    }
  }

  // Refresh data in background without blocking UI
  Future<void> _refreshInBackground(String username) async {
    try {
      final userSnapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (userSnapshot.docs.isEmpty) return;

      final doc = userSnapshot.docs.first;
      final oldDoc = _globalUserCache[username];
      
      // Only update if data changed
      if (oldDoc?.data()?.toString() != doc.data().toString()) {
        _globalUserCache[username] = doc;
        notifyListeners();
      }

      final data = doc.data();
      final email = data['email'] as String?;
      if (email == null) return;

      // Update awards in background
      final awardsSnapshot = await _firestore
          .collection('users')
          .doc(email)
          .collection('awards')
          .get();
          
      final awards = awardsSnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Award.fromMap(data);
      }).toList();

      final oldAwards = _globalAwardsCache[email];
      if (oldAwards?.toString() != awards.toString()) {
        _globalAwardsCache[email] = awards;
        notifyListeners();
      }
    } catch (e) {
      // Ignore background refresh errors
    }
  }

  Future<void> toggleFriendStatus(String targetEmail) async {
    try {
      final isFriend = _globalFriendStatusCache[targetEmail] ?? false;
      
      if (isFriend) {
        await _friendService.removeFriend(targetEmail);
        _globalFriendStatusCache[targetEmail] = false;
      } else {
        await _friendService.addFriend(targetEmail);
        _globalFriendStatusCache[targetEmail] = true;
      }
      
      notifyListeners();
    } catch (e, stackTrace) {
      Logger.log('Failed to toggle friend status', stackTrace: stackTrace);
      rethrow;
    }
  }
} 