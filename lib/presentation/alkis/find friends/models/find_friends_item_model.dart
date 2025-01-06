import '../../../../../models/user_model.dart';

class FindFriendsItemModel {
  FindFriendsItemModel({
    this.profileImage,
    this.username,
    this.fullName,
    this.email,
  });

  String? profileImage;
  String? username;
  String? fullName;
  String? email;

  factory FindFriendsItemModel.fromUserModel(UserModel user) {
    return FindFriendsItemModel(
      profileImage: user.profilePicture,
      username: user.username,
      fullName: "${user.firstName ?? ''} ${user.lastName ?? ''}".trim(),
      email: user.email,
    );
  }
}
