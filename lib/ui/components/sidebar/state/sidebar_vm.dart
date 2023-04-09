import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'sidebar_state.dart';

final sidebarVmProvider =
    StateNotifierProvider<SidebarNotifier, SidebarState>((ref) {
  return SidebarNotifier(ref);
});

class SidebarNotifier extends StateNotifier<SidebarState> {
  final StateNotifierProviderRef<SidebarNotifier, SidebarState> _ref;
  SidebarNotifier(this._ref) : super(SidebarState.initial());

  void setCollapsed(bool collapsed) {
    state = state.copyWith(isCollapsed: collapsed);
  }

  void selectPage(int page) {
    state = state.copyWith(selectedPage: page);
  }
}