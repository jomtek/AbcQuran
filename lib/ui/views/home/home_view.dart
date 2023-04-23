import 'dart:ui';

import 'package:abc_quran/ui/components/sidebar/abc_sidebar.dart';
import 'package:abc_quran/ui/components/sidebar/sidebar_item.dart';
import 'package:abc_quran/ui/views/frames/quran_navigator/quran_navigator_frame.dart';
import 'package:abc_quran/ui/views/home/state/home_vm.dart';
import 'package:abc_quran/ui/views/quran/sura_menu/sura_menu_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeView extends ConsumerWidget {
  HomeView({Key? key}) : super(key: key);

  final _pageController = PageController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeProvider);

    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (e) {
        if (!e.repeat &&
            e.isControlPressed &&
            ["F", "K"].contains(e.logicalKey.keyLabel)) {
          ref.read(homeProvider.notifier).setFrame(const QuranNavigatorFrame());
          ref.read(homeProvider.notifier).toggleFrame();
        }
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
                        SuraMenuView(),
                        Center(
                          child: Text('Contribution'),
                        ),
                        Center(
                          child: Text('Paramètres'),
                        ),
                      ],
                    ),
                  ),
                  AbcSidebar(
                    [
                      SidebarItem(0, "Lire et écouter", Icons.menu_book, true),
                      SidebarItem(1, "Contribution", Icons.handshake, false),
                      SidebarItem(2, "Paramètres", Icons.settings, false)
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
        if (state.isFrameShown)
          Center(child: state.frame)
      ]),
    );
  }
}
