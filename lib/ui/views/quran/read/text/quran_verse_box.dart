import 'package:abc_quran/models/glyph.dart';
import 'package:abc_quran/ui/app/app_theme.dart';
import 'package:abc_quran/ui/views/quran/read/cursor/cursor_provider.dart';
import 'package:abc_quran/ui/views/quran/read/cursor/cursor_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:native_context_menu/native_context_menu.dart';

import 'number_cube.dart';

class QuranVerseBox extends ConsumerWidget {
  const QuranVerseBox(
      {required this.id,
      required this.text,
      required this.glyphs,
      required this.cursor,
      super.key});

  final int id;
  final String text;
  final List<Glyph> glyphs;
  final CursorState cursor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bookmark
          SizedBox(
            width: 14.sp > 60 ? 60 : 14.sp,
            height: id == cursor.bookmarkStop
                ? (12.sp > 50 ? 50 : 12.sp) + (id == 1 ? 0 : 1)
                : double.infinity,
            child: (id >= cursor.bookmarkStart && id <= cursor.bookmarkStop)
                ? Transform.translate(
                    // Reduce anti-aliasing visual bugs
                    // As a thin white line annoyingly appears
                    offset: Offset(0, id == 1 ? 0 : -1),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                              margin: id == cursor.bookmarkStop
                                  ? EdgeInsets.only(bottom: 3.sp)
                                  : EdgeInsets.zero,
                              decoration: BoxDecoration(
                                  color: AppTheme.lightColor,
                                  border: Border(
                                      left: BorderSide(
                                          color: AppTheme.darkColor, width: 6),
                                      right: BorderSide(
                                          color: AppTheme.darkColor, width: 6),
                                      top: id == cursor.bookmarkStart
                                          ? (BorderSide(
                                              color: AppTheme.darkColor,
                                              width: 6))
                                          : BorderSide.none))),
                        ),
                        if (id == cursor.bookmarkStop)
                          SvgPicture.asset(
                            "assets/icons/bookmark_end.svg",
                            width: 14.sp > 60 ? 60 : 14.sp,
                          ),
                      ],
                    ),
                  )
                : null,
          ),

          SizedBox(width: 4.sp),

          // Number cube
          ContextMenuRegion(
            onItemSelected: (item) {
              item.onSelected!();
            },
            menuItems: [
              MenuItem(
                  title: "Move here",
                  onSelected: () {
                    ref.read(cursorProvider.notifier).moveBookmarkAt(id);
                  }),
              MenuItem(
                  title: "Start here",
                  onSelected: () {
                    ref.read(cursorProvider.notifier).startBookmarkAt(id);
                  }),
            ],
            child: NumberCube(
                id: id,
                onTap: ref.read(cursorProvider.notifier).moveBookmarkAt),
          ),

          SizedBox(width: 2.sp),

          // Verse box
          Container(
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(6)),
              padding: const EdgeInsets.all(14),
              margin: EdgeInsets.symmetric(vertical: 0.55.sp),
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
                                      (glyph.isSmall ? 0.35.sp : 0.385.sp) < 1.3
                                          ? 1.3
                                          : (glyph.isSmall ? 0.4.sp : 0.38.sp),
                                  style: TextStyle(
                                      fontFamily: glyph.page.toString(),)),
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

          SizedBox(width: 4.sp),
        ],
      ),
    );
  }
}
