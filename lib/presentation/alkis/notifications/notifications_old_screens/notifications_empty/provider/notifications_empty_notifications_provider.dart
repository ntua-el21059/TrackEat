import 'package:flutter/material.dart';
import '../../../../../../core/app_export.dart';
import '../models/notifications_empty_notifications_model.dart';

// Provider class for managing the empty notifications screen state
class NotificationsEmptyNotificationsProvider extends ChangeNotifier {
  // Model object containing the empty state data
  NotificationsEmptyNotificationsModel notificationsEmptyNotificationsModelObj =
      NotificationsEmptyNotificationsModel();

  @override
  void dispose() {
    super.dispose();
  }
}
