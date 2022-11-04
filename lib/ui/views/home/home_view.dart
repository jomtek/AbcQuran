import 'package:abc_quran/ui/views/quran/sura_menu/sura_menu_view.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerWidget {
  HomeView({Key? key}) : super(key: key);

  final page = PageController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          MouseRegion(
            onEnter: (_) {},
            onExit: (_) {},
            child: SideMenu(
              controller: page,
              collapseWidth: 0,
              title: const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Text("AbcQuran", style: TextStyle(fontSize: 27.5)),
              ),
              footer: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Currently in development"),
                    SizedBox(height: 4),
                    SelectableText("https://github.com/jomtek/AbcQuran"),
                  ],
                ),
              ),
              items: [
                SideMenuItem(
                  priority: 0,
                  title: 'Lire et écouter',
                  onTap: () => page.jumpToPage(0),
                  icon: const Icon(Icons.menu_book),
                ),
                SideMenuItem(
                  priority: 1,
                  title: 'Contribution',
                  onTap: () => page.jumpToPage(1),
                  icon: const Icon(Icons.handshake),
                ),
                SideMenuItem(
                  priority: 2,
                  title: 'Paramètres',
                  onTap: () => page.jumpToPage(2),
                  icon: const Icon(Icons.settings),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: page,
              children: [
                SuraMenuView(),
                const Center(
                  child: Text('Contribution'),
                ),
                const Center(
                  child: Text('Paramètres'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
