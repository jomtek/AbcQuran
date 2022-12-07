import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'mushaf/quran_mushaf_view.dart';

class ReadView extends ConsumerWidget {
  const ReadView({required this.pageController, Key? key}) : super(key: key);

  final PageController pageController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        SizedBox(height: 0.0225.sh),
        Expanded(child: QuranMushafView(pageController: pageController,)),
        Container(color: Colors.red, height: 50)
      ],
    );
  }
}
