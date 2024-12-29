import '../../../core/app_export.dart';

class ChallengeAwardModel {
  final String title;
  final String description;
  final String earnedDate;
  final String imagePath;

  ChallengeAwardModel({
    required this.title,
    required this.description,
    required this.earnedDate,
    required this.imagePath,
  });

  static ChallengeAwardModel goldenLadle() => ChallengeAwardModel(
    title: "Golden Ladle Award",
    description: "You've earned the Golden Ladle Award for serving up 30 days of healthy, delicious, and nourishing meals! 🍴⭐",
    earnedDate: "November 18, 2023",
    imagePath: ImageConstant.imgGoldenLadle,
  );

  static ChallengeAwardModel sugarFree() => ChallengeAwardModel(
    title: "Sweat Escape Award",
    description: "You earned this award because you embraced the challenge, transforming your health by cutting out added sugars!",
    earnedDate: "November 18, 2023",
    imagePath: ImageConstant.imgSweetEscape,
  );

  static ChallengeAwardModel goldenApple() => ChallengeAwardModel(
    title: "Golden Apple Award",
    description: "You earned this award because you crushed it, enjoying an apple a day for two whole weeks!",
    earnedDate: "November 18, 2023",
    imagePath: ImageConstant.imgGoldenApple,
  );

  static ChallengeAwardModel halfWayThrough() => ChallengeAwardModel(
    title: "Half Mile Through",
    description: "You earned this award because you reached halfway to your goal weight with determination and effort!",
    earnedDate: "November 18, 2023",
    imagePath: ImageConstant.imgHalfMileThrough,
  );

  static ChallengeAwardModel carnivoreChallenge() => ChallengeAwardModel(
    title: "Carnivore Challenge Award",
    description: "You earned this award because you conquered the 15-day carnivore challenge, fueling your body with strength!",
    earnedDate: "November 18, 2023",
    imagePath: ImageConstant.imgCarnivoreChallenge,
  );

  static ChallengeAwardModel avocadoExcellence() => ChallengeAwardModel(
    title: "Avocado Excellence Award",
    description: "You earned this award because you embraced the avocado challenge, savoring its goodness like a true pro! 🥑✨",
    earnedDate: "November 18, 2023",
    imagePath: ImageConstant.imgAvocadoExcellence,
  );
}