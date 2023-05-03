import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_state.dart';

final homeVmProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier();
});

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(HomeState.initial());

  void toggleFrame() {
    state = state.copyWith(isFrameShown: !state.isFrameShown);
  }

  void setFrame(Widget frame) {
    state = state.copyWith(frame: frame);
  }
}
