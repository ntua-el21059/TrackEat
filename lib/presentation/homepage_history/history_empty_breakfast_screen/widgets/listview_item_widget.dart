import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import '../models/listview_item_model.dart';

// ignore_for_file: must_be_immutable
class ListviewItemWidget extends StatelessWidget {
  ListviewItemWidget(this.listviewItemModelObj, {Key? key}) : super(key: key);

  ListviewItemModel listviewItemModelObj;

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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  listviewItemModelObj.weight!,
                  style: CustomTextStyles.labelLargeBlack900,
                ),
                Text(
                  listviewItemModelObj.protein!,
                  style: CustomTextStyles.bodyLargeBlack90016_1,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
