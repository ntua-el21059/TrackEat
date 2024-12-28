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
      padding: EdgeInsets.symmetric(horizontal: 17.h),
      child: Row(
        children: [
          Container(
            width: 48.h,
            height: 48.h,
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(
              child: CustomImageView(
                imagePath: cardsItemModelObj.thumbsupOne!,
                width: 32.h,
                height: 32.h,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 8.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  cardsItemModelObj.cutdownsweets!,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Inter',
                    letterSpacing: -0.43,
                    height: 1,
                  ),
                ),
                Text(
                  cardsItemModelObj.yourweekly!.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                    letterSpacing: 0.36,
                    height: 3.3,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
