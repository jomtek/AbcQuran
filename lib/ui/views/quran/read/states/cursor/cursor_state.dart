
import 'package:abc_quran/models/revelation_type.dart';
import 'package:abc_quran/models/sura.dart';

class CursorState {
  final SuraModel sura;
  final int page;

  CursorState(
      {required this.sura, required this.page});

  factory CursorState.initial() {
    return CursorState(sura: SuraModel(0,0,"","",RevelationType.mh), page: 0);
  }

  CursorState copyWith(
      {SuraModel? sura, int? page}) {
    return CursorState(
        sura: sura ?? this.sura, page: page ?? this.page);
  }
}
