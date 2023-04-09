class SidebarState {
  final bool isCollapsed;
  final int selectedPage;

  SidebarState({required this.isCollapsed, required this.selectedPage});

  factory SidebarState.initial() {
    return SidebarState(isCollapsed: true, selectedPage: 0);
  }

  SidebarState copyWith({bool? isCollapsed, int? selectedPage}) {
    return SidebarState(
        isCollapsed: isCollapsed ?? this.isCollapsed,
        selectedPage: selectedPage ?? this.selectedPage);
  }
}
