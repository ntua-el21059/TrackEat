import 'package:flutter/material.dart';
import '../models/find_friends_model.dart';
import '../models/find_friends_item_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../models/user_model.dart';
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';

class FindFriendsProvider extends ChangeNotifier {
  FindFriendsModel _findFriendsModelObj = FindFriendsModel();
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  List<FindFriendsItemModel> _allUsers = [];
  List<FindFriendsItemModel> _filteredUsers = [];
  Set<String> _friendEmails = {};
  Map<String, Image> _imageCache = {};
  SharedPreferences? _prefs;
  DateTime? _lastFetchTime;
  StreamSubscription<QuerySnapshot>? _friendsSubscription;
  StreamSubscription<QuerySnapshot>? _usersSubscription;

  FindFriendsModel get findFriendsModelObj => _findFriendsModelObj;
  List<FindFriendsItemModel> get filteredUsers => _filteredUsers;
  bool get isSearching => searchController.text.isNotEmpty;

  FindFriendsProvider() {
    _initCache();
  }

  Future<void> _initCache() async {
    _prefs = await SharedPreferences.getInstance();
    _restoreCachedData();
    _setupRealTimeListeners();
  }

  void _restoreCachedData() {
    final cachedData = _prefs?.getString('find_friends_cache');
    final lastFetchTimeStr = _prefs?.getString('find_friends_last_fetch');
    
    if (lastFetchTimeStr != null) {
      _lastFetchTime = DateTime.parse(lastFetchTimeStr);
    }

    if (cachedData != null) {
      try {
        final decoded = jsonDecode(cachedData);
        _allUsers = (decoded['users'] as List).map((user) {
          return FindFriendsItemModel(
            email: user['email'] as String?,
            username: user['username'] as String?,
            fullName: user['fullName'] as String?,
            profileImage: user['profileImage'] as String?,
          );
        }).toList();
        _friendEmails = Set<String>.from(decoded['friend_emails'] as List);
        
        // Pre-cache images
        for (var user in _allUsers) {
          if (user.profileImage != null && user.profileImage!.isNotEmpty) {
            getCachedImage(user.profileImage);
          }
        }

        updateFilteredUsers();
      } catch (e) {
        print('Error restoring cached find friends data: $e');
      }
    }
  }

  void _setupRealTimeListeners() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    // Listen for friends changes
    _friendsSubscription?.cancel();
    _friendsSubscription = FirebaseFirestore.instance
        .collection('friends')
        .where('followerId', isEqualTo: currentUser.email)
        .snapshots()
        .listen((snapshot) {
      final newFriendEmails = snapshot.docs
          .map((doc) => doc.data()['followingId'] as String)
          .toSet();
      
      if (!const SetEquality<String>().equals(_friendEmails, newFriendEmails)) {
        _friendEmails = newFriendEmails;
        fetchUsers(force: true);
      }
    });

    // Listen for user changes
    _usersSubscription?.cancel();
    _usersSubscription = FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .listen((snapshot) {
      // Only fetch if the last fetch was more than 5 minutes ago
      if (_lastFetchTime == null ||
          DateTime.now().difference(_lastFetchTime!) > Duration(minutes: 5)) {
        fetchUsers(force: true);
      }
    });
  }

  Future<void> fetchUsers({bool force = false}) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      // If we have cached data and it's not a forced update, skip fetching
      if (!force && _allUsers.isNotEmpty) {
        updateFilteredUsers();
        return;
      }

      final usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isNotEqualTo: currentUser.email)
          .get();

      if (!force && _lastFetchTime != null) {
        bool hasChanges = false;
        for (var doc in usersSnapshot.docs) {
          final data = doc.data();
          final cachedUser = _allUsers.firstWhere(
            (u) => u.email == data['email'],
            orElse: () => FindFriendsItemModel(),
          );
          if (cachedUser.email == null || 
              cachedUser.username != data['username'] ||
              cachedUser.profileImage != data['profilePicture']) {
            hasChanges = true;
            break;
          }
        }
        if (!hasChanges) {
          return;
        }
      }

      _allUsers = usersSnapshot.docs
          .map((doc) {
            try {
              return UserModel.fromJson(doc.data());
            } catch (e) {
              print('Error parsing user data: $e');
              return null;
            }
          })
          .where((user) => 
              user != null &&
              user.username != null && 
              user.username!.isNotEmpty)
          .map((user) => FindFriendsItemModel.fromUserModel(user!))
          .toList();

      // Pre-cache images
      for (var user in _allUsers) {
        if (user.profileImage != null && user.profileImage!.isNotEmpty) {
          getCachedImage(user.profileImage);
        }
      }

      _lastFetchTime = DateTime.now();
      await _saveToCache();
      updateFilteredUsers();
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  Future<void> _saveToCache() async {
    if (_prefs != null) {
      final data = {
        'users': _allUsers.map((user) => {
          'email': user.email,
          'username': user.username,
          'fullName': user.fullName,
          'profileImage': user.profileImage,
        }).toList(),
        'friend_emails': _friendEmails.toList(),
      };
      await _prefs?.setString('find_friends_cache', jsonEncode(data));
      await _prefs?.setString('find_friends_last_fetch', _lastFetchTime!.toIso8601String());
    }
  }

  Image? getCachedImage(String? profileImage) {
    if (profileImage == null || profileImage.isEmpty) return null;

    if (!_imageCache.containsKey(profileImage)) {
      final decodedImage = base64Decode(profileImage);
      _imageCache[profileImage] = Image.memory(
        decodedImage,
        gaplessPlayback: true,
        fit: BoxFit.cover,
      );
    }
    return _imageCache[profileImage];
  }

  void updateFilteredUsers() {
    if (searchController.text.isEmpty) {
      _filteredUsers = _allUsers
          .where((user) => !_friendEmails.contains(user.email))
          .toList();
    } else {
      final lowercaseQuery = searchController.text.toLowerCase();
      _filteredUsers = _allUsers
          .where((user) =>
              user.username?.toLowerCase().contains(lowercaseQuery) == true ||
              user.fullName?.toLowerCase().contains(lowercaseQuery) == true)
          .toList();
    }
    _findFriendsModelObj.findFriendsItemList = _filteredUsers;
    notifyListeners();
  }

  void searchUsers(String query) {
    if (query.isEmpty) {
      _filteredUsers = _allUsers
          .where((user) => !_friendEmails.contains(user.email))
          .toList();
    } else {
      final lowercaseQuery = query.toLowerCase();
      _filteredUsers = _allUsers
          .where((user) =>
              user.username?.toLowerCase().contains(lowercaseQuery) == true ||
              user.fullName?.toLowerCase().contains(lowercaseQuery) == true)
          .toList();
    }
    _findFriendsModelObj.findFriendsItemList = _filteredUsers;
    notifyListeners();
  }

  void cancelSearch() {
    searchController.clear();
    searchFocusNode.unfocus();
    _filteredUsers = _allUsers
        .where((user) => !_friendEmails.contains(user.email))
        .toList();
    _findFriendsModelObj.findFriendsItemList = _filteredUsers;
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    _imageCache.clear();
    _friendsSubscription?.cancel();
    _usersSubscription?.cancel();
    super.dispose();
  }
}
