import '../../../../../core/app_export.dart';
import 'read_two_item_model.dart';

/// A model class that represents the notifications read state
/// The [must_be_immutable] annotation is ignored as specified
// ignore_for_file: must_be_immutable
class NotificationsReadModel {
  // List of notification items with predefined messages and empty placeholders
  List<ReadTwoItemModel> readTwoItemList = [
    // Messages from different users
    ReadTwoItemModel(timcookse1nt: "@tim_cook se1nt a message"),
    ReadTwoItemModel(timcookse1nt: "@olie12 started carnivore challenge"),
    ReadTwoItemModel(timcookse1nt: "@benreeds sent a message"),
    ReadTwoItemModel(timcookse1nt: "@tim_cook sent a message"),

    // Empty placeholder notifications
    ReadTwoItemModel(),
    ReadTwoItemModel(),
    ReadTwoItemModel()
  ];
}
