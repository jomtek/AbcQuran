import 'package:abc_quran/ui/app/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HizbBlockView extends StatefulWidget {
  const HizbBlockView(
      {super.key,
      required this.active,
      required this.index,
      required this.height,
      required this.onTap});

  final bool active;
  final int index;
  final double height;
  final Function() onTap;

  @override
  State<HizbBlockView> createState() => _HizbBlockViewState();
}

class _HizbBlockViewState extends State<HizbBlockView> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          widget.onTap();
        },
        onHover: (e) {
          setState(() {
            _isHovering = !_isHovering;
          });
        },
        child: Container(
            decoration: BoxDecoration(
                color: widget.index % 2 == 0
                    ? AppTheme.lightColor
                    : AppTheme.darkColor,
                border: Border(
                    left: BorderSide(
                        color: _isHovering || widget.active
                            ? AppTheme.goldenColor
                            : Colors.transparent,
                        width: 5.5.sp))), // Half of the block width
            height: widget.height.sp));
  }
}
