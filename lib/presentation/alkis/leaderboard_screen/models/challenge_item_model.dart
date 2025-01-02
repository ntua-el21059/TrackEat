import '../../../../core/constants/image_constants.dart';

class ChallengeItemModel {
  final String imageUrl;
  final String title;
  final String id;

  ChallengeItemModel({
    String? imageUrl,
    String? title,
    String? id,
  })  : this.imageUrl = imageUrl ?? ImageConstant.imgVector76x86,
        this.title = title ?? "Challenge",
        this.id = id ?? "";
}
