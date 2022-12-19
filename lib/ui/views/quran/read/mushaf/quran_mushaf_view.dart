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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Page on the left
          Row(
            children: [
              Text("Page ${(cursorState.page + 1).toString().padLeft(3, '0')}"),
              SizedBox(
                width: 4.sp,
              ),
              Container(
                height: 0.875.sh,
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
                child: const QuranMushafPage(isLeft: true),
              ),
            ],
          ),

          // Page on the right
          Row(
            children: [
              Container(
                height: 0.875.sh,
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
                child: const QuranMushafPage(isLeft: false),
              ),
              SizedBox(
                width: 4.sp,
              ),
              Text("Page ${(cursorState.page).toString().padLeft(3, '0')}"),
            ],
          )
        ],
      ),
    );
  }
}
