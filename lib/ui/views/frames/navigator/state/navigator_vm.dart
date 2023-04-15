import 'package:abc_quran/ui/views/frames/navigator/state/navigator_state2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final navigatorProvider = StateNotifierProvider<NavigatorNotifier, NavigatorState2>((ref) {
  return NavigatorNotifier(ref);
});

class NavigatorNotifier extends StateNotifier<NavigatorState2> {
  final StateNotifierProviderRef<NavigatorNotifier, NavigatorState2> _ref;

  NavigatorNotifier(this._ref) : super(NavigatorState2.initial());

}
