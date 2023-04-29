import 'package:abc_quran/models/glyph.dart';
import 'package:abc_quran/models/sura.dart';
import 'package:abc_quran/providers/player/player_provider.dart';
import 'package:abc_quran/providers/sura/current_sura_provider.dart';
import 'package:abc_quran/providers/sura/sura_list_provider.dart';
import 'package:abc_quran/ui/app/app_theme.dart';
import 'package:abc_quran/ui/app/views/quran/read/cursor/cursor_provider.dart';
import 'package:abc_quran/ui/app/views/quran/read/cursor/cursor_state.dart';
import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../providers/player/player_state2.dart';
import 'state/mushaf_provider.dart';
import 'state/mushaf_state.dart';

class QuranMushafPage extends ConsumerWidget {
  const QuranMushafPage({Key? key, required this.isLeft}) : super(key: key);

  final bool isLeft;

  bool isBookmarked(Glyph glyph, CursorState cursor, SuraModel currentSura) {
    return glyph.sura == currentSura.id &&
        cursor.bookmarkStart <= glyph.verse! &&
        cursor.bookmarkStop >= glyph.verse!;
  }

  bool isBeingRead(Glyph glyph, CursorState cursor) {
    return glyph.verse! == cursor.bookmarkStop;
  }

  bool isLooped(Glyph glyph, PlayerState2 player, SuraModel currentSura) {
    return player.isLooping &&
        glyph.sura == currentSura.id &&
        glyph.verse! >= player.loopStartVerse &&
        glyph.verse! <= player.loopEndVerse;
  }

  Color getBorderColorForGlyph(
      Glyph glyph,
      CursorState cursor,
      MushafState mushafState,
      PlayerState2 playerState,
      SuraModel currentSura) {
    if (isBookmarked(glyph, cursor, currentSura)) {
      if (isBeingRead(glyph, cursor)) {
        return AppTheme.goldenColor.withOpacity(0.85);
      } else {
        return AppTheme.mediumColor.withOpacity(0.25);
      }
    } else {
      return (mushafState.hoveredVerse == glyph.verse &&
              mushafState.hoveredSura == glyph.sura)
          ? Colors.blue.withOpacity(0.2)
          : (isLooped(glyph, playerState, currentSura)
              ? AppTheme.goldenColor.withOpacity(0.1)
              : Colors.transparent);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cursorState = ref.watch(cursorProvider);
    final mushafState = ref.watch(mushafProvider);
    final playerState = ref.watch(playerProvider);
    final suraList = ref.watch(suraListProvider);
    final currentSura = ref.watch(currentSuraProvider);

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
                            GestureDetector(
                              onTap: () {
                                ref.read(mushafProvider.notifier).moveTo(glyph);
                              },
                              child: ContextMenuRegion(
                                contextMenu: GenericContextMenu(
                                  buttonConfigs: [
                                    ContextMenuButtonConfig("Move here",
                                        onPressed: () {
                                      ref
                                          .read(mushafProvider.notifier)
                                          .moveTo(glyph);
                                    }),
                                    ContextMenuButtonConfig("Start here",
                                        onPressed: () {
                                      ref
                                          .read(mushafProvider.notifier)
                                          .startFrom(glyph);
                                    })
                                  ],
                                ),
                                child: MouseRegion(
                                  // TODO: Fix cursor is not changing
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
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: getBorderColorForGlyph(
                                                    glyph,
                                                    cursorState,
                                                    mushafState,
                                                    playerState,
                                                    currentSura),
                                                width: 0.5.sp))),
                                    child: glyph.verse == null
                                        ? Padding(
                                            padding:
                                                EdgeInsets.only(top: 0.75.sp),
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
                                                color: (mushafState
                                                                .hoveredVerse ==
                                                            glyph.verse &&
                                                        mushafState
                                                                .hoveredSura ==
                                                            glyph.sura)
                                                    ? Colors.blue
                                                        .withOpacity(0.2)
                                                    : (isLooped(
                                                            glyph,
                                                            playerState,
                                                            currentSura)
                                                        ? AppTheme.goldenColor
                                                            .withOpacity(0.1)
                                                        : Colors.transparent),
                                                child: Container(
                                                  transform: [1, 2]
                                                          .contains(glyph.page)
                                                      ? Matrix4
                                                          .translationValues(
                                                              -1, -7.0, 0.0)
                                                      : null,
                                                  child: Text(glyph.text,
                                                      textScaleFactor:
                                                          glyph.isSmall
                                                              ? 0.45.sp
                                                              : 0.38.sp,
                                                      style: TextStyle(
                                                        fontFamily: glyph.page
                                                            .toString(),
                                                      )),
                                                ),
                                              ),
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
