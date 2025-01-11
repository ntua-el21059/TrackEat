import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import '../models/leaderboard_user_model.dart';
import '../models/challenge_item_model.dart';
import '../../../../services/profile_picture_cache_service.dart';

class LeaderboardProvider extends ChangeNotifier {
  List<LeaderboardUserModel> _users = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ProfilePictureCacheService _profilePictureCache = ProfilePictureCacheService();
  List<StreamSubscription> _subscriptions = [];
  Map<String, LeaderboardUserModel> _userCache = {};
  SharedPreferences? _prefs;

  List<LeaderboardUserModel> get users => _users;

  final List<List<ChallengeItemModel>> challengePages = [
    [
      ChallengeItemModel(
        imageUrl: 'assets/images/avocado.png',
        title: 'Avocado\nchallenge',
        backgroundColor: Color(0xFF4CD964),
      ),
      ChallengeItemModel(
        imageUrl: 'assets/images/banana.png',
        title: 'Banana\nchallenge',
        backgroundColor: Color(0xFFFFCC00),
      ),
      ChallengeItemModel(
        imageUrl: 'assets/images/meat.png',
        title: 'Carnivore\nchallenge',
        backgroundColor: Color(0xFFFF3B30),
      ),
    ],
    [
      ChallengeItemModel(
        imageUrl: 'assets/images/beatles.png',
        title: 'Beatles\nchallenge',
        backgroundColor: Color(0xFF007AFF),
      ),
      ChallengeItemModel(
        imageUrl: 'assets/images/broccoli.png',
        title: 'Broccoli\nchallenge',
        backgroundColor: Colors.black,
      ),
      ChallengeItemModel(
        imageUrl: 'assets/images/wrap.png',
        title: 'Wrap\nchallenge',
        backgroundColor: Color(0xFF9747FF),
      ),
    ],
  ];

  LeaderboardProvider() {
    _initAndFetchUsers();
  }

  Future<void> _initAndFetchUsers() async {
    _prefs = await SharedPreferences.getInstance();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return;

      // Clear existing data and subscriptions
      _users = [];
      _userCache.clear();
      for (var subscription in _subscriptions) {
        subscription.cancel();
      }
      _subscriptions.clear();

      // First, add the current user
      final currentUserSubscription = _firestore
          .collection('users')
          .doc(currentUser.email)
          .snapshots()
          .listen((snapshot) async {
        if (snapshot.exists) {
          final data = snapshot.data()!;
          if (data['username'] != null && data['username'].toString().isNotEmpty) {
            String? profilePicture = await _profilePictureCache.getOrUpdateCache(currentUser.email!, null);
            
            final user = LeaderboardUserModel(
              username: data['username'] ?? '',
              fullName: "${data['firstName'] ?? ''} ${data['lastName'] ?? ''}".trim(),
              points: (data['points'] as num?)?.toInt() ?? 0,
              email: currentUser.email!,
              isCurrentUser: true,
              profileImage: profilePicture,
            );
            _userCache[currentUser.email!] = user;
            _updateUsersList();
          }
        }
      });
      _subscriptions.add(currentUserSubscription);

      // Get current user's friends
      final friendsSnapshot = await _firestore
          .collection('friends')
          .where('followerId', isEqualTo: currentUser.email)
          .get();

      final friendEmails = friendsSnapshot.docs
          .map((doc) => doc.data()['followingId'] as String)
          .toList();

      // Set up real-time listener for friends
      for (String friendEmail in friendEmails) {
        final friendSubscription = _firestore
            .collection('users')
            .doc(friendEmail)
            .snapshots()
            .listen((userSnapshot) async {
          if (userSnapshot.exists) {
            final data = userSnapshot.data()!;
            if (data['username'] != null && data['username'].toString().isNotEmpty) {
              String? profilePicture = await _profilePictureCache.getOrUpdateCache(friendEmail, null);
              
              final user = LeaderboardUserModel(
                username: data['username'] ?? '',
                fullName: "${data['firstName'] ?? ''} ${data['lastName'] ?? ''}".trim(),
                points: (data['points'] as num?)?.toInt() ?? 0,
                email: friendEmail,
                isCurrentUser: false,
                profileImage: profilePicture,
              );
              _userCache[friendEmail] = user;
              _updateUsersList();
            }
          } else {
            _userCache.remove(friendEmail);
            _updateUsersList();
          }
        });
        _subscriptions.add(friendSubscription);
      }

      // Set up listener for friends collection changes
      final friendsSubscription = _firestore
          .collection('friends')
          .where('followerId', isEqualTo: currentUser.email)
          .snapshots()
          .listen((snapshot) async {
        final newFriendEmails = snapshot.docs
            .map((doc) => doc.data()['followingId'] as String)
            .toList();

        // Remove users that are no longer friends
        _userCache.removeWhere((email, user) =>
            !newFriendEmails.contains(email) && email != currentUser.email);

        // Add new friends
        for (String email in newFriendEmails) {
          if (!_userCache.containsKey(email)) {
            final userDoc = await _firestore.collection('users').doc(email).get();
            if (userDoc.exists) {
              final data = userDoc.data()!;
              if (data['username'] != null && data['username'].toString().isNotEmpty) {
                String? profilePicture = await _profilePictureCache.getOrUpdateCache(email, null);
                
                final user = LeaderboardUserModel(
                  username: data['username'] ?? '',
                  fullName: "${data['firstName'] ?? ''} ${data['lastName'] ?? ''}".trim(),
                  points: (data['points'] as num?)?.toInt() ?? 0,
                  email: email,
                  isCurrentUser: false,
                  profileImage: profilePicture,
                );
                _userCache[email] = user;
              }
            }
          }
        }
        _updateUsersList();
      });
      _subscriptions.add(friendsSubscription);

    } catch (e) {
      print('Error setting up real-time listeners: $e');
    }
  }

  void _updateUsersList() {
    // Make sure to include both current user and friends
    _users = _userCache.values.toList()
      ..sort((a, b) => b.points.compareTo(a.points));
    notifyListeners();
    _saveToCache();
  }

  Future<void> _saveToCache() async {
    if (_users.isNotEmpty) {
      final data = _users.map((user) => {
        'username': user.username,
        'fullName': user.fullName,
        'points': user.points,
        'email': user.email,
        'isCurrentUser': user.isCurrentUser,
        'profileImage': user.profileImage,
      }).toList();
      await _prefs?.setString('leaderboard_users', jsonEncode(data));
    }
  }

  @override
  void dispose() {
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }
}
