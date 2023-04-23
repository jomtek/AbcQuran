import 'package:abc_quran/models/sura.dart';

class CursorState {
  // Independent
  final SuraModel? sura;
  // Independent
  final int page;

  // Common
  // The bookmark should be confined in a single sura
  final int bookmarkStart; // ayah num
  final int bookmarkStop; // ayah num

  CursorState(
      {this.sura,
      required this.page,
      required this.bookmarkStart,
      required this.bookmarkStop});

  factory CursorState.initial() {
    return CursorState(page: 3, bookmarkStart: 1, bookmarkStop: 1);
  }

  CursorState copyWith(
      {SuraModel? sura, int? page, int? bookmarkStart, int? bookmarkStop}) {
    return CursorState(
        sura: sura ?? this.sura,
        page: page ?? this.page,
        bookmarkStart: bookmarkStart ?? this.bookmarkStart,
        bookmarkStop: bookmarkStop ?? this.bookmarkStop);
  }
}
