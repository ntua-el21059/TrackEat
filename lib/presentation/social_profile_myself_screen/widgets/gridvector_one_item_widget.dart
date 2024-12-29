import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/gridvector_one_item_model.dart';

// ignore_for_file: must_be_immutable
class GridvectorOneItemWidget extends StatelessWidget {
  final GridvectorOneItemModel model;

  const GridvectorOneItemWidget(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Attempting to load image: ${model.image}'); // Debug print

    return Container(
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12.h),
      ),
      child: Image.asset(
        model.image ?? '',
        height: 100.h,
        width: 100.h,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          print('Error loading image: $error');
          return Container(
            padding: EdgeInsets.all(8.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error),
                const SizedBox(height: 4),
                Text(
                  'Error: ${model.image}',
                  style: const TextStyle(fontSize: 8),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}