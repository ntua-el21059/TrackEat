import 'package:flutter/material.dart';

class SuggestionItem extends StatelessWidget {
  final String iconUrl;
  final String title;
  final String subtitle;

  const SuggestionItem({
    Key? key,
    required this.iconUrl,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      height: 77,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.transparent,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(
              child: Image.network(
                iconUrl,
                width: 32,
                height: 32,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
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
                  subtitle.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                    letterSpacing: 0.36,
                    height: 3.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}