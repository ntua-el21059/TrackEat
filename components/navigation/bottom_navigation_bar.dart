import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color(0xFF999DA3),
            width: 1,
          ),
        ),
      ),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 1),
        constraints: const BoxConstraints(maxWidth: 393),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            NavigationItem(
              icon: 'assets/home_icon.png',
              label: 'Home',
              width: 30,
              aspectRatio: 1.3,
            ),
            Image.asset(
              'assets/center_icon.png',
              width: 70,
              height: 70,
              fit: BoxFit.contain,
            ),
            NavigationItem(
              icon: 'assets/leaderboard_icon.png',
              label: 'Leaderboard',
              width: 24,
              aspectRatio: 0.92,
            ),
          ],
        ),
      ),
    );
  }
}

class NavigationItem extends StatelessWidget {
  final String icon;
  final String label;
  final double width;
  final double aspectRatio;

  const NavigationItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.width,
    required this.aspectRatio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            icon,
            width: width,
            height: width / aspectRatio,
            fit: BoxFit.contain,
          ),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF999999),
              fontSize: 10,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}