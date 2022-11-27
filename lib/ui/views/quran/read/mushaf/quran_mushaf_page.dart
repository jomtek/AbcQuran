import 'package:abc_quran/ui/views/quran/read/cursor/cursor_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'state/mushaf_provider.dart';

class QuranMushafPage extends ConsumerWidget {
  const QuranMushafPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cursorState = ref.watch(cursorProvider);
    final mushafState = ref.watch(mushafProvider);

    return SizedBox(
      width: 500,
      child: ListView.builder(
        itemCount: mushafState.pageGlyphs.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          final lineGlyphs = mushafState.pageGlyphs[index];
          return Container(
            color: Colors.white,
            padding: const EdgeInsets.only(right: 92.5),
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              reverse: true,
              itemCount: lineGlyphs.length,
              itemBuilder: (BuildContext context, int index) {
                final glyph = lineGlyphs[index];
                return Text(glyph.text,
                textScaleFactor: 1.5,
                    style: TextStyle(fontFamily: glyph.page.toString()));
              },
            ),
          );
        },
      ),
    );
  }
}
