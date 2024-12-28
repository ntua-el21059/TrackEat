import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/app_export.dart';
import '../core/theme/theme_constants.dart';

enum BottomBarEnum { Home, Leaderboard }

class CustomBottomBar extends StatefulWidget {
  const CustomBottomBar({Key? key, this.onChanged}) : super(key: key);

  final Function(BottomBarEnum)? onChanged;

  @override
  CustomBottomBarState createState() => CustomBottomBarState();
}

class CustomBottomBarState extends State<CustomBottomBar> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: ThemeConstants.borderColor,
                width: 1,
              ),
            ),
          ),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.only(top: 5, bottom: 15),
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
                    index: 0,
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
                    index: 2,
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
                setState(() {
                  selectedIndex = 1;
                });
                widget.onChanged?.call(BottomBarEnum.Home);
              },
              child: SvgPicture.asset(
                'assets/images/AI logo.svg',
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
    required int index,
  }) {
    final bool isSelected = selectedIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
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
              isSelected ? appTheme.gray50001 : const Color(0xFF999999),
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: ThemeConstants.textColor,
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