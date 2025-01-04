import 'package:flutter/material.dart';
import '../core/app_export.dart';

class CustomSearchView extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final EdgeInsetsGeometry? contentPadding;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onCancel;
  final bool showCancel;

  const CustomSearchView({
    Key? key,
    this.controller,
    this.hintText,
    this.contentPadding,
    this.onChanged,
    this.onCancel,
    this.showCancel = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 12.h,
      ),
      decoration: BoxDecoration(
        color: Color(0xFFF2F2F7),
        borderRadius: BorderRadius.circular(10.h),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: Colors.grey[500],
            size: 20.h,
          ),
          SizedBox(width: 8.h),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16.h,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 16.h,
                ),
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                suffixIcon: controller?.text.isNotEmpty == true && showCancel
                    ? IconButton(
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                        icon: Icon(
                          Icons.clear,
                          color: Colors.grey[500],
                          size: 20.h,
                        ),
                        onPressed: () {
                          controller?.clear();
                          onChanged?.call('');
                          onCancel?.call();
                        },
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
