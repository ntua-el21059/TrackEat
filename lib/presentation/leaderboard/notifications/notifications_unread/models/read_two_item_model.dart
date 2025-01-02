import '../../../../../core/app_export.dart';

/// This class is used in the [read_two_item_widget] screen.
// ignore_for_file: must_be_immutable
class ReadTwoItemModel {
  // Constructor takes optional parameters for the notification message and ID
  ReadTwoItemModel({this.miabrooksier, this.id}) {
    // Default values are provided if parameters are null
    miabrooksier = miabrooksier ?? "@miabrooksier added you";
    id = id ?? "";
  }

  // Properties to store notification data
  String? miabrooksier; // Stores the notification message
  String? id; // Stores a unique identifier
}
