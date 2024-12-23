/**
 * @author Akshit Jha
 * Creation Date: 11-12-2024
 */
library;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transform_docs/views/widgets/custom_button.dart';
import '../../../../res/colors/app_colors.dart';
import '../../../../utils/constants.dart';

/// for lang and notification bottom sheet in profile screen
class CustomProfileBottomSheet extends StatefulWidget {
  final Size size;
  final String title;
  final List<String> items;
  final bool? isNotification;
  final Function(String) onItemSelected;
  final String selectedItem;

  const CustomProfileBottomSheet({
    super.key,
    required this.size,
    required this.title,
    required this.items,
    this.isNotification,
    required this.onItemSelected,
    required this.selectedItem,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomProfileBottomSheetState createState() =>
      _CustomProfileBottomSheetState();
}

class _CustomProfileBottomSheetState extends State<CustomProfileBottomSheet> {
  String? selectedItem;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.selectedItem;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.whiteBgColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      height: widget.size.height * 0.5,
      width: widget.size.width,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          SizedBox(height: 20),
          Text(
            widget.title,
            style: GoogleFonts.roboto(
              color: AppColors.tertiaryTextIconColor,
              fontSize: 24,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                bool isSelected = widget.items[index] == selectedItem;
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 0),
                  decoration: ShapeDecoration(
                    color: isSelected
                        ? AppColors.brandColor
                        : AppColors.whiteBgColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      widget.items[index],
                      style: GoogleFonts.roboto(
                        color: isSelected
                            ? AppColors.whiteBgColor
                            : AppColors.secondaryTextIconColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    trailing: Radio<String>(
                      value: widget.items[index],
                      groupValue: selectedItem,
                      activeColor: isSelected
                          ? AppColors.whiteBgColor
                          : AppColors.brandColor,
                      onChanged: (value) {
                        setState(() {
                          selectedItem = value!;
                        });
                        widget.onItemSelected(value!);
                        Navigator.pop(context);
                      },
                    ),
                    onTap: () {
                      setState(() {
                        selectedItem = widget.items[index];
                      });
                      widget.onItemSelected(widget.items[index]);
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 10),
          CustomButton(
            text: tr(Constants.cancelTitle),
            onPressed: () {
              Navigator.pop(context);
            },
            color: AppColors.chatInputColor,
            textColor: AppColors.tertiaryTextIconColor,
            isBordered: true,
            borderRedius: 5,
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
