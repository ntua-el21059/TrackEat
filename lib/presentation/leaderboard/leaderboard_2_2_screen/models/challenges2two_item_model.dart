import '../../../core/app_export.dart';

// Model class for a challenge item in the challenges widget
class Challenges2twoItemModel {
  // Constructor with default values for image and text content
  Challenges2twoItemModel({this.vectorOne, this.beatlesOne, this.id}) {
    vectorOne = vectorOne ?? ImageConstant.imgVector78x72;
    beatlesOne = beatlesOne ?? "beatles \nchallenge";
    id = id ?? "";
  }

  String? vectorOne; // Path to the vector image
  String? beatlesOne; // Challenge title text
  String? id; // Unique identifier for the challenge
}
