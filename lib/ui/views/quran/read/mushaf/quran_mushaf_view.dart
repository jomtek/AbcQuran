import 'package:abc_quran/ui/views/quran/read/cursor/cursor_provider.dart';
import 'package:abc_quran/ui/views/quran/read/mushaf/quran_mushaf_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuranMushafView extends ConsumerWidget {
  const QuranMushafView({required this.pageController, Key? key})
      : super(key: key);

  final PageController pageController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cursorProvider);
    return Container(
        color: Colors.grey,
        child: Center(
            child: Column(
          children: [
            Text(state.sura.translatedName),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Page on the left
                Container(
                  color: Colors.white,
                  child: const Padding(
                    padding: EdgeInsets.only(left: 17.5),
                    child: QuranMushafPage(),
                  ),
                ),

                // Page on the right
                Container(
                  color: Colors.white,
                  child: const Padding(
                    padding: EdgeInsets.only(right: 17.5),
                    child: QuranMushafPage(),
                  ),
                )
              ],
            )
          ],
        )));
  }
}
