/**
 * @author Akshit Jha
 * Creation Date: 11-12-2024
 */

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../res/colors/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icons;
  final Color? color;
  final Color? textColor;
  final bool? isBordered;
  final double? borderRedius;
  final double? width;
  final double? height;
  final Color? borderColor;
  final double? textFontSize;
  final FontWeight? textFontWeight;
  final double? padding;
  final double? paddingHorizontal;

  const CustomButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.color,
      this.textColor,
      this.icons,
      this.isBordered,
      this.borderRedius,
      this.width,
      this.height,
      this.borderColor,
      this.textFontSize,
      this.textFontWeight,
      this.padding,
      this.paddingHorizontal});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: height ?? 55,
        width: width ?? null,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: color ?? AppColors.brandColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRedius ?? 10),
            side: (isBordered ?? false)
                ? BorderSide(
                    width: 1,
                    color: borderColor ?? AppColors.defaultBorderColor)
                : BorderSide.none,
          ),
          shadows: [
            BoxShadow(
              color: AppColors.brandColor.withOpacity(0.5),
              blurRadius: 57.62,
              offset: Offset(0, 34.57),
              spreadRadius: 0,
            ),
          ],
        ),
        padding: EdgeInsets.all(padding ?? 5)
            .copyWith(left: paddingHorizontal, right: paddingHorizontal),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.roboto(
                color: textColor ?? Colors.white,
                fontSize: textFontSize ?? 16,
                fontWeight: textFontWeight ?? FontWeight.w500,
              ),
            ),
            icons == null ? const SizedBox() : SizedBox(width: 5),
            icons != null ? Icon(icons, color: Colors.white) : const SizedBox()
          ],
        ),
      ),
    );
  }
}
