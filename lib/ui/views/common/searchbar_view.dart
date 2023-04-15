import 'package:abc_quran/ui/app/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({super.key, required this.placeholder});

  final String placeholder;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final controller = TextEditingController();

  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        focusNode.requestFocus();
      },
      child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: 4.sp < 15 ? 15 : 4.sp, vertical: 3.sp),
          decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    offset: Offset(1.sp, 1.sp),
                    blurRadius: 8,
                    spreadRadius: 1,
                    color: Colors.black.withOpacity(0.18))
              ]),
          child: Row(
            children: [
              SvgPicture.asset(
                "assets/icons/magnify.svg",
                width: 5.5.sp,
              ),
              SizedBox(width: 3.sp),
              Expanded(
                child: SizedBox(
                  child: TextField(
                    focusNode: focusNode,
                    cursorColor: Colors.grey,
                    style: GoogleFonts.inter(
                        fontSize: 3.75.sp < 16 ? 16 : 3.75.sp,
                        color: Colors.black),
                    decoration: InputDecoration.collapsed(
                        hintText: widget.placeholder,
                        hintStyle: GoogleFonts.inter(
                            fontSize: 3.75.sp < 16 ? 16 : 3.75.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF9F9F9F))),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
