import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/leaderboard_user_model.dart';
import '../models/challenge_item_model.dart';

class LeaderboardProvider extends ChangeNotifier {
  List<LeaderboardUserModel> _users = [];
  bool _isLoading = true;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

      final usersSnapshot = await _firestore.collection('users').get();

      final List<LeaderboardUserModel> allUsers = usersSnapshot.docs
          .map((doc) {
            final data = doc.data();
            return LeaderboardUserModel(
              username: data['username'] ?? '',
              fullName:
                  "${data['firstName'] ?? ''} ${data['lastName'] ?? ''}".trim(),
              points: (data['points'] as num?)?.toInt() ??
                  (45 +
                      DateTime.now().microsecond %
                          5), // Random points under 50 if not set
              email: doc.id,
              isCurrentUser: doc.id == currentUser.email,
            );
          })
          .where((user) =>
              user.username.isNotEmpty) // Filter out users without usernames
          .toList();

      // Sort by points in descending order
      allUsers.sort((a, b) => b.points.compareTo(a.points));

      // Take top 4 users and ensure current user is included
      final currentUserInTop4 =
          allUsers.take(4).any((user) => user.isCurrentUser);
      if (!currentUserInTop4) {
        final currentUserIndex =
            allUsers.indexWhere((user) => user.isCurrentUser);
        if (currentUserIndex >= 0) {
          final currentUser = allUsers[currentUserIndex];
          allUsers.removeAt(currentUserIndex);
          allUsers.insert(3, currentUser); // Insert at position 4 (index 3)
        }
      }

      _users = allUsers.take(4).toList(); // Keep only top 4 users
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error fetching users: $e');
      _isLoading = false;
      notifyListeners();
    }
  }
}
