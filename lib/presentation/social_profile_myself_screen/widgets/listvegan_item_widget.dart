import 'package:flutter/material.dart';
import '../models/listvegan_item_model.dart';
import '../../../core/app_export.dart';
import 'package:provider/provider.dart';
import '../../../presentation/social_profile_view_screen/provider/social_profile_view_provider.dart';

class ListveganItemWidget extends StatelessWidget {
  final ListveganItemModel model;

  const ListveganItemWidget(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160.h,
      height: 100.h,
      padding: EdgeInsets.symmetric(
        horizontal: 10.h,
        vertical: 8.h,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF8FB8E0).withOpacity(0.3),
        borderRadius: BorderRadius.circular(21),
      ),
      child: Center(
        child: model.count?.isEmpty ?? true
          ? Text(
              model.title ?? '',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.1,
              ),
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            )
          : RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: model.title ?? '',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.1,
                    ),
                  ),
                  TextSpan(
                    text: model.count ?? '',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.1,
                      shadows: [
                        Shadow(
                          blurRadius: 3.0,
                          color: Colors.black.withOpacity(0.3),
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}