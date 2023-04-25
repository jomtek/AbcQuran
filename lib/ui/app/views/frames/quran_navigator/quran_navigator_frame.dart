import 'package:abc_quran/providers/sura/current_sura_provider.dart';
import 'package:abc_quran/providers/sura/hizb/hizb_list_provider.dart';
import 'package:abc_quran/providers/sura/hizb/hizb_state.dart';
import 'package:abc_quran/ui/app/app_theme.dart';
import 'package:abc_quran/ui/app/views/common/searchbar_view.dart';
import 'package:abc_quran/ui/app/views/frames/quran_navigator/hizb_block_view.dart';
import 'package:abc_quran/ui/app/views/frames/quran_navigator/results/sura_result_view.dart';
import 'package:abc_quran/ui/app/views/home/state/home_vm.dart';
import 'package:abc_quran/ui/app/views/quran/read/cursor/cursor_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'state/quran_navigator_state.dart';
import 'state/quran_navigator_vm.dart';

class QuranNavigatorFrame extends ConsumerWidget {
  const QuranNavigatorFrame({super.key});

  Widget _buildSuraList(WidgetRef ref, QuranNavigatorState state) {
    final selectedSura = ref.watch(currentSuraProvider);

    return Padding(
      padding: EdgeInsets.only(right: 8.sp),
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
            return SizedBox(
              height: 13.sp,
              child: SuraResultView(
                  sura: sura,
                  selected: sura == selectedSura,
                  onTap: (s) {
                    ref.read(currentSuraProvider.notifier).setSura(s);
                    ref.read(homeProvider.notifier).toggleFrame(); // Hide frame
                  }),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHizbList(HizbState state, WidgetRef ref) {
    return Flexible(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 11.sp,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: state.locations.length,
            itemBuilder: (BuildContext context, int index) {
              final hizb = state.locations[index];
              final height = state.heights[index];

              final hizbNum = index + 1;
              final juz = (hizbNum / 2).ceil();

              return Tooltip(
                message: "Juz $juz, Hizb $hizbNum",
                child: HizbBlockView(
                    active: false,
                    index: index,
                    height: height,
                    onTap: () {
                      ref
                          .read(cursorProvider.notifier)
                          .teleportTo(hizb.startSura, hizb.startVerse);
                      ref.read(homeProvider.notifier).toggleFrame(); // Hide frame
                    }),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quranNavigatorProvider);
    final hizbState = ref.watch(hizbListProvider);

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
                  placeholder: "Sourate, récitateur...",
                  textChanged: (text) {
                    ref.read(quranNavigatorProvider.notifier).search(text);
                  },
                ),
              ),
              SizedBox(height: 2.sp),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 6.sp),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 6.sp,
                          ),
                          if (state.relevantElements.length ==
                              state.allElements.length)
                            _buildHizbList(hizbState, ref),
                          SizedBox(
                            width: 5.5.sp,
                          ),
                          Flexible(
                              flex: 10, // TODO: make this cleaner
                              child: _buildSuraList(ref, state))
                        ]),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
