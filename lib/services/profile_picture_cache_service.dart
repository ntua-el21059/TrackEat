import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePictureCacheService extends ChangeNotifier {
  static final ProfilePictureCacheService _instance = ProfilePictureCacheService._internal();
  factory ProfilePictureCacheService() => _instance;
  ProfilePictureCacheService._internal();

  final Map<String, String> _cache = {};
  final Map<String, StreamSubscription<DocumentSnapshot>> _subscriptions = {};

  String? getCachedProfilePicture(String email) {
    return _cache[email];
  }

  void cacheProfilePicture(String email, String? profilePicture) {
    if (profilePicture != null && profilePicture.isNotEmpty) {
      _cache[email] = profilePicture;
    } else {
      _cache.remove(email);
    }
    notifyListeners();
  }

  Future<String?> getProfilePicture(String email) async {
    // First check cache
    if (_cache.containsKey(email)) {
      return _cache[email];
    }

    // If not in cache, fetch from Firestore
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .get();

      if (doc.exists) {
        final profilePicture = doc.data()?['profilePicture'] as String?;
        if (profilePicture != null && profilePicture.isNotEmpty) {
          _cache[email] = profilePicture;
          _setupListener(email);
        }
        return profilePicture;
      }
    } catch (e) {
      print('Error fetching profile picture: $e');
    }
    return null;
  }

  void _setupListener(String email) {
    // Cancel existing subscription if any
    _subscriptions[email]?.cancel();

    // Setup new subscription
    _subscriptions[email] = FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final newProfilePicture = snapshot.data()?['profilePicture'] as String?;
        final currentCached = _cache[email];

        // Only update cache if the profile picture has changed
        if (newProfilePicture != currentCached) {
          if (newProfilePicture != null && newProfilePicture.isNotEmpty) {
            _cache[email] = newProfilePicture;
          } else {
            _cache.remove(email);
          }
          notifyListeners();
        }
      }
    });
  }

  void clearCache() {
    _cache.clear();
    for (var subscription in _subscriptions.values) {
      subscription.cancel();
    }
    _subscriptions.clear();
    notifyListeners();
  }

  void clearCacheForUser(String email) {
    _cache.remove(email);
    _subscriptions[email]?.cancel();
    _subscriptions.remove(email);
    notifyListeners();
  }

  @override
  void dispose() {
    for (var subscription in _subscriptions.values) {
      subscription.cancel();
    }
    _subscriptions.clear();
    super.dispose();
  }
} 