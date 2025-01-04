class LeaderboardUserModel {
  final String username;
  final String fullName;
  final int points;
  final String email;
  final bool isCurrentUser;

  LeaderboardUserModel({
    required this.username,
    required this.fullName,
    required this.points,
    required this.email,
    required this.isCurrentUser,
  });
}
