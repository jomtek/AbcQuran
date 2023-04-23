import 'package:abc_quran/providers/sura_info_provider.dart';
import 'package:abc_quran/ui/views/quran/read/read_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'state/sura_menu_vm.dart';

class SuraMenuView extends ConsumerStatefulWidget {
  const SuraMenuView({Key? key}) : super(key: key);

  @override
  SuraMenuViewState createState() => SuraMenuViewState();
}

class SuraMenuViewState extends ConsumerState<SuraMenuView>
    with AutomaticKeepAliveClientMixin<SuraMenuView> {
  final pageController = PageController();

  Widget _buildListing(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    final suraList = ref.watch(suraListProvider);

    if (suraList.isEmpty) {
      return const Center(
          child:
              Text("Loading sura listing...", style: TextStyle(fontSize: 38)));
    } else {
      return GridView.builder(
        itemCount: 114,
        physics: const ScrollPhysics(),
        scrollDirection: Axis.vertical,
        controller: ScrollController(),
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6),
        itemBuilder: (BuildContext context, int index) {
          final sura = suraList[index];
          return Material(
            color: (index % 2) == ((index ~/ 6) % 2)
                ? Colors.green.shade100
                : Colors.green.shade200,
            child: InkWell(
              hoverColor: Colors.green.shade300,
              splashColor: (index % 2) == ((index ~/ 6) % 2)
                  ? Colors.green.shade100
                  : Colors.green.shade200,
              onTap: () {
                ref.read(suraMenuProvider.notifier).select(sura);
                pageController.jumpToPage(1);
              },
              child: SizedBox(
                height: size.height / 7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(sura.id.toString(), style: TextStyle(fontSize: 5.sp)),
                    Text(sura.phoneticName,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 6.sp)),
                    Text(sura.translatedName,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 4.sp)),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PageView(
      controller: pageController,
      children: [
        _buildListing(context, ref),
        ReadView(pageController: pageController),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
