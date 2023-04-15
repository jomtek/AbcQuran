import 'package:abc_quran/providers/sura_info_provider.dart';
import 'package:abc_quran/ui/app/app_theme.dart';
import 'package:abc_quran/ui/views/common/searchbar_view.dart';
import 'package:abc_quran/ui/views/frames/navigator/results/sura_result_view.dart';
import 'package:abc_quran/ui/views/home/state/home_vm.dart';
import 'package:abc_quran/ui/views/quran/read/cursor/cursor_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'state/navigator_vm.dart';

class NavigatorFrame extends ConsumerWidget {
  const NavigatorFrame({super.key});

  Widget buildSuraList(WidgetRef ref) {
    final state = ref.watch(navigatorProvider);

    final selectedSura = ref.read(cursorProvider).sura;

    return Padding(
      padding: EdgeInsets.only(right: 2.sp),
      child: Scrollbar(
        controller: state.scrollController,
        thumbVisibility: true,
        child: ListView.builder(
          key: const PageStorageKey(0), // Keeps scroll position
          shrinkWrap: true,
          controller: state.scrollController,
          itemCount: state.relevantElements.length,
          itemBuilder: (context, index) {
            final sura = state.relevantElements[index];
            return SuraResultView(
                sura: sura,
                selected: sura == selectedSura,
                onTap: (s) {
                  ref.read(cursorProvider.notifier).selectSura(s);
                  ref.read(homeProvider.notifier).toggleFrame();
                });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      child: Container(
          width: 170.sp,
          height: 110.sp,
          decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    offset: Offset(-1, 1.sp),
                    blurRadius: 20,
                    spreadRadius: 5,
                    color: Colors.black38)
              ]),
          child: Column(
            children: [
              SizedBox(height: 4.sp),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.sp),
                child: SearchBar(
                  placeholder: "Mot, sourate, récitateur...",
                  textChanged: (text) {
                    ref.read(navigatorProvider.notifier).search(text);
                  },
                ),
              ),
              SizedBox(height: 6.sp),
              Expanded(child: buildSuraList(ref))
            ],
          )),
    );
  }
}
