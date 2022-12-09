import 'package:abc_quran/ui/app/app_theme.dart';
import 'package:abc_quran/ui/components/sidebar/sidebar_item.dart';
import 'package:abc_quran/ui/components/sidebar/state/sidebar_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AbcSidebar extends ConsumerWidget {
  const AbcSidebar(this.items, {Key? key}) : super(key: key);

  final List<SidebarItem> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sidebarVmProvider);

    return InkWell(
        onTap: () {},
        onHover: (isHovering) {
          ref.read(sidebarVmProvider.notifier).setCollapsed(!isHovering);
        },
        child: AnimatedContainer(
            width: state.isCollapsed
                ? (12.5.sp < 55 ? 55 : 12.5.sp)
                : (47.5.sp < 150 ? 150 : 47.5.sp),
            decoration: BoxDecoration(
                color: AppTheme.darkColor,
                borderRadius:
                    const BorderRadius.only(topRight: Radius.circular(0)),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    spreadRadius: 5,
                    blurRadius: 20,
                    offset: Offset(0, 15),
                  ),
                ]),
            curve: Curves.ease,
            duration: const Duration(milliseconds: 200),
            child: Column(
              children: [
                SizedBox(height: 4.sp),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
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
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.ease,
                    height: 1.sp,
                    width: state.isCollapsed ? 7.5.sp : 35.sp,
                    decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(25))),
                SizedBox(height: 3.sp),
                for (final item in items)
                  Material(
                    color:
                        item.isSelected ? Colors.black26 : Colors.transparent,
                    child: InkWell(
                      onTap: () {},
                      splashColor: Colors.transparent,
                      hoverColor:
                          item.isSelected ? Colors.transparent : Colors.black12,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.5.sp, horizontal: 3.sp),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
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
