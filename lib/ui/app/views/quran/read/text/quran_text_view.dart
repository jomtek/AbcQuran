import 'dart:math';

import 'package:abc_quran/models/sura.dart';
import 'package:abc_quran/providers/ctrl_key_provider.dart';
import 'package:abc_quran/providers/sura/current_sura_provider.dart';
import 'package:abc_quran/ui/app/views/quran/read/cursor/cursor_provider.dart';
import 'package:abc_quran/ui/app/views/quran/read/text/quran_verse_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'state/text_provider.dart';

class QuranTextView extends ConsumerWidget {
  const QuranTextView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cursorState = ref.watch(cursorProvider);
    final ctrlKeyEnabled = ref.watch(ctrlKeyProvider);
    final sura = ref.watch(currentSuraProvider);
    final state = ref.watch(textProvider);

    return InteractiveViewer(
      scaleEnabled: ctrlKeyEnabled,
      minScale: 0.8,
      maxScale: 1.6,
      scaleFactor: 800,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.sp),
        child: Center(
          child: SelectionArea(
            // TODO: fix selection area
            child: ScrollablePositionedList.builder(
              initialScrollIndex:
                  max(cursorState.bookmarkStop - 2, 0), // Center the verse
              itemScrollController: state.scrollController,
              physics:
                  ctrlKeyEnabled ? const NeverScrollableScrollPhysics() : null,
              itemCount: sura.hasBasmala() && state.loadedVerses.isNotEmpty
                  ? state.loadedVerses.length + 1
                  : state.loadedVerses.length,
              itemBuilder: (_, i) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.sp),
                  child: Column(
                    children: [
                      if (i == 0) SizedBox(height: 12.sp),
                      (sura.hasBasmala() && i == 0)
                          ? QuranVerseBox(
                              id: 0,
                              text: state.basmalaText,
                              glyphs: state.basmalaGlyphs,
                              cursor: cursorState)
                          : QuranVerseBox(
                              id: i + sura.getFirstVerseId(),
                              text: state
                                  .loadedVerses[sura.hasBasmala() ? i - 1 : i],
                              glyphs: state
                                  .loadedGlyphs[sura.hasBasmala() ? i - 1 : i],
                              cursor: cursorState,
                            ),
                      if (i ==
                          (sura.hasBasmala()
                              ? state.loadedVerses.length
                              : state.loadedVerses.length - 1))
                        SizedBox(height: 12.sp),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
