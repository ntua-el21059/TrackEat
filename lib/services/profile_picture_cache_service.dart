import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/utils/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePictureCacheService extends ChangeNotifier {
  static final ProfilePictureCacheService _instance = ProfilePictureCacheService._internal();
  factory ProfilePictureCacheService() => _instance;
  
  ProfilePictureCacheService._internal() {
    _loadCachedData();
    _prefetchCurrentUserProfilePicture();
  }

  final Map<String, String> _cache = {};
  final Map<String, StreamSubscription<DocumentSnapshot>> _subscriptions = {};
  final Map<String, String> _lastKnownProfilePictures = {};
  final Map<String, DateTime> _lastFetchTimes = {};
  final Map<String, Completer<String?>> _pendingFetches = {};
  SharedPreferences? _prefs;
  
  static const Duration _cacheExpiry = Duration(hours: 24);
  static const String _cacheKey = 'profile_pictures_cache';
  static const String _timestampKey = 'profile_pictures_timestamps';

  Future<void> _prefetchCurrentUserProfilePicture() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser?.email != null) {
      // Start listening to profile picture changes immediately
      _setupListener(currentUser!.email!);
      
      // Fetch immediately from cache or Firestore
      await _fetchProfilePicture(currentUser.email!);
    }
  }

  Future<void> _loadCachedData() async {
    _prefs = await SharedPreferences.getInstance();
    
    try {
      final cachedData = _prefs?.getString(_cacheKey);
      final cachedTimestamps = _prefs?.getString(_timestampKey);
      
      if (cachedData != null) {
        final Map<String, dynamic> decoded = jsonDecode(cachedData);
        _cache.addAll(Map<String, String>.from(decoded));
        _lastKnownProfilePictures.addAll(Map<String, String>.from(decoded));
      }
      
      if (cachedTimestamps != null) {
        final Map<String, dynamic> timestamps = jsonDecode(cachedTimestamps);
        timestamps.forEach((email, timestamp) {
          _lastFetchTimes[email] = DateTime.parse(timestamp);
        });
      }
    } catch (e, stackTrace) {
      Logger.log('Failed to load cached profile pictures: $e', stackTrace: stackTrace);
    }
  }

  Future<void> _saveCacheToPrefs() async {
    if (_prefs != null) {
      try {
        if (_cache.isNotEmpty) {
          await _prefs?.setString(_cacheKey, jsonEncode(_cache));
        }
        if (_lastFetchTimes.isNotEmpty) {
          final timestamps = _lastFetchTimes.map(
            (email, time) => MapEntry(email, time.toIso8601String())
          );
          await _prefs?.setString(_timestampKey, jsonEncode(timestamps));
        }
      } catch (e, stackTrace) {
        Logger.log('Failed to save cache to preferences: $e', stackTrace: stackTrace);
      }
    }
  }

  bool _shouldRefresh(String email) {
    final lastFetch = _lastFetchTimes[email];
    if (lastFetch == null) return true;
    return DateTime.now().difference(lastFetch) > _cacheExpiry;
  }

  String? getCachedProfilePicture(String email) {
    // If it's the current user's profile picture, ensure we have a listener
    if (email == FirebaseAuth.instance.currentUser?.email && !_subscriptions.containsKey(email)) {
      _setupListener(email);
    }

    // Return cached version immediately if available
    if (_cache.containsKey(email)) {
      // Refresh in background if needed
      if (_shouldRefresh(email)) {
        _fetchProfilePicture(email);
      }
      return _cache[email];
    }

    // If not in cache, fetch immediately
    _fetchProfilePicture(email);
    return null;
  }

  Future<void> _fetchProfilePicture(String email) async {
    // Don't fetch if already fetching
    if (_pendingFetches.containsKey(email)) {
      return;
    }

    final completer = Completer<String?>();
    _pendingFetches[email] = completer;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final newProfilePicture = data['profilePicture'] as String?;

        if (newProfilePicture != _lastKnownProfilePictures[email]) {
          _lastKnownProfilePictures[email] = newProfilePicture ?? '';
          
          if (newProfilePicture == null || newProfilePicture.isEmpty) {
            _cache.remove(email);
          } else {
            _cache[email] = newProfilePicture;
          }
          
          _lastFetchTimes[email] = DateTime.now();
          await _saveCacheToPrefs();
          notifyListeners();
        }

        completer.complete(newProfilePicture);
      } else {
        completer.complete(null);
      }
    } catch (e, stackTrace) {
      Logger.log('Failed to fetch profile picture for $email: $e', stackTrace: stackTrace);
      completer.complete(null);
    } finally {
      _pendingFetches.remove(email);
    }
  }

  void _setupListener(String email) {
    // Cancel existing subscription if any
    _subscriptions[email]?.cancel();
    
    // Set up new subscription
    _subscriptions[email] = FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .snapshots()
        .listen((doc) async {
          if (doc.exists) {
            final data = doc.data() as Map<String, dynamic>;
            final newProfilePicture = data['profilePicture'] as String?;
            
            if (newProfilePicture != _lastKnownProfilePictures[email]) {
              _lastKnownProfilePictures[email] = newProfilePicture ?? '';
              
              if (newProfilePicture == null || newProfilePicture.isEmpty) {
                _cache.remove(email);
              } else {
                _cache[email] = newProfilePicture;
              }
              
              _lastFetchTimes[email] = DateTime.now();
              await _saveCacheToPrefs();
              notifyListeners();
            }
          }
        });
  }

  Future<String?> getOrUpdateCache(String email, String? newProfilePicture) async {
    if (newProfilePicture == null || newProfilePicture.isEmpty) {
      return getCachedProfilePicture(email);
    }

    if (_cache[email] != newProfilePicture) {
      _cache[email] = newProfilePicture;
      _lastKnownProfilePictures[email] = newProfilePicture;
      _lastFetchTimes[email] = DateTime.now();
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
    _lastFetchTimes.clear();
    for (var subscription in _subscriptions.values) {
      subscription.cancel();
    }
    _subscriptions.clear();
    _pendingFetches.clear();
    _prefs?.remove(_cacheKey);
    _prefs?.remove(_timestampKey);
    notifyListeners();
  }

  void clearCacheForUser(String email) {
    _cache.remove(email);
    _lastKnownProfilePictures.remove(email);
    _lastFetchTimes.remove(email);
    _subscriptions[email]?.cancel();
    _subscriptions.remove(email);
    _pendingFetches.remove(email);
    _saveCacheToPrefs();
    notifyListeners();
  }

  @override
  void dispose() {
    for (var subscription in _subscriptions.values) {
      subscription.cancel();
    }
    _subscriptions.clear();
    _pendingFetches.clear();
    super.dispose();
  }
} 