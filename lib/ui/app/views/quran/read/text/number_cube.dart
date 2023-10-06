import 'package:abc_quran/ui/app/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NumberCube extends StatefulWidget {
  const NumberCube({super.key, required this.id, required this.onTap});

  final int id;
  final Function(int) onTap;

  @override
  State<NumberCube> createState() => _NumberCubeState();
}

class _NumberCubeState extends State<NumberCube> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap(widget.id);
      },
      onHover: (e) {
        setState(() {
          _hovered = !_hovered;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.075),
              borderRadius: BorderRadius.circular(12),
              border: _hovered
                  ? Border.all(color: AppTheme.goldenColor, width: 0.8.sp)
                  : null),
          width: 12.sp > 50 ? 50 : 12.sp,
          height: 12.sp > 50 ? 50 : 12.sp,
          child: Center(
              child: IgnorePointer(
            child: widget.id == 0
                ? Container(
                    width: 5.sp,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.lightColor,
                    ),
                  )
                : Text(widget.id.toString(),
                    style: TextStyle(
                        fontSize: 4.sp > 17 ? 17 : 4.sp,
                        fontWeight: FontWeight.w500)),
          ))),
    );
  }
}
