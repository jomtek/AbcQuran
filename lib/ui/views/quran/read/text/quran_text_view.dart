import 'dart:math';

import 'package:abc_quran/providers/ctrl_key_provider.dart';
import 'package:abc_quran/ui/views/quran/read/cursor/cursor_provider.dart';
import 'package:abc_quran/ui/views/quran/read/text/quran_verse_box.dart';
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
    final state = ref.watch(textProvider);

    return InteractiveViewer(
      scaleEnabled: ctrlKeyEnabled,
      minScale: 0.8,
      maxScale: 1.6,
      scaleFactor: 800,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.sp),
        child: SelectionArea(
          child: Center(
            child: ScrollablePositionedList.builder(
              initialScrollIndex:
                  max(cursorState.bookmarkStop - 2, 0), // Center the verse
              physics:
                  ctrlKeyEnabled ? const NeverScrollableScrollPhysics() : null,
              itemCount: state.loadedVerses.length,
              itemBuilder: (_, i) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.sp),
                  child: Column(
                    children: [
                      if (i == 0) SizedBox(height: 12.sp),
                      QuranVerseBox(
                        id: i + 1,
                        text: state.loadedVerses[i],
                        glyphs: state.loadedGlyphs[i],
                        cursor: cursorState,
                      ),
                      if (i == state.loadedVerses.length - 1)
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
