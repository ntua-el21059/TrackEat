/// This class is used in the [listvegan_item_widget] screen.
// ignore_for_file: must_be_immutable
class ListveganItemModel {
  final String title;
  final String count;
  final String? username;
  final bool isStatic;

  ListveganItemModel({
    required this.title,
    this.count = '',
    this.username,
    this.isStatic = false,
  });

  factory ListveganItemModel.fromJson(Map<String, dynamic> json) {
    return ListveganItemModel(
      title: json['title'] as String,
      count: json['count'] as String? ?? '',
      username: json['username'] as String?,
      isStatic: json['isStatic'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'count': count,
      'username': username,
      'isStatic': isStatic,
    };
  }

  ListveganItemModel copyWith({
    String? title,
    String? count,
    String? username,
    bool? isStatic,
  }) {
    return ListveganItemModel(
      title: title ?? this.title,
      count: count ?? this.count,
      username: username ?? this.username,
      isStatic: isStatic ?? this.isStatic,
    );
  }
}