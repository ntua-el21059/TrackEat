import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import '../models/blur_edit_item_model.dart';

// ignore_for_file: must_be_immutable
class BlurEditItemWidget extends StatelessWidget {
  BlurEditItemWidget(this.blurEditItemModelObj, {Key? key})
      : super(
          key: key,
        );

  BlurEditItemModel blurEditItemModelObj;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64.h,
      child: Row(
        children: [
          SizedBox(
            height: 36.h,
            width: 6.h,
          ),
          SizedBox(width: 2.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  blurEditItemModelObj.weight!,
                  style: CustomTextStyles.labelLargeBlack900,
                ),
                SizedBox(height: 2.h),
                Text(
                  blurEditItemModelObj.protein!,
                  style: CustomTextStyles.bodyLargeBlack90016,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
