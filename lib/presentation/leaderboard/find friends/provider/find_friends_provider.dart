import 'package:flutter/material.dart';
import '../../../../../core/app_export.dart';
import '../models/find_friends_model.dart';

// This provider class manages the state and data for the Find Friends screen.
// It follows the ChangeNotifier pattern to enable reactive UI updates when the state changes.
class FindFriendsProvider extends ChangeNotifier {
  // The TextEditingController handles the search input field, allowing users to
  // filter and find specific friends. When users type in the search box, this
  // controller manages that text input.
  TextEditingController searchController = TextEditingController();

  // This model object holds the list of friend suggestions that will be displayed.
  // It's initialized with a default set of friend suggestions that we saw defined
  // in FindFriendsModel.
  FindFriendsModel findFriendsModelObj = FindFriendsModel();

  @override
  // The dispose method is called when this provider is no longer needed.
  // It's essential for cleaning up resources and preventing memory leaks.
  // Here we make sure to dispose of the searchController when it's done.
  void dispose() {
    super.dispose();
    searchController.dispose();
  }
}
