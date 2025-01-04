import 'package:flutter/material.dart';
import '../../../../../../core/app_export.dart';
import '../models/notifications_read_model.dart';
import '../models/read_two_item_model.dart';

/// A provider class for the NotificationsReadScreen.
///
/// This provider manages the state of the NotificationsReadScreen, including the
/// current notificationsReadModelObj. It extends ChangeNotifier to enable state
/// management and UI updates when the data changes.
// ignore_for_file: must_be_immutable
class NotificationsReadProvider extends ChangeNotifier {
  // Controllers for handling text input in the notification screen
  TextEditingController firstoneController = TextEditingController();
  TextEditingController firstthreeController = TextEditingController();

  // Model object that holds the notification data
  NotificationsReadModel notificationsReadModelObj = NotificationsReadModel();

  // Cleanup method to prevent memory leaks
  @override
  void dispose() {
    super.dispose();
    firstoneController.dispose();
    firstthreeController.dispose();
  }
}
