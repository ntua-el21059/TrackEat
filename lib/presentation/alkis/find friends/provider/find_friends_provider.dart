import 'package:flutter/material.dart';
import '../models/find_friends_model.dart';
import '../models/find_friends_item_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../models/user_model.dart';
import 'dart:convert';

class FindFriendsProvider extends ChangeNotifier {
  FindFriendsModel _findFriendsModelObj = FindFriendsModel();
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  List<FindFriendsItemModel> _allUsers = [];
  List<FindFriendsItemModel> _filteredUsers = [];
  Set<String> _friendEmails = {};
  Map<String, Image> _imageCache = {};

  FindFriendsModel get findFriendsModelObj => _findFriendsModelObj;
  List<FindFriendsItemModel> get filteredUsers => _filteredUsers;
  bool get isSearching => searchController.text.isNotEmpty;

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    _imageCache.clear();
    super.dispose();
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

  Future<void> fetchUsers() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        print('No current user found');
        return;
      }
      print('Current user email: ${currentUser.email}');

      // Get all users except current user
      final usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isNotEqualTo: currentUser.email)
          .get();
      print('Found ${usersSnapshot.docs.length} total users');

      // Get current user's friends
      final friendsSnapshot = await FirebaseFirestore.instance
          .collection('friends')
          .where('followerId', isEqualTo: currentUser.email)
          .get();
      print('Found ${friendsSnapshot.docs.length} friends');

      // Store friend emails for filtering
      _friendEmails = friendsSnapshot.docs
          .map((doc) => doc.data()['followingId'] as String)
          .toSet();
      print('Friend emails: $_friendEmails');

      // Get all users with valid usernames
      _allUsers = usersSnapshot.docs
          .map((doc) {
            try {
              return UserModel.fromJson(doc.data());
            } catch (e) {
              print('Error parsing user data: $e');
              print('User data: ${doc.data()}');
              return null;
            }
          })
          .where((user) => 
              user != null &&
              user.username != null && 
              user.username!.isNotEmpty)
          .map((user) => FindFriendsItemModel.fromUserModel(user!))
          .toList();
      print('Found ${_allUsers.length} total users to display');

      // Pre-cache all profile images
      for (var user in _allUsers) {
        if (user.profileImage != null && user.profileImage!.isNotEmpty) {
          getCachedImage(user.profileImage);
        }
      }

      updateFilteredUsers();
    } catch (e) {
      print('Error fetching users: $e');
      print(e.toString());
    }
  }

  void updateFilteredUsers() {
    if (searchController.text.isEmpty) {
      // For "People you may know", exclude friends
      _filteredUsers = _allUsers
          .where((user) => !_friendEmails.contains(user.email))
          .toList();
    } else {
      // For search results, include all users
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
      // Show non-friends in "People you may know"
      _filteredUsers = _allUsers
          .where((user) => !_friendEmails.contains(user.email))
          .toList();
    } else {
      // Show all matching users in search results
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
    // Show non-friends in "People you may know"
    _filteredUsers = _allUsers
        .where((user) => !_friendEmails.contains(user.email))
        .toList();
    _findFriendsModelObj.findFriendsItemList = _filteredUsers;
    notifyListeners();
  }
}
