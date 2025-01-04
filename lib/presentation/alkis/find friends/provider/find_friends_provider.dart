import 'package:flutter/material.dart';
import '../models/find_friends_model.dart';
import '../models/find_friends_item_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../models/user_model.dart';

class FindFriendsProvider extends ChangeNotifier {
  FindFriendsModel _findFriendsModelObj = FindFriendsModel();
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  bool _isSearching = false;

  FindFriendsModel get findFriendsModelObj => _findFriendsModelObj;
  bool get isSearching => _isSearching;

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  void startSearch() {
    _isSearching = true;
    notifyListeners();
    // Delay focus to wait for the search UI to build
    Future.delayed(Duration(milliseconds: 100), () {
      searchFocusNode.requestFocus();
    });
  }

  Future<void> fetchUsers() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      final usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isNotEqualTo: currentUser.email)
          .get();

      final users = usersSnapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .where((user) => user.username != null && user.username!.isNotEmpty)
          .map((user) => FindFriendsItemModel.fromUserModel(user))
          .toList();

      _findFriendsModelObj.findFriendsItemList = users;
      notifyListeners();
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  void searchUsers(String query) {
    if (query == " ") {
      startSearch();
      searchController.clear();
      return;
    }

    _isSearching = query.isNotEmpty;

    if (query.isEmpty) {
      fetchUsers();
      return;
    }

    final lowercaseQuery = query.toLowerCase();
    final filteredUsers = _findFriendsModelObj.findFriendsItemList
        .where((user) =>
            user.username?.toLowerCase().contains(lowercaseQuery) == true ||
            user.fullName?.toLowerCase().contains(lowercaseQuery) == true)
        .toList();

    _findFriendsModelObj.findFriendsItemList = filteredUsers;
    notifyListeners();
  }

  void cancelSearch() {
    searchController.clear();
    _isSearching = false;
    searchFocusNode.unfocus();
    fetchUsers();
  }
}
