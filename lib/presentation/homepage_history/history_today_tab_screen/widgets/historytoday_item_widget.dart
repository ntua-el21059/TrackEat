import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import '../models/historytoday_item_model.dart';

// ignore_for_file: must_be_immutable
class HistorytodayItemWidget extends StatelessWidget {
  HistorytodayItemWidget(this.historytodayItemModelObj, {Key? key}) : super(key: key);

  final HistorytodayItemModel historytodayItemModelObj;

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
                  historytodayItemModelObj.weight!,
                  style: CustomTextStyles.labelLargeBlack900,
                ),
                Text(
                  historytodayItemModelObj.protein!,
                  style: CustomTextStyles.bodyLargeBlack90016,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
