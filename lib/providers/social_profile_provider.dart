import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class SocialProfileProvider extends ChangeNotifier {
  final Map<String, UserModel> _cachedProfiles = {};
  final Map<String, Stream<DocumentSnapshot>> _profileStreams = {};
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? getProfile(String email) => _cachedProfiles[email];

  Future<void> prefetchProfile(String email) async {
    if (!_cachedProfiles.containsKey(email)) {
      try {
        final doc = await _firestore.collection('users').doc(email).get();
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          _cachedProfiles[email] = UserModel(
            username: data['username'],
            email: data['email'],
            firstName: data['firstName'],
            lastName: data['lastName'],
            birthdate: data['birthdate'],
            gender: data['gender'],
            activity: data['activity'],
            diet: data['diet'],
            goal: data['goal'],
            height: data['height']?.toDouble(),
            weight: data['weight']?.toDouble(),
            dailyCalories: data['dailyCalories'],
            carbsgoal: data['carbsgoal']?.toDouble(),
            proteingoal: data['proteingoal']?.toDouble(),
            fatgoal: data['fatgoal']?.toDouble(),
          );
          notifyListeners();
        }
      } catch (e) {
        print('Error prefetching profile: $e');
      }
    }
  }

  Stream<UserModel?> watchProfile(String email) {
    // Start prefetch immediately
    prefetchProfile(email);

    if (!_profileStreams.containsKey(email)) {
      final stream = _firestore.collection('users').doc(email).snapshots();
      _profileStreams[email] = stream;

      // Listen to changes and update cache
      stream.listen((snapshot) {
        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>;
          _cachedProfiles[email] = UserModel(
            username: data['username'],
            email: data['email'],
            firstName: data['firstName'],
            lastName: data['lastName'],
            birthdate: data['birthdate'],
            gender: data['gender'],
            activity: data['activity'],
            diet: data['diet'],
            goal: data['goal'],
            height: data['height']?.toDouble(),
            weight: data['weight']?.toDouble(),
            dailyCalories: data['dailyCalories'],
            carbsgoal: data['carbsgoal']?.toDouble(),
            proteingoal: data['proteingoal']?.toDouble(),
            fatgoal: data['fatgoal']?.toDouble(),
          );
          notifyListeners();
        }
      });
    }

    return _profileStreams[email]!.map((snapshot) {
      if (!snapshot.exists) return null;
      return _cachedProfiles[email];
    });
  }

  void dispose() {
    _cachedProfiles.clear();
    _profileStreams.clear();
    super.dispose();
  }
} 