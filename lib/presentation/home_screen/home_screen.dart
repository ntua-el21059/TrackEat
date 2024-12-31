import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../profile_screen/provider/profile_provider.dart';

Consumer<ProfileProvider>(
  builder: (context, profileProvider, _) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.email)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final userData = snapshot.data!.data() as Map<String, dynamic>?;
          // Get calories from Firebase, fallback to profile provider, then default
          final dailyCalories = userData?['dailyCalories']?.toString() ?? 
              profileProvider.profileModelObj.profileItemList
                  .firstWhere((item) => item.title == "Calories Goal")
                  .value?.replaceAll(RegExp(r'[^0-9]'), '') ?? 
              '2000';
          
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "500 Kcal Remaining...",
                style: TextStyle(
                  fontSize: 16.h,
                  color: Colors.black,
                ),
              ),
              Text(
                "$dailyCalories kcal",
                style: TextStyle(
                  fontSize: 16.h,
                  color: Colors.red,
                ),
              ),
            ],
          );
        }
        
        // Show value from provider while loading Firebase
        final defaultCalories = profileProvider.profileModelObj.profileItemList
            .firstWhere((item) => item.title == "Calories Goal")
            .value?.replaceAll(RegExp(r'[^0-9]'), '') ?? 
            '2000';
            
        return Text(
          "$defaultCalories kcal",
          style: TextStyle(
            fontSize: 16.h,
            color: Colors.red,
          ),
        );
      },
    );
  },
) 