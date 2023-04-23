import 'package:abc_quran/providers/reciter_info_provider.dart';
import 'package:abc_quran/ui/views/quran/read/cursor/cursor_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_state.dart';

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier(ref);
});

class HomeNotifier extends StateNotifier<HomeState> {
  final StateNotifierProviderRef<HomeNotifier, HomeState> _ref;

  HomeNotifier(this._ref) : super(HomeState.initial());

  void toggleFrame() {
    state = state.copyWith(isFrameShown: !state.isFrameShown);
  }

  void setFrame(Widget frame) {
    state = state.copyWith(frame: frame);
  }
}
