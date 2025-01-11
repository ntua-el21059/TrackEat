import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:convert';
import 'package:collection/collection.dart';

class SocialProfileViewProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Map<String, DocumentSnapshot> _userCache = {};
  Map<String, bool> _friendStatusCache = {};
  Map<String, DateTime> _lastFetchTimes = {};
  Map<String, StreamSubscription> _userSubscriptions = {};
  Map<String, StreamSubscription> _friendSubscriptions = {};
  Map<String, Completer<DocumentSnapshot?>> _pendingFetches = {};
  SharedPreferences? _prefs;
  static const String _cacheKey = 'social_profile_cache';
  static const String _timestampKey = 'social_profile_timestamps';
  static const String _friendStatusKey = 'friend_status_cache';
  static const Duration _cacheExpiry = Duration(minutes: 30);

  SocialProfileViewProvider() {
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _restoreCache();
  }

  void _restoreCache() {
    try {
      final cachedData = _prefs?.getString(_cacheKey);
      final cachedTimestamps = _prefs?.getString(_timestampKey);
      final cachedFriendStatus = _prefs?.getString(_friendStatusKey);

      if (cachedData != null) {
        final decodedData = jsonDecode(cachedData) as Map<String, dynamic>;
        decodedData.keys.forEach((username) async {
          await getUserData(username, force: true);
        });
      }

      if (cachedTimestamps != null) {
        final decodedTimestamps = jsonDecode(cachedTimestamps) as Map<String, dynamic>;
        decodedTimestamps.forEach((username, timestamp) {
          _lastFetchTimes[username] = DateTime.parse(timestamp);
        });
      }

      if (cachedFriendStatus != null) {
        final decodedFriendStatus = jsonDecode(cachedFriendStatus) as Map<String, dynamic>;
        decodedFriendStatus.forEach((email, status) {
          _friendStatusCache[email] = status as bool;
        });
      }
    } catch (e) {
      print('Error restoring cache: $e');
    }
  }

  void _saveCache() {
    try {
      final encodedData = jsonEncode(_userCache.map((key, value) => 
        MapEntry(key, value.data())));
      final encodedTimestamps = jsonEncode(_lastFetchTimes.map((key, value) => 
        MapEntry(key, value.toIso8601String())));
      final encodedFriendStatus = jsonEncode(_friendStatusCache);

      _prefs?.setString(_cacheKey, encodedData);
      _prefs?.setString(_timestampKey, encodedTimestamps);
      _prefs?.setString(_friendStatusKey, encodedFriendStatus);
    } catch (e) {
      print('Error saving cache: $e');
    }
  }

  bool _shouldRefresh(String username) {
    final lastFetch = _lastFetchTimes[username];
    if (lastFetch == null) return true;
    return DateTime.now().difference(lastFetch) > _cacheExpiry;
  }

  DocumentSnapshot? getCachedUser(String username) {
    final cached = _userCache[username];
    if (cached == null) {
      getUserData(username);
    }
    return cached;
  }

  bool? getFriendStatus(String email) => _friendStatusCache[email];

  Future<bool> checkFriendStatus(String email) async {
    if (_friendStatusCache.containsKey(email)) {
      return _friendStatusCache[email]!;
    }

    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      final querySnapshot = await _firestore
          .collection('friends')
          .where('followerId', isEqualTo: currentUser.email)
          .where('followingId', isEqualTo: email)
          .get();

      final isFriend = querySnapshot.docs.isNotEmpty;
      _friendStatusCache[email] = isFriend;
      _saveCache();
      return isFriend;
    } catch (e) {
      print('Error checking friend status: $e');
      return false;
    }
  }

  Future<void> toggleFriendStatus(String email) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    final currentStatus = await checkFriendStatus(email);
    
    try {
      if (currentStatus) {
        // Remove friend
        final querySnapshot = await _firestore
            .collection('friends')
            .where('followerId', isEqualTo: currentUser.email)
            .where('followingId', isEqualTo: email)
            .get();

        for (var doc in querySnapshot.docs) {
          await doc.reference.delete();
        }
        _friendStatusCache[email] = false;
      } else {
        // Add friend
        await _firestore.collection('friends').add({
          'followerId': currentUser.email,
          'followingId': email,
          'timestamp': FieldValue.serverTimestamp(),
        });
        _friendStatusCache[email] = true;
      }
      _saveCache();
      notifyListeners();
    } catch (e) {
      print('Error toggling friend status: $e');
      // Revert cache on error
      _friendStatusCache[email] = currentStatus;
      _saveCache();
      notifyListeners();
      rethrow;
    }
  }

  Future<DocumentSnapshot?> getUserData(String username, {bool force = false}) async {
    if (_pendingFetches.containsKey(username)) {
      return _pendingFetches[username]!.future;
    }

    if (!force && _userCache.containsKey(username) && !_shouldRefresh(username)) {
      return _userCache[username];
    }

    final completer = Completer<DocumentSnapshot?>();
    _pendingFetches[username] = completer;

    try {
      final userSnapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        final doc = userSnapshot.docs.first;
        _userCache[username] = doc;
        _lastFetchTimes[username] = DateTime.now();
        
        // Pre-fetch friend status
        final email = doc.data()['email'] as String?;
        if (email != null) {
          checkFriendStatus(email);
        }
        
        _saveCache();
        completer.complete(doc);
        notifyListeners();
      } else {
        completer.complete(null);
      }
    } catch (e) {
      print('Error fetching user data: $e');
      completer.complete(null);
    } finally {
      _pendingFetches.remove(username);
    }

    return completer.future;
  }

  void setupRealtimeUpdates(String username) {
    // Cancel existing subscriptions
    _userSubscriptions[username]?.cancel();
    
    // Set up new subscription with debouncing
    final subscription = _firestore
        .collection('users')
        .where('username', isEqualTo: username)
        .limit(1)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final newDoc = snapshot.docs.first;
        final existingDoc = _userCache[username];

        if (existingDoc == null || 
            !const DeepCollectionEquality().equals(existingDoc.data(), newDoc.data())) {
          _userCache[username] = newDoc;
          _lastFetchTimes[username] = DateTime.now();
          _saveCache();
          
          // Update friend status in background
          final email = newDoc.data()['email'] as String?;
          if (email != null) {
            checkFriendStatus(email);
          }
          
          notifyListeners();
        }
      }
    });

    _userSubscriptions[username] = subscription;

    // Set up friend status listener
    final currentUser = _auth.currentUser;
    if (currentUser != null && _userCache[username] != null) {
      final email = (_userCache[username]!.data() as Map<String, dynamic>)['email'] as String?;
      if (email != null) {
        _friendSubscriptions[username]?.cancel();
        final friendSubscription = _firestore
            .collection('friends')
            .where('followerId', isEqualTo: currentUser.email)
            .where('followingId', isEqualTo: email)
            .snapshots()
            .listen((snapshot) {
          final isFriend = snapshot.docs.isNotEmpty;
          if (_friendStatusCache[email] != isFriend) {
            _friendStatusCache[email] = isFriend;
            _saveCache();
            notifyListeners();
          }
        });
        _friendSubscriptions[username] = friendSubscription;
      }
    }
  }

  @override
  void dispose() {
    for (var subscription in _userSubscriptions.values) {
      subscription.cancel();
    }
    for (var subscription in _friendSubscriptions.values) {
      subscription.cancel();
    }
    _userSubscriptions.clear();
    _friendSubscriptions.clear();
    super.dispose();
  }
} 