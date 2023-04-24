import 'package:abc_quran/models/glyph.dart';
import 'package:abc_quran/providers/sura/sura_list_provider.dart';
import 'package:abc_quran/ui/app/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'state/mushaf_provider.dart';

class QuranMushafPage extends ConsumerWidget {
  const QuranMushafPage({Key? key, required this.isLeft}) : super(key: key);

  final bool isLeft;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mushafState = ref.watch(mushafProvider);
    final suraList = ref.watch(suraListProvider);

    final pageGlyphs =
        isLeft ? mushafState.leftPageGlyphs : mushafState.rightPageGlyphs;

    final lineWidth = 0.23.sw;
    final lineHeight = 0.055.sh;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 7.sp),
      child: Column(
        children: [
          for (final lineGlyphs in pageGlyphs)
            SizedBox(
                height: lineHeight,
                width: lineWidth,
                child: lineGlyphs.isEmpty || lineGlyphs[0].verse == null
                    ? lineGlyphs.isEmpty
                        ? Container()
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                  height: 0.05.sh,
                                  width: lineWidth,
                                  decoration: BoxDecoration(
                                      color: AppTheme.secundaryColor
                                          .withOpacity(0.55),
                                      borderRadius: BorderRadius.circular(7.5)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        children: [
                                          for (final glyph
                                              in lineGlyphs.reversed)
                                            Text(glyph.text,
                                                style: TextStyle(
                                                    fontFamily: "BSML",
                                                    fontSize: 5.25.sp)),
                                        ],
                                      ),
                                      Text(
                                          "${suraList[lineGlyphs[0].sura - 1].phoneticName} (${lineGlyphs[0].sura})",
                                          style: TextStyle(fontSize: 3.25.sp))
                                    ],
                                  )),
                            ],
                          )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (final glyph in lineGlyphs.reversed)
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: (mushafState.hoveredVerse ==
                                                      glyph.verse &&
                                                  mushafState.hoveredPage ==
                                                      glyph.page)
                                              ? AppTheme.darkColor
                                                  .withOpacity(0.45)
                                              : Colors.transparent,
                                          width: 0.5.sp))),
                              child: MouseRegion(
                                cursor: SystemMouseCursors.grab,
                                onHover: (_) {
                                  ref
                                      .read(mushafProvider.notifier)
                                      .hover(glyph);
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
                                                fontSize: glyph.isSmall
                                                    ? 5.5.sp
                                                    : 4.5.sp))
                                        : Container(
                                            color: (mushafState.hoveredVerse ==
                                                        glyph.verse &&
                                                    mushafState.hoveredPage ==
                                                        glyph.page)
                                                ? Colors.blue.withOpacity(0.15)
                                                : Colors.transparent,
                                            child: Container(
                                              transform: [1, 2]
                                                      .contains(glyph.page)
                                                  ? Matrix4.translationValues(
                                                      -1, -7.0, 0.0)
                                                  : null,
                                              child: Text(glyph.text,
                                                  textScaleFactor: glyph.isSmall
                                                      ? 0.45.sp
                                                      : 0.38.sp,
                                                  style: TextStyle(
                                                      fontFamily: glyph.page
                                                          .toString())),
                                            ),
                                          ),
                              ),
                            )
                        ],
                      ))
        ],
      ),
    );
  }
}
