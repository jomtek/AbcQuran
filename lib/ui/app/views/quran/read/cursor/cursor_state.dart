class CursorState {
  // Independent
  final int page;

  // Common
  // The bookmark should be confined in a single sura
  final int bookmarkStart; // ayah num
  final int bookmarkStop; // ayah num

  CursorState(
      {required this.page,
      required this.bookmarkStart,
      required this.bookmarkStop});

  factory CursorState.initial() {
    return CursorState(page: 1, bookmarkStart: 1, bookmarkStop: 1);
  }

  CursorState copyWith({int? page, int? bookmarkStart, int? bookmarkStop}) {
    return CursorState(
        page: page ?? this.page,
        bookmarkStart: bookmarkStart ?? this.bookmarkStart,
        bookmarkStop: bookmarkStop ?? this.bookmarkStop);
  }
}
