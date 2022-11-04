import 'package:abc_quran/ui/views/quran/read/read_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuranTextView extends ConsumerWidget {
  const QuranTextView({required this.pageController, Key? key}) : super(key: key);

  final PageController pageController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(readProvider);

    return Container(color: Colors.purple, child: Center(child: Text(state.sura.translatedName)));
  }
}