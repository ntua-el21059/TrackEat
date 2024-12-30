import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/notifications_unread_model.dart';
import '../models/read_two_item_model.dart';

/// A provider class for the NotificationsUnreadScreen.
///
/// This provider manages the state of the NotificationsUnreadScreen, including the
/// current notificationsUnreadModelObj
// ignore_for_file: must_be_immutable
class NotificationsUnreadProvider extends ChangeNotifier {
  // Initialize the model object that holds all unread notifications
  NotificationsUnreadModel notificationsUnreadModelObj =
      NotificationsUnreadModel();

  // Cleanup method to prevent memory leaks
  @override
  void dispose() {
    super.dispose();
  }
}
