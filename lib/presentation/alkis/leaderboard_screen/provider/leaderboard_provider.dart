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
  List<LeaderboardUserModel> _users = [
    LeaderboardUserModel(
      username: '',
      fullName: '',
      points: 0,
      email: '',
      isCurrentUser: false,
      profileImage: null,
    ),
    LeaderboardUserModel(
      username: '',
      fullName: '',
      points: 0,
      email: '',
      isCurrentUser: false,
      profileImage: null,
    ),
    LeaderboardUserModel(
      username: '',
      fullName: '',
      points: 0,
      email: '',
      isCurrentUser: false,
      profileImage: null,
    ),
  ];
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
    _initCache();
  }

  Future<void> _initCache() async {
    _prefs = await SharedPreferences.getInstance();
    final cachedData = _prefs?.getString('leaderboard_users');
    if (cachedData != null) {
      try {
        final List<dynamic> decoded = jsonDecode(cachedData);
        if (decoded.isNotEmpty) {
          _users = decoded.map((item) => LeaderboardUserModel(
            username: item['username'] ?? '',
            fullName: item['fullName'] ?? '',
            points: item['points'] ?? 0,
            email: item['email'] ?? '',
            isCurrentUser: item['isCurrentUser'] ?? false,
            profileImage: item['profileImage'],
          )).toList();
          
          // Initialize cache map
          for (var user in _users) {
            _userCache[user.email] = user;
          }
          notifyListeners();
        }
      } catch (e) {
        print('Error loading cached data: $e');
      }
    }
    fetchUsers();
  }

  Future<void> _saveToCache() async {
    if (_users.isNotEmpty && _users.first.username.isNotEmpty) {
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

  Future<void> fetchUsers() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return;

      // First try to load from cache
      final cachedData = _prefs?.getString('leaderboard_users');
      if (cachedData != null) {
        final List<dynamic> decoded = jsonDecode(cachedData);
        if (decoded.isNotEmpty) {
          _users = decoded.map((item) => LeaderboardUserModel(
            username: item['username'] ?? '',
            fullName: item['fullName'] ?? '',
            points: item['points'] ?? 0,
            email: item['email'] ?? '',
            isCurrentUser: item['isCurrentUser'] ?? false,
            profileImage: item['profileImage'],
          )).toList();
          
          // Initialize cache map
          for (var user in _users) {
            _userCache[user.email] = user;
          }
          notifyListeners();
          // If we have cache, set up listeners but don't update UI immediately
          _setupFirebaseListeners(currentUser);
          return;
        }
      }

      // If no cache, fetch fresh data
      final friendsSnapshot = await _firestore
          .collection('friends')
          .where('followerId', isEqualTo: currentUser.email)
          .get();

      final friendEmails = friendsSnapshot.docs
          .map((doc) => doc.data()['followingId'] as String)
          .toList();

      friendEmails.add(currentUser.email!);

      // Fetch all users at once first time
      final List<LeaderboardUserModel> initialUsers = [];
      for (String email in friendEmails) {
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
              isCurrentUser: email == currentUser.email,
              profileImage: profilePicture,
            );
            initialUsers.add(user);
            _userCache[email] = user;
          }
        }
      }

      if (initialUsers.isNotEmpty) {
        initialUsers.sort((a, b) => b.points.compareTo(a.points));
        _users = initialUsers;
        notifyListeners();
        _saveToCache(); // Save initial data to cache
      }

      // Set up listeners for future updates
      _setupFirebaseListeners(currentUser);
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  void _setupFirebaseListeners(User currentUser) {
    for (String email in _userCache.keys) {
      final subscription = _firestore
          .collection('users')
          .doc(email)
          .snapshots()
          .listen((snapshot) async {
        if (snapshot.exists) {
          final data = snapshot.data()!;
          if (data['username'] != null && data['username'].toString().isNotEmpty) {
            final updatedUser = LeaderboardUserModel(
              username: data['username'] ?? '',
              fullName: "${data['firstName'] ?? ''} ${data['lastName'] ?? ''}".trim(),
              points: (data['points'] as num?)?.toInt() ?? 0,
              email: email,
              isCurrentUser: email == currentUser.email,
              profileImage: _userCache[email]?.profileImage, // Keep existing profile picture
            );

            if (_userCache[email]?.points != updatedUser.points) {
              _userCache[email] = updatedUser;
              _users = _userCache.values.toList()..sort((a, b) => b.points.compareTo(a.points));
              notifyListeners();
              _saveToCache();
            }
          }
        }
      });
      _subscriptions.add(subscription);
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
