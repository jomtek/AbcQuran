class SidebarState {
  final bool isCollapsed;

  SidebarState({required this.isCollapsed});

  factory SidebarState.initial() {
    return SidebarState(isCollapsed: true);
  }

  SidebarState copyWith({bool? isCollapsed}) {
    return SidebarState(isCollapsed: isCollapsed ?? this.isCollapsed);
  }
}
