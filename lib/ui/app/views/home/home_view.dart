import 'dart:ui';

import 'package:abc_quran/providers/ctrl_key_provider.dart';
import 'package:abc_quran/ui/app/views/frames/quran_navigator/state/quran_navigator_vm.dart';
import 'package:abc_quran/ui/components/sidebar/abc_sidebar.dart';
import 'package:abc_quran/ui/components/sidebar/sidebar_item.dart';
import 'package:abc_quran/ui/app/views/frames/quran_navigator/quran_navigator_frame.dart';
import 'package:abc_quran/ui/app/views/home/state/home_vm.dart';
import 'package:abc_quran/ui/app/views/quran/read/read_view.dart';
import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeView extends ConsumerWidget {
  HomeView({Key? key}) : super(key: key);

  final _pageController = PageController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeProvider);

    return ContextMenuOverlay(
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: (e) {
          if (e is RawKeyDownEvent &&
              !e.repeat &&
              e.isControlPressed &&
              ["F", "K"].contains(e.logicalKey.keyLabel)) {
            ref.read(quranNavigatorProvider.notifier).reinitializeResults();
            ref.read(homeProvider.notifier).setFrame(const QuranNavigatorFrame());
            ref.read(homeProvider.notifier).toggleFrame();
          }
    
          ref.read(ctrlKeyProvider.notifier).setCtrlKey(e.isControlPressed);
        },
        child: Stack(children: [
          GestureDetector(
            onTap: () {
              if (state.isFrameShown) {
                ref.read(homeProvider.notifier).toggleFrame();
              }
            },
            child: AbsorbPointer(
              absorbing: state.isFrameShown,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(
                    sigmaX: state.isFrameShown ? 1.5 : 0,
                    sigmaY: state.isFrameShown ? 1.5 : 0),
                child: Scaffold(
                  body: Stack(children: [
                    Padding(
                      padding: EdgeInsets.only(left: 12.5.sp < 55 ? 55 : 12.5.sp),
                      child: PageView(
                        controller: _pageController,
                        children: const [
                          ReadView(),
                          Center(
                            child: Text('Paramètres'),
                          ),
                        ],
                      ),
                    ),
                    AbcSidebar(
                      [
                        SidebarItem(0, "Lire et écouter", Icons.menu_book, true),
                        SidebarItem(1, "Paramètres", Icons.settings, false)
                      ],
                      onTap: (id) {
                        _pageController.jumpToPage(id);
                      },
                    )
                  ]),
                ),
              ),
            ),
          ),
          if (state.isFrameShown) Center(child: state.frame)
        ]),
      ),
    );
  }
}
