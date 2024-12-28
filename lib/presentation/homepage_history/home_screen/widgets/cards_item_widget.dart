import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import '../../../../widgets/custom_icon_button.dart';
import '../models/cards_item_model.dart';

// ignore_for_file: must_be_immutable
class CardsItemWidget extends StatelessWidget {
  CardsItemWidget(this.cardsItemModelObj, {Key? key}) : super(key: key);

  final CardsItemModel cardsItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 14.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: CustomIconButton(
              height: 48.h,
              width: 48.h,
              padding: EdgeInsets.all(8.h),
              decoration: IconButtonStyleHelper.none,
              alignment: Alignment.bottomCenter,
              child: CustomImageView(
                imagePath: cardsItemModelObj.thumbsupOne!,
              ),
            ),
          ),
          SizedBox(width: 8.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cardsItemModelObj.cutdownsweets!,
                  style: CustomTextStyles.bodyLargeBlack900,
                ),
                SizedBox(height: 6.h),
                Text(
                  cardsItemModelObj.yourweekly!,
                  style: CustomTextStyles.labelMediumOnErrorContainer_1,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
