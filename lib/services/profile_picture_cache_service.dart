import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePictureCacheService extends ChangeNotifier {
  static final ProfilePictureCacheService _instance = ProfilePictureCacheService._internal();
  factory ProfilePictureCacheService() => _instance;
  ProfilePictureCacheService._internal();

  final Map<String, String> _cache = {};
  final Map<String, StreamSubscription<DocumentSnapshot>> _subscriptions = {};
  final Map<String, String> _lastKnownProfilePictures = {};

  String? getCachedProfilePicture(String email) {
    if (!_subscriptions.containsKey(email)) {
      _setupListener(email);
    }
    return _cache[email];
  }

  void _setupListener(String email) {
    _subscriptions[email]?.cancel();
    
    _subscriptions[email] = FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .snapshots()
        .listen((snapshot) {
      if (!snapshot.exists) return;
      
      final data = snapshot.data() as Map<String, dynamic>;
      if (!data.containsKey('profilePicture')) return;
      
      final newProfilePicture = data['profilePicture'] as String?;
      
      // Only update if the profile picture has actually changed
      if (newProfilePicture != _lastKnownProfilePictures[email]) {
        _lastKnownProfilePictures[email] = newProfilePicture ?? '';
        
        if (newProfilePicture == null || newProfilePicture.isEmpty) {
          _cache.remove(email);
          notifyListeners();
          return;
        }

        if (_cache[email] != newProfilePicture) {
          _cache[email] = newProfilePicture;
          notifyListeners();
        }
      }
    });
  }

  Future<String?> getOrUpdateCache(String email, String? newProfilePicture) async {
    // If new picture is null or empty, return cached value
    if (newProfilePicture == null || newProfilePicture.isEmpty) {
      return getCachedProfilePicture(email);
    }

    // If we don't have a cached value or it's different, update it
    if (_cache[email] != newProfilePicture) {
      _cache[email] = newProfilePicture;
      _lastKnownProfilePictures[email] = newProfilePicture;
      if (!_subscriptions.containsKey(email)) {
        _setupListener(email);
      }
    }

    return _cache[email];
  }

  void clearCache() {
    _cache.clear();
    _lastKnownProfilePictures.clear();
    for (var subscription in _subscriptions.values) {
      subscription.cancel();
    }
    _subscriptions.clear();
    notifyListeners();
  }

  void clearCacheForUser(String email) {
    _cache.remove(email);
    _lastKnownProfilePictures.remove(email);
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