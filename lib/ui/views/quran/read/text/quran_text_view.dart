import 'package:abc_quran/ui/views/quran/read/cursor/cursor_provider.dart';
import 'package:abc_quran/ui/views/quran/read/text/quran_verse_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'state/text_provider.dart';

class QuranTextView extends ConsumerWidget {
  const QuranTextView({required this.pageController, Key? key}) : super(key: key);

  final PageController pageController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cursorState = ref.watch(cursorProvider);
    final state = ref.watch(textProvider);

    return Column(children: [
      for (final verse in state.loadedVerses)
        QuranVerseBox(text: verse)
    ],);
  }
}