import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class SocialProfileProvider extends ChangeNotifier {
  final Map<String, UserModel> _cachedProfiles = {};
  final Map<String, Stream<DocumentSnapshot>> _profileStreams = {};
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Map<String, bool> _friendStatus = {};
  final Map<String, StreamSubscription<QuerySnapshot>> _friendStatusSubscriptions = {};

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

  @override
  void dispose() {
    _cachedProfiles.clear();
    _profileStreams.clear();
    for (var subscription in _friendStatusSubscriptions.values) {
      subscription.cancel();
    }
    _friendStatusSubscriptions.clear();
    super.dispose();
  }

  Future<void> watchFriendStatus(String currentUserEmail, String targetUserEmail) async {
    final key = '$currentUserEmail-$targetUserEmail';
    
    // Cancel existing subscription if any
    await _friendStatusSubscriptions[key]?.cancel();

    // Set up new subscription
    _friendStatusSubscriptions[key] = _firestore
        .collection('friends')
        .where('followerId', isEqualTo: currentUserEmail)
        .where('followingId', isEqualTo: targetUserEmail)
        .snapshots()
        .listen((snapshot) {
          final isFriend = snapshot.docs.isNotEmpty;
          if (_friendStatus[key] != isFriend) {
            _friendStatus[key] = isFriend;
            notifyListeners();
          }
        }, onError: (error) {
          debugPrint('Error watching friend status: $error');
          _friendStatus.remove(key);
          notifyListeners();
        });
  }

  bool? getFriendStatus(String currentUserEmail, String targetUserEmail) {
    return _friendStatus['$currentUserEmail-$targetUserEmail'];
  }

  Future<void> toggleFriendStatus(String currentUserEmail, String targetUserEmail) async {
    final key = '$currentUserEmail-$targetUserEmail';
    final isFriend = _friendStatus[key] ?? false;

    try {
      if (!isFriend) {
        await _firestore.collection('friends').add({
          'followerId': currentUserEmail,
          'followingId': targetUserEmail,
          'timestamp': FieldValue.serverTimestamp(),
        });
      } else {
        final querySnapshot = await _firestore
            .collection('friends')
            .where('followerId', isEqualTo: currentUserEmail)
            .where('followingId', isEqualTo: targetUserEmail)
            .get();

        final batch = _firestore.batch();
        for (var doc in querySnapshot.docs) {
          batch.delete(doc.reference);
        }
        await batch.commit();
      }
    } catch (e) {
      debugPrint('Error toggling friend status: $e');
      rethrow;
    }
  }
} 