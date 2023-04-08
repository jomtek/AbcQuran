import 'package:abc_quran/ui/views/quran/read/cursor/cursor_provider.dart';
import 'package:abc_quran/ui/views/quran/read/text/quran_verse_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'state/text_provider.dart';

class QuranTextView extends ConsumerWidget {
  QuranTextView({required this.pageController, Key? key}) : super(key: key);

  final PageController pageController;
  final scrollController = ScrollController();

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
    final state = ref.watch(textProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.sp),
      child: SelectionArea(
        child: Center(
          child: Scrollbar(
            thumbVisibility: true,
            controller: scrollController,
            child: ListView.builder(
              controller: scrollController,
              itemCount: state.loadedVerses.length,
              itemBuilder: (_, i) {
                return Padding(
                  padding: getVersePadding(i, state.loadedVerses.length),
                  child: QuranVerseBox(
                      id: i + 1,
                      text: state.loadedVerses[i],
                      glyphs: state.loadedGlyphs[i]),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
