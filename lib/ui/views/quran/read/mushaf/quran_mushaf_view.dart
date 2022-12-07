import 'package:abc_quran/ui/views/quran/read/cursor/cursor_provider.dart';
import 'package:abc_quran/ui/views/quran/read/mushaf/quran_mushaf_page.dart';
import 'package:abc_quran/ui/views/quran/read/mushaf/state/mushaf_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keymap/keymap.dart';

class QuranMushafView extends ConsumerWidget {
  const QuranMushafView({required this.pageController, Key? key})
      : super(key: key);

  final PageController pageController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cursorState = ref.watch(cursorProvider);
    const radius = 10.0;

    return KeyboardWidget(
      /*onKey: (_, e) {
        if (e.repeat) {
          return KeyEventResult.ignored;
        }
        else if (e.data.physicalKey == PhysicalKeyboardKey.arrowLeft) {
          ref.read(cursorProvider.notifier).gotoNextPageCouple();
          ref.read(mushafProvider.notifier).reloadPageCouple();
        }
        else if (e.data.physicalKey == PhysicalKeyboardKey.arrowRight) {
          ref.read(cursorProvider.notifier).gotoPreviousPageCouple();
          ref.read(mushafProvider.notifier).reloadPageCouple();
        }

        return KeyEventResult.handled;
      },*/
      bindings: [
        KeyAction(LogicalKeyboardKey.arrowLeft, "Goto next page", () {
          ref.read(cursorProvider.notifier).gotoNextPageCouple();
          ref.read(mushafProvider.notifier).reloadPageCouple();
        }),
        KeyAction(LogicalKeyboardKey.arrowRight, "Goto previous page", () {
          ref.read(cursorProvider.notifier).gotoPreviousPageCouple();
          ref.read(mushafProvider.notifier).reloadPageCouple();
        }),
      ],
      child: Container(
        width: 0.6.sw,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Page on the left
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 5.sp,
                    bottom: 1.5.sp,
                  ),
                  child: Text("Page ${cursorState.page + 1}"),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.45),
                          spreadRadius: 12,
                          blurRadius: 20,
                          offset: const Offset(-5, 5),
                        ),
                      ],
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(radius),
                          bottomLeft: Radius.circular(radius))),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 17.5),
                    child: QuranMushafPage(isLeft: true),
                  ),
                ),
              ],
            ),

            // Page on the right
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    right: 5.sp,
                    bottom: 1.5.sp,
                  ),
                  child: Text("Page ${cursorState.page}"),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 15,
                          offset: const Offset(-10, 3),
                        ),
                        BoxShadow(
                          offset: const Offset(5, 5),
                          color: Colors.grey.withOpacity(0.45),
                          spreadRadius: 12,
                          blurRadius: 20,
                        )
                      ],
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(radius),
                          bottomRight: Radius.circular(radius))),
                  child: const Padding(
                    padding: EdgeInsets.only(right: 17.5),
                    child: QuranMushafPage(isLeft: false),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
