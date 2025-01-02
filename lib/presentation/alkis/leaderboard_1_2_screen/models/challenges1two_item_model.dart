import '../../../core/app_export.dart';

/// This class represents the data structure for an avocado challenge item
/// that appears in the challenges list screen.
// ignore_for-file: must_be_immutable
class Challenges1twoItemModel {
  // Constructor with optional named parameters using null safety
  Challenges1twoItemModel({this.vectorOne, this.avocadoOne, this.id}) {
    // Default values ensure we always have valid data
    vectorOne = vectorOne ?? ImageConstant.imgVector76x86;
    avocadoOne = avocadoOne ?? "Avocado \nchallenge";
    id = id ?? "";
  }

  // Properties storing essential challenge information
  String? vectorOne; // Path to the challenge's vector image
  String? avocadoOne; // Title of the challenge
  String? id; // Unique identifier for tracking
}
