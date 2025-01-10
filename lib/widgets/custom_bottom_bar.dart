import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io' show Platform;
import '../core/app_export.dart';
import '../core/theme/theme_constants.dart';

enum BottomBarEnum {
  Home,
  Leaderboard,
  AI,
}

class CustomBottomBar extends StatefulWidget {
  const CustomBottomBar({
    Key? key,
    this.onChanged,
    this.backgroundColor,
  }) : super(key: key);

  final Function(BottomBarEnum)? onChanged;
  final Color? backgroundColor;

  @override
  CustomBottomBarState createState() => CustomBottomBarState();
}

class CustomBottomBarState extends State<CustomBottomBar> {
  @override
  Widget build(BuildContext context) {
    final String currentRoute = ModalRoute.of(context)?.settings.name ?? '';
    final bottomPadding = Platform.isAndroid ? MediaQuery.of(context).padding.bottom : 0.0;
    
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? Colors.white,
            border: Border(
              top: BorderSide(
                color: ThemeConstants.borderColor,
                width: 1,
              ),
            ),
          ),
          child: Container(
            padding: EdgeInsets.only(
              top: 5,
              bottom: Platform.isAndroid ? 15 + bottomPadding : 15,
            ),
            constraints: BoxConstraints(maxWidth: ThemeConstants.maxWidth),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: _buildNavigationItem(
                    icon: 'assets/images/home.svg',
                    label: 'Home',
                    width: 35,
                    aspectRatio: 1.3,
                    type: BottomBarEnum.Home,
                    isSelected: currentRoute == AppRoutes.homeScreen,
                  ),
                ),
                const Spacer(),
                Expanded(
                  child: _buildNavigationItem(
                    icon: 'assets/images/Leaderboard.svg',
                    label: 'Leaderboard',
                    width: 28,
                    aspectRatio: 0.92,
                    type: BottomBarEnum.Leaderboard,
                    isSelected: currentRoute == AppRoutes.leaderboardScreen,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: -10,
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTap: () {
                if (currentRoute != AppRoutes.aiChatMainScreen) {
                  widget.onChanged?.call(BottomBarEnum.AI);
                  Navigator.pushNamed(context, AppRoutes.aiChatMainScreen);
                }
              },
              child: SvgPicture.asset(
                'assets/images/ai_logo.svg',
                width: 65,
                height: 65,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationItem({
    required String icon,
    required String label,
    required double width,
    required double aspectRatio,
    required BottomBarEnum type,
    required bool isSelected,
  }) {
    final Color selectedColor = const Color(0xFF007AFF);
    
    return GestureDetector(
      onTap: () {
        widget.onChanged?.call(type);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon,
            width: width,
            height: width / aspectRatio,
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(
              isSelected ? selectedColor : const Color(0xFF999999),
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? selectedColor : ThemeConstants.textColor,
              fontSize: 12,
              fontFamily: ThemeConstants.fontFamily,
              fontWeight: ThemeConstants.fontWeight,
            ),
          ),
        ],
      ),
    );
  }
}

class DefaultWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffffffff),
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Please replace the respective Widget here',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}