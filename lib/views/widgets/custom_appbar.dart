/**
 * @author Akshit Jha
 * Creation Date: 12-12-2024
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../res/colors/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? circleText; // Nullable parameter for the circle container
  final bool showIcon; // Boolean to control the icon display

  const CustomAppBar({
    super.key,
    required this.title,
    this.circleText,
    this.showIcon = false, // Default is false for no menu icon
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        tr(title),
        style: GoogleFonts.roboto(
          color: AppColors.whiteBgColor,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      iconTheme: const IconThemeData(color: AppColors.whiteBgColor),
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: const BoxDecoration(color: AppColors.brandColor),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: circleText != null
              ? Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Text(
                      circleText!,
                      style: GoogleFonts.roboto(
                        color: AppColors.brandColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                )
              : (showIcon
                  ? IconButton(
                      icon: const Icon(
                        CupertinoIcons.globe,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        // Add desired menu functionality here
                        Scaffold.of(context).openDrawer();
                      },
                    )
                  : SizedBox(width: 35)), // Placeholder space
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
