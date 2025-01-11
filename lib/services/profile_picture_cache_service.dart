import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePictureCacheService extends ChangeNotifier {
  static final ProfilePictureCacheService _instance = ProfilePictureCacheService._internal();
  factory ProfilePictureCacheService() => _instance;
  ProfilePictureCacheService._internal() {
    _loadCachedData();
  }

  final Map<String, String> _cache = {};
  final Map<String, StreamSubscription<DocumentSnapshot>> _subscriptions = {};
  final Map<String, String> _lastKnownProfilePictures = {};
  SharedPreferences? _prefs;

  Future<void> _loadCachedData() async {
    _prefs = await SharedPreferences.getInstance();
    final cachedData = _prefs?.getString('profile_pictures_cache');
    if (cachedData != null) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(cachedData);
        _cache.addAll(Map<String, String>.from(decoded));
        _lastKnownProfilePictures.addAll(Map<String, String>.from(decoded));
      } catch (e) {
        print('Error loading cached profile pictures: $e');
      }
    }
  }

  Future<void> _saveCacheToPrefs() async {
    if (_prefs != null && _cache.isNotEmpty) {
      await _prefs?.setString('profile_pictures_cache', jsonEncode(_cache));
    }
  }

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
          _saveCacheToPrefs();
          notifyListeners();
          return;
        }

        if (_cache[email] != newProfilePicture) {
          _cache[email] = newProfilePicture;
          _saveCacheToPrefs();
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
      await _saveCacheToPrefs();
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
    _prefs?.remove('profile_pictures_cache');
    notifyListeners();
  }

  void clearCacheForUser(String email) {
    _cache.remove(email);
    _lastKnownProfilePictures.remove(email);
    _subscriptions[email]?.cancel();
    _subscriptions.remove(email);
    _saveCacheToPrefs();
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