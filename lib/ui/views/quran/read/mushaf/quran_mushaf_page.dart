import 'package:abc_quran/ui/views/quran/read/cursor/cursor_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'state/mushaf_provider.dart';

class QuranMushafPage extends ConsumerWidget {
  const QuranMushafPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cursorState = ref.watch(cursorProvider);
    final mushafState = ref.watch(mushafProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12.5),
      child: Column(
        children: [
          for (final lineGlyphs in mushafState.pageGlyphs)
            SizedBox(
              height: 0.055.sh,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final glyph in lineGlyphs.reversed)
                    InkWell(
                      onTap: () {},
                      onHover: (_) {
                        ref.read(mushafProvider.notifier).hover(glyph);
                      },
                      child: Container(
                        color: (mushafState.hoveredVerse == glyph.verse &&
                                mushafState.hoveredSura == glyph.sura)
                            ? Colors.black26
                            : Colors.transparent,
                        child: Text(glyph.text,
                            textScaleFactor: 0.38.sp,
                            style:
                                TextStyle(fontFamily: glyph.page.toString())),
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
