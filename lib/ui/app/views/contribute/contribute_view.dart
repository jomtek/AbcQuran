import 'package:abc_quran/localization/app_localization.dart';
import 'package:abc_quran/providers/player/player_provider.dart';
import 'package:abc_quran/providers/reciter/current_reciter_provider.dart';
import 'package:abc_quran/providers/sura/current_sura_provider.dart';
import 'package:abc_quran/ui/app/app_theme.dart';
import 'package:abc_quran/ui/app/views/contribute/state/contribute_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ContributeView extends ConsumerWidget {
  const ContributeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(contributeVmProvider);
    final sura = ref.watch(currentSuraProvider);
    final reciter = ref.watch(currentReciterProvider);
    final player = ref.watch(playerProvider);

    return Container(
        decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            boxShadow: const [
              BoxShadow(blurRadius: 20, color: Colors.black26)
            ]),
        width: 70.sp,
        height: 180.sp,
        child: Column(
          children: [
            SizedBox(height: 4.sp),
            Text(AppLocalization.of(context)!.translate("contribution_menu"),
                style: TextStyle(fontSize: 6.sp)),
            SizedBox(height: 4.sp),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 6.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "📚 ${AppLocalization.of(context)!.translate("data_for")} ${sura.phoneticName}",
                      style: TextStyle(
                          fontSize: 4.sp, fontWeight: FontWeight.bold)),
                  Text(
                      "👤 ${AppLocalization.of(context)!.translate("reciter")} : ${reciter.lastName} (${reciter.id})",
                      style: TextStyle(fontSize: 4.sp)),
                  SizedBox(height: 2.sp),
                  const Divider(),
                ],
              ),
            ),
            SizedBox(height: 1.sp),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => launchUrl(Uri.parse(
                      AppLocalization.of(context)!
                          .translate("contribution_guide_url"),
                    )),
                    child: Text(
                      AppLocalization.of(context)!
                          .translate("contribution_guide_label"),
                      style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue),
                    ),
                  ),
                  SizedBox(height: 4.sp),
                  Row(
                    children: [
                      Text(
                          "⏲️ ${AppLocalization.of(context)!.translate("curr_time")} :",
                          style: TextStyle(fontSize: 4.sp)),
                      SizedBox(
                        width: 2.sp,
                      ),
                      Text("${state.currentTime} ms",
                          style: TextStyle(
                              fontSize: 5.sp, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Slider(
                    min: 1,
                    max: 7,
                    value: player.playbackSpeed,
                    onChanged: (double value) {
                      ref.read(playerProvider.notifier).setPlaybackSpeed(value);
                    },
                  ),
                  SizedBox(height: 4.sp),
                  Row(
                    children: [
                      Expanded(
                          child: Center(
                              child: Text(AppLocalization.of(context)!
                                  .translate("original")))),
                      Expanded(
                          child: Center(
                              child: Text(AppLocalization.of(context)!
                                  .translate("new")))),
                    ],
                  ),
                  SizedBox(height: 1.sp),
                  SizedBox(
                    height: 60.sp,
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: player.timecodes.length,
                        itemBuilder: (BuildContext context, int index) {
                          final timecode = player.timecodes[index];
                          if (timecode.isEmpty) return Container();

                          final previousTimecode =
                              index > 0 ? state.newTimecodes[index - 1] : -1;

                          return Container(
                            color: index % 2 == 0
                                ? Colors.black12
                                : Colors.black26,
                            child: Row(
                              children: [
                                Expanded(
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 3.sp,
                                            top: 2.sp,
                                            bottom: 2.sp),
                                        child: Text(timecode,
                                            style: GoogleFonts.inter(
                                                fontSize: 4.sp)))),
                                SizedBox(
                                    height: 10.sp,
                                    child: VerticalDivider(
                                        thickness: 0.5.sp,
                                        width: 0.5.sp,
                                        color: Colors.black38)),
                                Expanded(
                                    child: Container(
                                  height: 10.sp,
                                  color: index == state.currentVerse
                                      ? AppTheme.goldenColor
                                      : null,
                                  child: Center(
                                    child: Text(
                                        state.newTimecodes[index] == -1
                                            ? ""
                                            : state.newTimecodes[index].toString() +
                                                (state.newTimecodes[index] <= previousTimecode
                                                    ? "⚠️"
                                                    : ""),
                                        style: GoogleFonts.inter(
                                            color: (state.newTimecodes[index] <=
                                                        previousTimecode
                                                    ? AppTheme.accentColor
                                                        .withOpacity(0.9)
                                                    : Colors.black)
                                                .withOpacity(
                                                    state.newTimecodes[index] ==
                                                            int.parse(player.timecodes[index])
                                                        ? 0.5
                                                        : 1),
                                            fontSize: 4.sp,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                )),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const Divider(),
                  if (!state.isSending)
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: MaterialButton(
                              onPressed: () {
                                ref
                                    .read(contributeVmProvider.notifier)
                                    .gotoPreviousTimecode();
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 4.sp),
                                child: Text(
                                    "<- ${AppLocalization.of(context)!.translate("previous_v")}",
                                    style: GoogleFonts.inter(
                                        fontSize: 4.sp,
                                        fontWeight: FontWeight.w500)),
                              )),
                        ),
                        Expanded(
                          flex: 4,
                          child: MaterialButton(
                            onPressed: () {
                              ref
                                  .read(contributeVmProvider.notifier)
                                  .saveTimecode();
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 4.sp),
                              child: Text(
                                  "${AppLocalization.of(context)!.translate("mark_v")} ->",
                                  style: GoogleFonts.inter(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (!state.isSending)
                    Row(
                      children: [
                        Expanded(
                          child: MaterialButton(
                            color: AppTheme.secundaryColor,
                            onPressed: () {
                              ref.read(contributeVmProvider.notifier).submit();
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 4.sp),
                              child: Text(
                                  AppLocalization.of(context)!
                                      .translate("submit"),
                                  style: GoogleFonts.inter(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ),
                        Expanded(
                          child: MaterialButton(
                            onPressed: () {
                              ref
                                  .read(contributeVmProvider.notifier)
                                  .skipTimecode();
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 4.sp),
                              child: Text(
                                  "${AppLocalization.of(context)!.translate("skip_v")} ->",
                                  style: GoogleFonts.inter(
                                      fontSize: 4.sp,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (state.isSending)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4.sp),
                        Text(
                            AppLocalization.of(context)!
                                .translate("sending_contributions"),
                            style: GoogleFonts.inter(fontSize: 5.sp)),
                        SizedBox(height: 1.sp),
                        Text(
                            "${state.contributionsSent} ${AppLocalization.of(context)!.translate("sent")}",
                            style: GoogleFonts.inter(fontSize: 5.sp)),
                      ],
                    )
                ],
              ),
            ),
          ],
        ));
  }
}
