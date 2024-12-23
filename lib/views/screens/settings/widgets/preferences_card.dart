/**
 * @author Akshit Jha
 * Creation Date: 11-12-2024
 */

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../res/colors/app_colors.dart';

/// preferences card in Profile Screen
class PreferencesCard extends StatelessWidget {
  final String title;
  final String value;
  const PreferencesCard({
    required this.title,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: AppColors.brandColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.roboto(
              color: AppColors.tertiaryTextIconColor,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Text(
                value,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  color: AppColors.secondaryTextIconColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.secondaryTextIconColor,
                size: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
