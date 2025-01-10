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
  Map<String, Image> _imageCache = {};

  FindFriendsModel get findFriendsModelObj => _findFriendsModelObj;
  List<FindFriendsItemModel> get filteredUsers => _filteredUsers;

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
      if (currentUser == null) return;

      final usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isNotEqualTo: currentUser.email)
          .get();

      _allUsers = usersSnapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .where((user) => user.username != null && user.username!.isNotEmpty)
          .map((user) => FindFriendsItemModel.fromUserModel(user))
          .toList();

      // Pre-cache all profile images
      for (var user in _allUsers) {
        if (user.profileImage != null && user.profileImage!.isNotEmpty) {
          getCachedImage(user.profileImage);
        }
      }

      _filteredUsers = List.from(_allUsers);
      _findFriendsModelObj.findFriendsItemList = _allUsers;
      notifyListeners();
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  void searchUsers(String query) {
    if (query.isEmpty) {
      _filteredUsers = List.from(_allUsers);
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
    _filteredUsers = List.from(_allUsers);
    _findFriendsModelObj.findFriendsItemList = _allUsers;
    notifyListeners();
  }
}
