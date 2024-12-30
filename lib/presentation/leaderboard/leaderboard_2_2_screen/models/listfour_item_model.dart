import '../../../core/app_export.dart';

// Model class for each entry in the leaderboard list, containing user ranking details
class ListfourItemModel {
  // Constructor that sets default values for all properties if not provided
  ListfourItemModel(
      {this.four, this.image, this.garylee, this.ptsCounter, this.id}) {
    four = four ?? "4"; // Position/rank number
    image = image ?? ImageConstant.imgVector32x32; // User's avatar image
    garylee = garylee ?? "nancy_reagan"; // Username
    ptsCounter = ptsCounter ?? "36 pts"; // Points display
    id = id ?? ""; // Unique identifier
  }

  String? four; // User's position in the leaderboard
  String? image; // Path to user's profile image
  String? garylee; // Username to display
  String? ptsCounter; // User's points formatted as string
  String? id; // Unique ID for the leaderboard entry
}
