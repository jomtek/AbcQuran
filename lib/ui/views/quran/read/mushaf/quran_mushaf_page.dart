import 'package:abc_quran/models/glyph.dart';
import 'package:abc_quran/providers/sura_info_provider.dart';
import 'package:abc_quran/ui/app/app_theme.dart';
import 'package:abc_quran/ui/views/quran/read/cursor/cursor_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'state/mushaf_provider.dart';

class QuranMushafPage extends ConsumerWidget {
  const QuranMushafPage({Key? key, required this.isLeft}) : super(key: key);

  final bool isLeft;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cursorState = ref.watch(cursorProvider);
    final mushafState = ref.watch(mushafProvider);
    final suraList = ref.watch(suraListProvider);

    final pageGlyphs =
        isLeft ? mushafState.leftPageGlyphs : mushafState.rightPageGlyphs;

    final lineWidth = 0.23.sw;
    final lineHeight = 0.055.sh;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.sp, horizontal: 7.sp),
      child: Column(
        children: [
          for (final lineGlyphs in pageGlyphs)
            lineGlyphs[0].verse == null
                ? SizedBox(
                  height: lineHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                          height: 0.05.sh,
                          width: lineWidth,
                          decoration: BoxDecoration(
                              color: AppTheme.secundaryColor.withOpacity(0.55),
                              borderRadius: BorderRadius.circular(7.5)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(children: [
                                for (final glyph in lineGlyphs.reversed)
                                  Text(glyph.text,
                                      style: TextStyle(
                                          fontFamily: "BSML", fontSize: 5.25.sp)),
                              ],),
                              Text("${suraList[lineGlyphs[0].sura - 1].phoneticName} (${lineGlyphs[0].sura})", style: TextStyle(fontSize: 3.25.sp))
                            ],
                          )),
                    ],
                  ),
                )
                : SizedBox(
                    height: lineHeight,
                    width: lineWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (final glyph in lineGlyphs.reversed)
                          MouseRegion(
                            cursor: SystemMouseCursors.grab,
                            onHover: (_) {
                              ref.read(mushafProvider.notifier).hover(glyph);
                            },
                            onExit: (_) {
                              ref
                                  .read(mushafProvider.notifier)
                                  .hover(Glyph("", -1, -1, -1));
                            },
                            child: glyph.verse == null
                                ? Padding(
                                    padding: EdgeInsets.only(top: 0.75.sp),
                                    child: Text(glyph.text,
                                        style: TextStyle(
                                            fontFamily: "BSML",
                                            fontSize: 6.sp)),
                                  )
                                : glyph.verse == 0
                                    ? Text(glyph.text,
                                        style: TextStyle(
                                            fontFamily: "BSML",
                                            fontSize: 4.5.sp))
                                    : Container(
                                        color: (mushafState.hoveredVerse ==
                                                    glyph.verse &&
                                                mushafState.hoveredPage ==
                                                    glyph.page)
                                            ? Colors.black26
                                            : Colors.transparent,
                                        child: Text(glyph.text,
                                            textScaleFactor: 0.38.sp,
                                            style: TextStyle(
                                                fontFamily:
                                                    glyph.page.toString())),
                                      ),
                          )
                      ],
                    ),
                  )
        ],
      ),
    );
  }
}
