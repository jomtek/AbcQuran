import 'package:abc_quran/models/sura.dart';
import 'package:flutter/material.dart';

class QuranNavigatorState {
  final List<SuraModel> allElements;
  final List<SuraModel> relevantElements;

  // Keep the scroll state
  final ScrollController scrollController;

  QuranNavigatorState(
      {required this.allElements,
      required this.relevantElements,
      required this.scrollController});

  factory QuranNavigatorState.initial() {
    return QuranNavigatorState(
        allElements: [],
        relevantElements: [],
        scrollController: ScrollController());
  }

  QuranNavigatorState copyWith(
      {List<SuraModel>? allElements,
      List<SuraModel>? relevantElements,
      ScrollController? scrollController}) {
    return QuranNavigatorState(
        allElements: allElements ?? this.allElements,
        relevantElements: relevantElements ?? this.relevantElements,
        scrollController: this.scrollController);
  }
}
