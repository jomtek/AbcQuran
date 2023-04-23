import 'package:abc_quran/providers/current_reciter_provider.dart';
import 'package:abc_quran/providers/reciter_list_provider.dart';
import 'package:abc_quran/ui/app/app_theme.dart';
import 'package:abc_quran/ui/views/frames/reciters_navigator/results/reciter_result_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecitersNavigatorFrame extends ConsumerWidget {
  RecitersNavigatorFrame({super.key});

  final scrollController = ScrollController();

  Widget buildReciterList(BuildContext context, WidgetRef ref) {
    final reciters = ref.watch(reciterListProvider);

    final selectedReciter = ref.watch(currentReciterProvider);

    return Scrollbar(
      controller: scrollController,
      thumbVisibility: true,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: GridView.builder(
          itemCount: reciters.length,
          controller: scrollController,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemBuilder: (BuildContext context, int index) {
            final reciter = reciters[index];
            return ReciterResultView(
                selected: reciter.id == selectedReciter.id,
                reciter: reciter,
                onTap: (r) {
                  ref.read(currentReciterProvider.notifier).setReciter(r);
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
              Expanded(child: buildReciterList(context, ref))
            ],
          )),
    );
  }
}
