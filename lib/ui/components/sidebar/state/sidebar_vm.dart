import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'sidebar_state.dart';

final sidebarVmProvider =
    StateNotifierProvider<SidebarNotifier, SidebarState>((ref) {
  return SidebarNotifier();
});

class SidebarNotifier extends StateNotifier<SidebarState> {
  SidebarNotifier() : super(SidebarState.initial());

  void setCollapsed(bool collapsed) {
    state = state.copyWith(isCollapsed: collapsed);
  }

  void selectPage(int page) {
    state = state.copyWith(selectedPage: page);
  }
}