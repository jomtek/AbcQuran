import 'package:abc_quran/ui/views/quran/menu/state/menu_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuView extends ConsumerWidget {
  const MenuView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    final state = ref.watch(menuProvider);

    if (state.suras.isEmpty) {
      return const Center(
          child: Text("Loading sura list...", style: TextStyle(fontSize: 38)));
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
              onTap: () {},
              child: Container(
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
}
