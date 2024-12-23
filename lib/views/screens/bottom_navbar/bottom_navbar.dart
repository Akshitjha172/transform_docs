/**
 * @author Akshit Jha
 * Creation Date: 11-12-2024
 */
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transform_docs/res/image/app_image.dart';
import 'package:transform_docs/views/screens/home/home_screen.dart';
import 'package:transform_docs/views/screens/settings/settings_screen.dart';
import '../../../res/colors/app_colors.dart';
import '../../../utils/constants.dart';

class BottomNavBar extends StatefulWidget {
  static const String id = 'bottom_nav_bar';
  const BottomNavBar({super.key});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: _currentIndex == 0 ? false : true,
      child: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(40)),
            child: BottomAppBar(
              height: 75,
              padding: const EdgeInsets.all(0),
              notchMargin: 0,
              color: AppColors.brandColor,
              elevation: 10, // Adds shadow
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildBottomNavigationBarItem(
                    AppImages.hubSelectedIcon,
                    AppImages.hubSelectedIcon,
                    tr(Constants.homeTitle),
                    0,
                  ),
                  _buildBottomNavigationBarItem(
                    AppImages.settingsSelectedIcon,
                    AppImages.settingsSelectedIcon,
                    tr(Constants.settingsTitle),
                    1,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBarItem(
      icon, selectedIcon, String label, int index) {
    bool isSelected = _currentIndex == index;
    double iconSize = isSelected ? 25.0 : 23.0;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: isSelected ? 60 : 40,
            height: isSelected ? 60 : 40,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.whiteBgColor : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                isSelected ? selectedIcon : icon,
                color: Colors.black,
                width: iconSize,
                height: iconSize,
              ),
            ),
          ),
          if (!isSelected)
            Text(
              label,
              style: GoogleFonts.roboto(color: Colors.black, fontSize: 13),
            ),
        ],
      ),
    );
  }
}
