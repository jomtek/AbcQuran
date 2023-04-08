import 'package:abc_quran/models/glyph.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class QuranVerseBox extends ConsumerWidget {
  const QuranVerseBox(
      {required this.id, required this.text, required this.glyphs, super.key});

  final int id;
  final String text;
  final List<Glyph> glyphs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.075),
                borderRadius: BorderRadius.circular(12)),
            width: 12.sp > 50 ? 50 : 12.sp,
            height: 12.sp > 50 ? 50 : 12.sp,
            child: Center(
                child: Text(id.toString(),
                    style: GoogleFonts.inter(
                        fontSize: 4.sp > 17 ? 17 : 4.sp, fontWeight: FontWeight.w500)))),
        SizedBox(width: 2.sp),
        Container(
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(6)),
            padding: const EdgeInsets.all(14),
            child: SizedBox(
              width: 0.45.sw < 700 ? 700 : 0.45.sw,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: SelectionArea(
                      // TODO : fix the arabic selection
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        runAlignment: WrapAlignment.start,
                        textDirection: TextDirection.rtl,
                        children: [
                          for (final glyph in glyphs)
                            Text(glyph.text,
                                textScaleFactor:
                                    (glyph.isSmall ? 0.35.sp : 0.3.sp) < 1.3
                                        ? 1.3
                                        : (glyph.isSmall ? 0.35.sp : 0.3.sp),
                                style: TextStyle(
                                    fontFamily: glyph.page.toString(),
                                    fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 2.sp),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(text,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.inter(
                            fontSize: 3.25.sp < 15 ? 15 : 3.25.sp)),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
