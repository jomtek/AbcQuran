import 'package:abc_quran/ui/app/app_theme.dart';
import 'package:abc_quran/ui/components/sidebar/sidebar_item.dart';
import 'package:abc_quran/ui/components/sidebar/state/sidebar_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AbcSidebar extends ConsumerWidget {
  const AbcSidebar(this.items, {Key? key, required this.onTap})
      : super(key: key);

  final List<SidebarItem> items;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sidebarVmProvider);

    const animationDuration = Duration(milliseconds: 300);

    return InkWell(
        onTap: () {},
        onHover: (isHovering) {
          ref.read(sidebarVmProvider.notifier).setCollapsed(!isHovering);
        },
        child: AnimatedContainer(
            width: state.isCollapsed
                ? (12.5.sp < 55 ? 55 : 12.5.sp)
                : (47.5.sp < 150 ? 150 : 47.5.sp),
            decoration:
                BoxDecoration(color: AppTheme.darkColor, boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                spreadRadius: 5,
                blurRadius: 20,
                offset: Offset(0, 15),
              ),
            ]),
            curve: Curves.ease,
            duration: animationDuration,
            child: Column(
              children: [
                SizedBox(height: 4.sp),
                AnimatedContainer(
                  duration: animationDuration,
                  curve: Curves.ease,
                  width: state.isCollapsed ? 5.sp : 35.sp,
                  child: Text("AbcQuran",
                      overflow: TextOverflow.clip,
                      softWrap: false,
                      style: TextStyle(
                          fontSize: 7.5.sp, color: AppTheme.primaryColor)),
                ),
                SizedBox(height: 1.sp),
                AnimatedContainer(
                    duration: animationDuration,
                    curve: Curves.ease,
                    height: 1.sp,
                    width: state.isCollapsed ? 7.5.sp : 35.sp,
                    decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(25))),
                SizedBox(height: 3.sp),
                for (final item in items)
                  Material(
                    color: item.id == state.selectedPage
                        ? Colors.black26
                        : Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        ref
                            .read(sidebarVmProvider.notifier)
                            .selectPage(item.id);
                        onTap(item.id);
                      },
                      splashColor: Colors.transparent,
                      hoverColor: item.id == state.selectedPage
                          ? Colors.transparent
                          : Colors.black12,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.5.sp, horizontal: 3.sp),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedContainer(
                              duration: animationDuration,
                              curve: Curves.ease,
                              width: state.isCollapsed ? 0 : 35.sp,
                              child: Text(item.title,
                                  softWrap: false,
                                  style: TextStyle(
                                      color: AppTheme.primaryColor,
                                      fontSize: 4.5.sp)),
                            ),
                            Icon(
                              item.icon,
                              color: AppTheme.primaryColor,
                              size: 6.5.sp,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
              ],
            )));
  }
}
