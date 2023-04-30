import 'package:abc_quran/models/reciter.dart';
import 'package:abc_quran/ui/app/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ReciterResultView extends StatefulWidget {
  const ReciterResultView(
      {super.key,
      required this.selected,
      required this.reciter,
      required this.onTap});

  final bool selected;
  final ReciterModel reciter;
  final Function(ReciterModel) onTap;

  @override
  State<ReciterResultView> createState() => _ReciterResultViewState();
}

class _ReciterResultViewState extends State<ReciterResultView> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap(widget.reciter);
      },
      onHover: (e) {
        setState(() {
          isHovering = !isHovering;
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.reciter.photoUrl != null)
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                SizedBox(
                    width: 40.sp,
                    height: 32.sp,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          widget.reciter.photoUrl!,
                          fit: BoxFit.cover,
                        ))),
                if (!widget.reciter.stable)
                  Container(
                    color: Colors.yellow,
                    padding: EdgeInsets.symmetric(horizontal: 4.sp, vertical: 1.sp),
                    child: Text("Unstable", style: GoogleFonts.inter(fontSize: 4.sp, fontWeight: FontWeight.bold)))
              ]),
            SizedBox(height: 2.sp),
            AnimatedContainer(
                duration: const Duration(milliseconds: 75),
                height: 0.6.sp,
                width: double.infinity,
                color: (isHovering || widget.selected)
                    ? AppTheme.mediumColor
                    : Colors.black12),
            SizedBox(height: 2.sp),
            Text(
              widget.reciter.firstName,
              style: GoogleFonts.inter(
                  fontSize: 3.5.sp, fontWeight: FontWeight.w500),
            ),
            Text(
              widget.reciter.lastName,
              style: GoogleFonts.inter(
                  fontSize: 4.5.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
