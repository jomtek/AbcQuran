import 'package:abc_quran/providers/settings/settings_provider.dart';
import 'package:abc_quran/ui/app/app_theme.dart';
import 'package:abc_quran/ui/views/quran/read/cursor/cursor_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'mushaf/quran_mushaf_view.dart';
import 'text/quran_text_view.dart';

class ReadView extends ConsumerWidget {
  const ReadView({required this.pageController, Key? key}) : super(key: key);

  final PageController pageController;

  Widget _buildBottomBarContainer({required Widget child}) {
    return Container(
        height: 15.sp,
        margin: EdgeInsets.symmetric(vertical: 1.5.sp),
        padding: EdgeInsets.symmetric(horizontal: 4.sp),
        color: Colors.black12,
        child: Center(child: child));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cursor = ref.watch(cursorProvider);
    final settings = ref.watch(settingsProvider);

    return Column(
      children: [
        Expanded(
            child: settings.showMushaf
                ? QuranMushafView(
                    pageController: pageController,
                  )
                : QuranTextView(
                    pageController: pageController,
                  )),
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
                      _buildBottomBarContainer(
                        child: Row(
                          children: [
                            Padding(
                                padding: EdgeInsets.all(0.75.sp),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(360),
                                  child: Image.asset(
                                      "assets/qari_test_shuraim.png"),
                                )),
                            SizedBox(
                              width: 2.5.sp,
                            ),
                            Text("Saud Al-Shuraim (Tarawih 1984)",
                                style: GoogleFonts.inter(fontSize: 3.75.sp)),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 2.5.sp,
                      ),
                      _buildBottomBarContainer(
                        child: Text(cursor.sura.toString(),
                            style: GoogleFonts.inter(fontSize: 4.sp)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: Row(
                  children: [
                    SizedBox(
                      width: 2.5.sp,
                    ),
                    Icon(
                      Icons.volume_up,
                      size: 7.sp,
                    ),
                    SizedBox(
                      width: 5.sp,
                    ),
                    Icon(Icons.fast_rewind, size: 8.sp),
                    Icon(Icons.play_circle, size: 9.sp),
                    Icon(Icons.fast_forward, size: 8.sp),
                    const Spacer(flex: 5),
                    Container(
                        width: 50.sp,
                        decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            border:
                                Border.all(color: Colors.black38, width: 1.25)),
                        margin: EdgeInsets.symmetric(vertical: 1.75.sp),
                        child: Row(
                          children: [
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
                                      child: Text("Text",
                                          style: GoogleFonts.inter(
                                              fontSize: 3.5.sp))),
                                ),
                              ),
                            ),
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
                                      child: Text("Mushaf",
                                          style: GoogleFonts.inter(
                                              fontSize: 3.5.sp))),
                                ),
                              ),
                            ),
                          ],
                        )),
                    const Spacer(),
                    Icon(
                      Icons.favorite_rounded,
                      color: AppTheme.accentColor,
                      size: 7.sp,
                      shadows: [
                        Shadow(
                            color: AppTheme.accentColor.withOpacity(0.5),
                            blurRadius: 20.0)
                      ],
                    ),
                    SizedBox(
                      width: 5.sp,
                    ),
                  ],
                ))
              ],
            )),
      ],
    );
  }
}
