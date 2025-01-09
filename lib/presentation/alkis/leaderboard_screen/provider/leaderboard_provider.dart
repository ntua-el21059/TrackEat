import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/leaderboard_user_model.dart';
import '../models/challenge_item_model.dart';
import '../../../../services/profile_picture_cache_service.dart';

class LeaderboardProvider extends ChangeNotifier {
  List<LeaderboardUserModel> _users = [];
  bool _isLoading = true;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ProfilePictureCacheService _profilePictureCache = ProfilePictureCacheService();

  List<LeaderboardUserModel> get users => _users;
  bool get isLoading => _isLoading;

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

  Future<void> fetchUsers() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return;

      // Get all friends of current user
      final friendsSnapshot = await _firestore
          .collection('friends')
          .where('followerId', isEqualTo: currentUser.email)
          .get();

      // Get friend emails
      final friendEmails = friendsSnapshot.docs
          .map((doc) => doc.data()['followingId'] as String)
          .toList();

      // Add current user's email to the list
      friendEmails.add(currentUser.email!);

      // Get all friend users and current user
      final List<LeaderboardUserModel> allUsers = [];

      for (String email in friendEmails) {
        final userDoc = await _firestore.collection('users').doc(email).get();
        if (userDoc.exists) {
          final data = userDoc.data()!;
          if (data['username'] != null &&
              data['username'].toString().isNotEmpty) {
            // Get profile picture from cache or fetch it
            String? profilePicture = await _profilePictureCache.getOrUpdateCache(email, null);
            
            allUsers.add(LeaderboardUserModel(
              username: data['username'] ?? '',
              fullName:
                  "${data['firstName'] ?? ''} ${data['lastName'] ?? ''}".trim(),
              points: (data['points'] as num?)?.toInt() ?? 0,
              email: email,
              isCurrentUser: email == currentUser.email,
              profileImage: profilePicture,
            ));
          }
        }
      }

      // Sort by points in descending order
      allUsers.sort((a, b) => b.points.compareTo(a.points));

      _users = allUsers;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error fetching users: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    // No need to clear cache here as it's a singleton and might be used elsewhere
    super.dispose();
  }
}
