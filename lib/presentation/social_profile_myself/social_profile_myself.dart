import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../providers/user_info_provider.dart';

class SocialProfileMyself extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserInfoProvider>(
      builder: (context, userInfo, _) => GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Text(
          userInfo.firstName,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
} 