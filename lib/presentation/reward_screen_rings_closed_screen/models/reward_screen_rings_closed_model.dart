import '../../../core/app_export.dart';

class RewardScreenRingsClosedModel {
  // Add properties for the reward screen
  final String title;
  final String subtitle;
  final String imagePath;
  final bool isCompleted;

  RewardScreenRingsClosedModel({
    this.title = "Congratulations!",
    this.subtitle = "You closed your rings!",
    this.imagePath = "",
    this.isCompleted = true,
  });
}