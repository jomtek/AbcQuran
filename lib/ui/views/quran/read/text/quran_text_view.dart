import 'package:abc_quran/providers/ctrl_key_provider.dart';
import 'package:abc_quran/ui/views/quran/read/cursor/cursor_provider.dart';
import 'package:abc_quran/ui/views/quran/read/text/quran_verse_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'state/text_provider.dart';

class QuranTextView extends ConsumerWidget {
  const QuranTextView({Key? key}) : super(key: key);

  EdgeInsets getVersePadding(int i, int total) {
    double horizontal = 6.sp;

    if (i == 0) {
      return EdgeInsets.only(left: horizontal, top: 12.sp, right: horizontal);
    } else if (i == total - 1) {
      return EdgeInsets.only(
          left: horizontal, right: horizontal, bottom: 12.sp);
    } else {
      return EdgeInsets.symmetric(horizontal: horizontal);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cursorState = ref.watch(cursorProvider);
    final ctrlKeyEnabled = ref.watch(ctrlKeyProvider);
    final state = ref.watch(textProvider);

    return InteractiveViewer(
      scaleEnabled: ctrlKeyEnabled,
      minScale: 1,
      maxScale: 1.3,
      panEnabled: false,
      scaleFactor: 800,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.sp),
        child: SelectionArea(
          child: Center(
            child: Scrollbar(
              thumbVisibility: true,
              controller: state.scrollController,
              child: ListView.builder(
                key: const PageStorageKey(0), // Keeps scroll position
                physics: ctrlKeyEnabled ? const NeverScrollableScrollPhysics() : null,
                controller: state.scrollController,
                itemCount: state.loadedVerses.length,
                itemBuilder: (_, i) {
                  return Padding(
                    padding: getVersePadding(i, state.loadedVerses.length),
                    child: QuranVerseBox(
                      id: i + 1,
                      text: state.loadedVerses[i],
                      glyphs: state.loadedGlyphs[i],
                      cursor: cursorState,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
