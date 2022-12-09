import 'package:abc_quran/ui/components/sidebar/abc_sidebar.dart';
import 'package:abc_quran/ui/components/sidebar/sidebar_item.dart';
import 'package:abc_quran/ui/components/sidebar/state/sidebar_vm.dart';
import 'package:abc_quran/ui/views/quran/sura_menu/sura_menu_view.dart';
import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeView extends ConsumerWidget {
  HomeView({Key? key}) : super(key: key);

  final _pageController = PageController();

  List<CollapsibleItem> get _items {
    return [
      CollapsibleItem(
        text: 'Dashboard',
        icon: Icons.assessment,
        onPressed: () {},
        isSelected: true,
      ),
      CollapsibleItem(
        text: 'Ice-Cream',
        icon: Icons.icecream,
        onPressed: () {},
      ),
      CollapsibleItem(
        text: 'Search',
        icon: Icons.search,
        onPressed: () {},
      ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(children: [
        Padding(
          padding: EdgeInsets.only(left: 12.5.sp < 55 ? 55 : 12.5.sp),
          child: PageView(
            controller: _pageController,
            children: const [
              SuraMenuView(),
              Center(
                child: Text('Contribution'),
              ),
              Center(
                child: Text('Paramètres'),
              ),
            ],
          ),
        ),
        AbcSidebar([
          SidebarItem("Lire et écouter", Icons.menu_book, true),
          SidebarItem("Contribution", Icons.handshake, false),
          SidebarItem("Paramètres", Icons.settings, false)
        ])
      ]),
    );
  }
}
