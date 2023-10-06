import 'package:abc_quran/localization/app_localization.dart';
import 'package:abc_quran/providers/player/player_provider.dart';
import 'package:abc_quran/providers/reciter/current_reciter_provider.dart';
import 'package:abc_quran/providers/settings/settings_provider.dart';
import 'package:abc_quran/providers/sura/current_sura_provider.dart';
import 'package:abc_quran/ui/app/app_theme.dart';
import 'package:abc_quran/ui/app/views/contribute/contribute_view.dart';
import 'package:abc_quran/ui/app/views/contribute/state/contribute_vm.dart';
import 'package:abc_quran/ui/app/views/frames/quran_navigator/quran_navigator_frame.dart';
import 'package:abc_quran/ui/app/views/frames/reciters_navigator/quran_navigator_frame.dart';
import 'package:abc_quran/ui/app/views/home/state/home_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'mushaf/quran_mushaf_view.dart';
import 'text/quran_text_view.dart';

class ReadView extends ConsumerWidget {
  const ReadView({Key? key}) : super(key: key);

  Widget _buildBottomBarContainer(
      {required Widget child, required Function() onTap}) {
    return Container(
      height: 15.sp,
      margin: EdgeInsets.symmetric(vertical: 1.5.sp),
      child: Material(
        color: Colors.black.withOpacity(0.16),
        child: InkWell(
          splashColor: AppTheme.goldenColor,
          onTap: onTap,
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.sp),
              child: Center(child: child)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final player = ref.watch(playerProvider);

    final reciter = ref.watch(currentReciterProvider);
    final sura = ref.watch(currentSuraProvider);
    final contribute = ref.watch(contributeVmProvider);

    // TODO: (!) Whenever the sura changes, window loses focus and the KBAR menu doesn't show up anymore

    return Stack(alignment: Alignment.bottomLeft, children: [
      Column(
        children: [
          Expanded(
            child: settings.showMushaf
                ? const QuranMushafView()
                : const QuranTextView(),
          ),
          Container(
              decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  border: Border(
                      top: BorderSide(color: AppTheme.darkColor, width: 2.5))),
              height: 14.sp > 75 ? 75 : 14.sp,
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 6.sp,
                        ),
                        TextButton(
                          onPressed: () {
                            ref
                                .read(contributeVmProvider.notifier)
                                .setIsContributing(!contribute.isContributing);
                          },
                          child: Text(
                              contribute.isContributing
                                  ? AppLocalization.of(context)!
                                      .translate("cancel")
                                  : AppLocalization.of(context)!
                                      .translate("contribute"),
                              style: TextStyle(fontSize: 4.5.sp)),
                        ),
                        const Spacer(),
                        _buildBottomBarContainer(
                          onTap: () {
                            ref
                                .read(homeVmProvider.notifier)
                                .setFrame(RecitersNavigatorFrame());
                            ref.read(homeVmProvider.notifier).toggleFrame();
                          },
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minWidth: 50.sp),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (reciter.photoUrl != null)
                                  Row(
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.all(0.75.sp),
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(360),
                                              child: Image.network(
                                                  reciter.photoUrl!))),
                                      SizedBox(
                                        width: 2.5.sp,
                                      ),
                                    ],
                                  ),
                                Text(reciter.displayName,
                                    style: TextStyle(
                                        fontSize: 3.75.sp,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 2.5.sp,
                        ),
                        _buildBottomBarContainer(
                          onTap: () {
                            ref
                                .read(homeVmProvider.notifier)
                                .setFrame(const QuranNavigatorFrame());
                            ref.read(homeVmProvider.notifier).toggleFrame();
                          },
                          child: Text(sura.pretty(settings.languageId),
                              style: TextStyle(
                                  fontSize: 4.sp, fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Row(
                    children: [
                      SizedBox(
                        width: 8.sp,
                      ),
                      Material(
                        child: AbsorbPointer(
                          absorbing: sura.id == 1,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(360),
                            onTap: () {
                              final previous = ref
                                  .read(currentSuraProvider.notifier)
                                  .whatsBefore();
                              ref
                                  .read(currentSuraProvider.notifier)
                                  .setSura(previous);
                            },
                            child: Icon(Icons.fast_rewind,
                                color: sura.id == 1 ? Colors.grey : null,
                                size: 8.sp),
                          ),
                        ),
                      ),
                      Material(
                        child: InkWell(
                            borderRadius: BorderRadius.circular(360),
                            onTap: () {
                              ref.read(playerProvider.notifier).play();
                              return;
                            },
                            child: Icon(
                                player.isPlaying
                                    ? Icons.pause_sharp
                                    : Icons.play_arrow_sharp,
                                size: 10.sp)),
                      ),
                      Material(
                          child: AbsorbPointer(
                        absorbing: sura.id == 114,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(360),
                          onTap: () {
                            final next = ref
                                .read(currentSuraProvider.notifier)
                                .whatsNext();
                            ref
                                .read(currentSuraProvider.notifier)
                                .setSura(next);
                          },
                          child: Icon(Icons.fast_forward,
                              color: sura.id == 114 ? Colors.grey : null,
                              size: 8.sp),
                        ),
                      )),
                      SizedBox(width: 3.sp),
                      Material(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(360),
                          onTap: () {
                            ref.read(playerProvider.notifier).toggleLoopMode();
                          },
                          child: Icon(Icons.loop_rounded,
                              color: player.isLooping
                                  ? AppTheme.goldenColor
                                  : null,
                              size: 8.sp),
                        ),
                      ),
                      const Spacer(flex: 5),
                      Container(
                          width: 50.sp,
                          decoration: BoxDecoration(
                              color: AppTheme.primaryColor,
                              border: Border.all(
                                  color: Colors.black38, width: 1.25)),
                          margin: EdgeInsets.symmetric(vertical: 1.75.sp),
                          child: Row(
                            children: [
                              Expanded(
                                child: Material(
                                  color: settings.showMushaf
                                      ? AppTheme.goldenColor
                                      : AppTheme.primaryColor,
                                  child: InkWell(
                                    onTap: () {
                                      ref
                                          .read(settingsProvider.notifier)
                                          .setShowMushaf(true);
                                    },
                                    child: Center(
                                        child: Text(
                                            AppLocalization.of(context)!
                                                .translate("mushaf"),
                                            style: TextStyle(
                                                fontSize: 3.5.sp))),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Material(
                                  color: settings.showMushaf
                                      ? AppTheme.primaryColor
                                      : AppTheme.goldenColor,
                                  child: InkWell(
                                    onTap: () {
                                      ref
                                          .read(settingsProvider.notifier)
                                          .setShowMushaf(false);
                                    },
                                    child: Center(
                                        child: Text(
                                            AppLocalization.of(context)!
                                                .translate("text"),
                                            style: TextStyle(
                                                fontSize: 3.5.sp))),
                                  ),
                                ),
                              ),
                            ],
                          )),
                      SizedBox(
                        width: 8.sp,
                      ),
                    ],
                  ))
                ],
              )),
        ],
      ),
      if (contribute.isContributing)
        Padding(
          padding: EdgeInsets.only(bottom: 14.sp),
          child: const ContributeView(),
        )
    ]);
  }
}
