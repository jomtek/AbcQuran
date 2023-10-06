import 'package:abc_quran/localization/app_localization.dart';
import 'package:abc_quran/models/glyph.dart';
import 'package:abc_quran/providers/player/player_provider.dart';
import 'package:abc_quran/ui/app/app_theme.dart';
import 'package:abc_quran/ui/app/views/quran/read/cursor/cursor_provider.dart';
import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'number_cube.dart';

class QuranVerseBox extends ConsumerWidget {
  const QuranVerseBox(
      {required this.id, required this.text, required this.glyphs, super.key});

  final int id;
  final String text;
  final List<Glyph> glyphs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerProvider);
    final cursor = ref.watch(cursorProvider);

    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bookmark
          Container(
            color: id >= cursor.bookmarkStart && id < cursor.bookmarkStop
                ? AppTheme.darkColor
                : null,
            width: 14.sp > 60 ? 60 : 14.sp,
            height: id == cursor.bookmarkStop
                ? (12.sp > 50 ? 50 : 12.sp)
                : double.infinity,
            child: (id >= cursor.bookmarkStart && id <= cursor.bookmarkStop)
                ? Stack(
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
                  )
                : null,
          ),

          SizedBox(width: 6.sp > 20 ? 20 : 6.sp),

          // Number cube
          ContextMenuRegion(
            contextMenu: GenericContextMenu(
              buttonConfigs: [
                ContextMenuButtonConfig(
                    AppLocalization.of(context)!.translate("move_here"),
                    onPressed: () {
                  ref
                      .read(cursorProvider.notifier)
                      .moveBookmarkTo(id, glyphs[0].page, automatic: false);
                }),
                ContextMenuButtonConfig(
                    AppLocalization.of(context)!.translate("start_here"),
                    onPressed: () {
                  ref.read(cursorProvider.notifier).startBookmarkFrom(id);
                }),
              ],
            ),
            child: NumberCube(
                id: id,
                onTap: (verse) => ref
                    .read(cursorProvider.notifier)
                    .moveBookmarkTo(verse, glyphs[0].page, automatic: false)),
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
                                    fontFamily: glyph.page.toString(),
                                  )),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 2.sp),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(text,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 3.25.sp < 15 ? 15 : 3.25.sp)),
                    ),
                  ],
                ),
              )),

          // Loop mode
          Padding(
            padding: EdgeInsets.only(left: 4.sp),
            child: VerticalDivider(
                thickness: 7.sp,
                color: (player.isLooping &&
                        id >= player.loopStartVerse &&
                        id <= player.loopEndVerse)
                    ? AppTheme.goldenColor.withOpacity(0.6)
                    : Colors.transparent),
          ),
        ],
      ),
    );
  }
}
