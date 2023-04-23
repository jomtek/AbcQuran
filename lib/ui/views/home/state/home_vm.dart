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
