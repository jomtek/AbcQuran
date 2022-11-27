import 'package:abc_quran/ui/views/quran/read/mushaf/quran_mushaf_view.dart';
import 'package:abc_quran/ui/views/quran/read/text/quran_text_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'state/sura_menu_viewmodel.dart';

class SuraMenuView extends ConsumerStatefulWidget {
  const SuraMenuView({Key? key}) : super(key: key);

  @override
  SuraMenuViewState createState() => SuraMenuViewState();
}

class SuraMenuViewState extends ConsumerState<SuraMenuView> with AutomaticKeepAliveClientMixin<SuraMenuView> {
  final pageController = PageController();

  Widget _buildListing(BuildContext context, WidgetRef ref) {
        final size = MediaQuery.of(context).size;

    final state = ref.watch(suraMenuProvider);

    if (state.suras.isEmpty) {
      return const Center(
          child: Text("Loading sura listing...", style: TextStyle(fontSize: 38)));
    } else {
      return GridView.builder(
        itemCount: 114,
        physics: const ScrollPhysics(),
        scrollDirection: Axis.vertical,
        controller: ScrollController(),
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6),
        itemBuilder: (BuildContext context, int index) {
          final sura = state.suras[index];
          return Material(
                          color: (index % 2) == ((index ~/ 6) % 2)
                  ? Colors.green.shade100
                  : Colors.green.shade200,
            child: InkWell(
              hoverColor: Colors.green.shade300,
              splashColor: (index % 2) == ((index ~/ 6) % 2)
                  ? Colors.green.shade100
                  : Colors.green.shade200,
              onHover: (_) {
                print("hey");
              },
              onTap: () {
                ref.read(suraMenuProvider.notifier).select(sura);
                pageController.jumpToPage(1);
              },
              child: SizedBox(
                height: size.height / 7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(sura.id.toString(), style: const TextStyle(fontSize: 22)),
                    Text(sura.phoneticName, style: const TextStyle(fontSize: 18)),
                    Text(sura.translatedName, style: const TextStyle(fontSize: 16)),
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
    return PageView(controller: pageController, children: [
      _buildListing(context, ref),
      QuranMushafView(pageController: pageController,),
    ],);
  }
  
  @override
  bool get wantKeepAlive => true;
}