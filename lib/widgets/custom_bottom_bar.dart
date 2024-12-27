import 'package:flutter/material.dart';
import '../core/app_export.dart';

enum BottomBarEnum { Home, Leaderboard }

// ignore_for_file: must_be_immutable
class CustomBottomBar extends StatefulWidget {
  CustomBottomBar({this.onChanged});

  Function(BottomBarEnum)? onChanged;

  @override
  CustomBottomBarState createState() => CustomBottomBarState();
}

// ignore_for_file: must_be_immutable
class CustomBottomBarState extends State<CustomBottomBar> {
  int selectedIndex = 0;

  List<BottomMenuModel> bottomMenuList = [
    BottomMenuModel(
      icon: ImageConstant.imgNavHome,
      activeIcon: ImageConstant.imgNavHome,
      title: "Home",
      type: BottomBarEnum.Home,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgAiLogo2,
      activeIcon: ImageConstant.imgAiLogo2,
      title: "Home",
      type: BottomBarEnum.Home,
      isCircle: true,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgNavLeaderboard,
      activeIcon: ImageConstant.imgNavLeaderboard,
      title: "Leaderboard",
      type: BottomBarEnum.Leaderboard,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: appTheme.gray500,
            width: 1.h,
          ),
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedFontSize: 0,
        elevation: 0,
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: List.generate(bottomMenuList.length, (index) {
          if (bottomMenuList[index].isCircle) {
            return BottomNavigationBarItem(
              icon: CustomImageView(
                imagePath: bottomMenuList[index].icon,
                height: 70.h,
                width: 72.h,
              ),
              label: '',
            );
          }
          return BottomNavigationBarItem(
            icon: CustomImageView(
              imagePath: bottomMenuList[index].icon,
              height: 70.h,
              width: 72.h,
              color: appTheme.cyan900,
            ),
            activeIcon: SizedBox(
              width: 32.h,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomImageView(
                    imagePath: bottomMenuList[index].activeIcon,
                    height: 22.h,
                    width: double.maxFinite,
                    color: appTheme.gray50001,
                  ),
                  Text(
                    bottomMenuList[index].title ?? "",
                    style: theme.textTheme.labelMedium!.copyWith(
                      color: appTheme.gray50001,
                    ),
                  ),
                ],
              ),
            ),
            label: '',
          );
        }),
        onTap: (index) {
          selectedIndex = index;
          widget.onChanged?.call(bottomMenuList[index].type);
          setState(() {});
        },
      ),
    );
  }
}

// ignore_for_file: must_be_immutable
class BottomMenuModel {
  BottomMenuModel({
    required this.icon,
    required this.activeIcon,
    this.title,
    required this.type,
    this.isCircle = false,
  });

  String icon;
  String activeIcon;
  String? title;
  BottomBarEnum type;
  bool isCircle;
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