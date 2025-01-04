import '../../../../../core/app_export.dart';
import 'find_friends_item_model.dart';

// This model class manages a list of suggested friends to be displayed in the Find Friends feature.
// It demonstrates the app's friend recommendation system by providing a diverse set of sample users.
class FindFriendsModel {
  // The list holds multiple FindFriendsItemModel objects, each representing a potential friend
  // suggestion. The list is initialized with sample data showing different patterns of data:
  // - Some entries have both images and names (Oliver Gray, Amelia Brooks)
  // - Others have only names, which will use the default profile image
  List<FindFriendsItemModel> findFriendsItemList = [
    // Initial empty list - will be populated from Firestore
  ];
}
