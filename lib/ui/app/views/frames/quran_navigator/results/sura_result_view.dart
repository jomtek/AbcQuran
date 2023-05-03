import 'package:abc_quran/models/sura.dart';
import 'package:abc_quran/ui/app/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SuraResultView extends StatefulWidget {
  const SuraResultView(
      {super.key,
      required this.selected,
      required this.sura,
      required this.languageId,
      required this.onTap});

  final bool selected;
  final SuraModel sura;
  final String languageId;
  final Function(SuraModel) onTap;

  @override
  State<SuraResultView> createState() => _SuraResultViewState();
}

class _SuraResultViewState extends State<SuraResultView> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap(widget.sura);
      },
      onHover: (e) {
        setState(() {
          isHovering = !isHovering;
        });
      },
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                  width: 13.sp,
                  child: Text(
                    "${widget.sura.id}.",
                    style: GoogleFonts.inter(
                        fontSize: 5.sp, fontWeight: FontWeight.w500),
                  )),
              Text(widget.sura.phoneticName,
                  style: GoogleFonts.inter(
                      fontSize: 5.sp, fontWeight: FontWeight.w600)),
              SizedBox(width: 2.sp),
              Text(widget.sura.getName(widget.languageId),
                  style: GoogleFonts.inter(
                      color: Colors.black54,
                      fontSize: 4.sp,
                      fontWeight: FontWeight.w500))
            ],
          ),
          SizedBox(height: 2.sp),
          AnimatedContainer(
              duration: const Duration(milliseconds: 75),
              height: 0.6.sp,
              width: double.infinity,
              color: (isHovering || widget.selected)
                  ? AppTheme.mediumColor
                  : Colors.black12),
        ],
      ),
    );
  }
}
